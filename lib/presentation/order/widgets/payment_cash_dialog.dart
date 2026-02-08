import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/extensions/build_context_ext.dart';
import 'package:restoguh/core/extensions/int_ext.dart';
import 'package:restoguh/core/extensions/string_ext.dart';
import 'package:restoguh/data/datasources/order_remote_datasource.dart';
import 'package:restoguh/data/datasources/product_local_datasource.dart';
import 'package:restoguh/data/models/request/order_request_model.dart';
import 'package:restoguh/presentation/order/bloc/order/order_bloc.dart';
import 'package:restoguh/presentation/order/models/order_model.dart';
import 'package:restoguh/presentation/order/widgets/payment_success_dialog.dart';
import 'package:restoguh/presentation/reservation/bloc/reservation_bloc.dart';
import 'package:restoguh/presentation/reservation/bloc/reservation_event.dart';
import 'package:intl/intl.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class PaymentCashDialog extends StatefulWidget {
  final int price;
  final int tableId; // tambahkan ini
  const PaymentCashDialog({
    super.key,
    required this.price,
    required this.tableId,
  });

  @override
  State<PaymentCashDialog> createState() => _PaymentCashDialogState();
}

class _PaymentCashDialogState extends State<PaymentCashDialog> {
  TextEditingController?
  priceController; // = TextEditingController(text: widget.price.currencyFormatRp);

  @override
  void initState() {
    priceController = TextEditingController(
      text: widget.price.currencyFormatRp,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Stack(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.highlight_off),
            color: AppColors.primary,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'Payment - Cash ${widget.tableId}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceHeight(16.0),
          CustomTextField(
            controller: priceController!,
            label: '',
            showLabel: false,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final int priceValue = value.toIntegerFromText;
              priceController!.text = priceValue.currencyFormatRp;
              priceController!.selection = TextSelection.fromPosition(
                TextPosition(offset: priceController!.text.length),
              );
            },
          ),
          const SpaceHeight(16.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Button.filled(
          //       onPressed: () {},
          //       label: 'Uang Pas',
          //       disabled: true,
          //       textColor: AppColors.primary,
          //       fontSize: 13.0,
          //       width: 112.0,
          //       height: 50.0,
          //     ),
          //     const SpaceWidth(4.0),
          //     Flexible(
          //       child: Button.filled(
          //         onPressed: () {},
          //         label: widget.price.currencyFormatRp,
          //         disabled: true,
          //         textColor: AppColors.primary,
          //         fontSize: 13.0,
          //         height: 50.0,
          //       ),
          //     ),
          //   ],
          // ),
          const SpaceHeight(30.0),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) async {
              state.maybeWhen(
                orElse: () {},
                success:
                    (
                      data,
                      qty,
                      total,
                      payment,
                      nominal,
                      idKasir,
                      namaKasir,
                      _,
                    ) async {
                      final orderModel = OrderModel(
                        paymentMethod: payment,
                        nominalBayar: nominal,
                        orders: data,
                        totalQuantity: qty,
                        totalPrice: total,
                        idKasir: idKasir,
                        namaKasir: namaKasir,
                        transactionTime: DateFormat(
                          'yyyy-MM-ddTHH:mm:ss',
                        ).format(DateTime.now()),
                        isSync: false,
                      );

                      ProductLocalDatasource.instance.saveOrder(orderModel);

                      // ✅ BUAT RESERVATION
                      final reservationBloc = context.read<ReservationBloc>();

                      // pastikan ambil tableId dari selected table
                      final tableId = widget.tableId;

                      final date = DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.now());
                      final startTime = DateFormat(
                        'HH:mm',
                      ).format(DateTime.now());
                      final endTime = DateFormat(
                        'HH:mm',
                      ).format(DateTime.now().add(const Duration(hours: 2)));

                      reservationBloc.add(
                        CreateReservation(
                          tableId: tableId,
                          orderId: orderModel.id ?? 0,
                          date: date,
                          startTime: startTime,
                          endTime: endTime,
                          status: 'reserved',
                        ),
                      );

                      context.pop();

                      showDialog(
                        context: context,
                        builder: (context) => const PaymentSuccessDialog(),
                      );
                    },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox(),
                success: (data, qty, total, payment, _, idKasir, namaKasir, __) {
                  return Button.filled(
                    onPressed: () async {
                      final nominalBayar =
                          priceController!.text.toIntegerFromText;

                      if (nominalBayar < total) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nominal bayar kurang!'),
                          ),
                        );
                        return;
                      }

                      // 1. Tampilkan Loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      // 2. Siapkan Request Order
                      final orderRequest = OrderRequestModel(
                        transactionTime: DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(DateTime.now()),
                        kasirId: idKasir,
                        totalPrice: total,
                        totalItem: qty,
                        paymentMethod: 'CASH',
                        orderItems: data
                            .map(
                              (item) => OrderItemModel(
                                productId: item.product.id!,
                                quantity: item.quantity,
                                totalPrice: item.product.price * item.quantity,
                              ),
                            )
                            .toList(),
                      );

                      // 3. Kirim Order ke API
                      final result = await OrderRemoteDatasource().sendOrder(
                        orderRequest,
                      );

                      if (!mounted) return;
                      Navigator.pop(context); // Tutup loading

                      result.fold(
                        (error) => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error))),
                        (orderId) {
                          // ✅ 4. JIKA ORDER SUKSES, KIRIM RESERVASI
                          context.read<ReservationBloc>().add(
                            CreateReservation(
                              tableId: widget.tableId,
                              orderId: orderId, // Menggunakan ID dari server
                              date: DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.now()),
                              startTime: DateFormat(
                                'HH:mm:ss',
                              ).format(DateTime.now()),
                              endTime: DateFormat('HH:mm:ss').format(
                                DateTime.now().add(const Duration(hours: 2)),
                              ),
                              status: 'reserved', // Meja langsung merah
                            ),
                          );

                          // 5. Simpan ke Local Database (Optional/Offline Support)
                          final orderModel = OrderModel(
                            id: orderId,
                            paymentMethod: 'CASH',
                            nominalBayar: nominalBayar,
                            orders: data,
                            totalQuantity: qty,
                            totalPrice: total,
                            idKasir: idKasir,
                            namaKasir: namaKasir,
                            transactionTime: DateFormat(
                              'yyyy-MM-dd HH:mm:ss',
                            ).format(DateTime.now()),
                            isSync: true,
                          );
                          ProductLocalDatasource.instance.saveOrder(orderModel);

                          // 6. Selesai! Tutup Dialog Bayar dan Tampilkan Sukses
                          Navigator.pop(context); // Tutup PaymentCashDialog
                          showDialog(
                            context: context,
                            builder: (context) => const PaymentSuccessDialog(),
                          );
                        },
                      );
                    },
                    label: 'Pay Now',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
