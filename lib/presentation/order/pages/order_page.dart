import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/constants/colors.dart';
import 'package:flutter_pos_2/core/extensions/build_context_ext.dart';
import 'package:flutter_pos_2/core/extensions/string_ext.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/data/datasources/reservation_local_datasource.dart';
import 'package:flutter_pos_2/data/datasources/reservation_remote_datasource.dart';
import 'package:flutter_pos_2/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos_2/presentation/home/models/order_item.dart';
import 'package:flutter_pos_2/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos_2/presentation/reservation/bloc/reservation_bloc.dart';
import 'package:flutter_pos_2/presentation/table/models/table_model.dart';
import 'package:flutter_pos_2/presentation/table/pages/pilih_meja_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../../data/dataoutputs/cwb_print.dart';
import '../bloc/order/order_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/payment_cash_dialog.dart';
import '../widgets/payment_qris_dialog.dart';
import '../widgets/process_button.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final indexValue = ValueNotifier(0);
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();

  List<OrderItem> orders = [];
  TableModel? selectedTable;

  int totalPrice = 0;
  int calculateTotalPrice(List<OrderItem> orders) {
    return orders.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.quantity,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.push(const DashboardPage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //show dialog save order
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Open Bill'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //nomor meja
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Table Number',
                          ),
                          //number
                          keyboardType: TextInputType.number,
                          controller: tableNumberController,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Order Name',
                          ),
                          controller: orderNameController,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      BlocBuilder<CheckoutBloc, CheckoutState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return const SizedBox.shrink();
                            },
                            success: (data, qty, total, draftName) {
                              return Button.outlined(
                                onPressed: () async {
                                  final authData = await AuthLocalDatasource()
                                      .getAuthData();
                                  context.read<CheckoutBloc>().add(
                                    CheckoutEvent.saveDraftOrder(
                                      tableNumberController
                                          .text
                                          .toIntegerFromText,
                                      orderNameController.text,
                                    ),
                                  );

                                  final printInt = await CwbPrint.instance
                                      .printChecker(
                                        data,
                                        tableNumberController.text.toInt,
                                        orderNameController.text,
                                        authData?.user?.name ?? 'Guest',
                                      );

                                  //print for customer
                                  CwbPrint.instance.printReceipt(printInt);
                                  // //print for kitchen
                                  // CwbPrint.instance.printReceipt(printInt);
                                  //clear checkout
                                  context.read<CheckoutBloc>().add(
                                    const CheckoutEvent.started(),
                                  );
                                  //open bill success snack bar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Save Draft Order Success'),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );

                                  context.pushReplacement(
                                    const DashboardPage(),
                                  );
                                },
                                label: 'Save & Print',
                                fontSize: 14,
                                height: 40,
                                width: 140,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.save_as_outlined),
          ),
          const SpaceWidth(8),
        ],
      ),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(child: Text('No Data')),
            success: (data, qty, total, draftName) {
              if (data.isEmpty) {
                return const Center(child: Text('No Data'));
              }

              totalPrice = total;

              return Column(
                children: [
                  /// 🔝 PILIH MEJA (ATAS)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final result = await context.push<TableModel>(
                          const PilihMejaPage(),
                        );

                        if (result != null) {
                          setState(() {
                            selectedTable = result;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.orange),
                            const SpaceWidth(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pilih Meja',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    selectedTable == null
                                        ? 'Belum dipilih'
                                        : selectedTable!.name,
                                    style: TextStyle(
                                      color: selectedTable == null
                                          ? Colors.orange
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SpaceHeight(16),

                  /// 📜 LIST ORDER (SCROLL)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SpaceHeight(20),
                      itemBuilder: (context, index) => OrderCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        data: data[index],
                        onDeleteTap: () {
                          context.read<CheckoutBloc>().add(
                            CheckoutEvent.removeProduct(data[index].product),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const SizedBox.shrink();
                  },
                  success: (data, qty, total, draftName) {
                    return ValueListenableBuilder(
                      valueListenable: indexValue,
                      builder: (context, value, _) => Row(
                        children: [
                          Flexible(
                            child: MenuButton(
                              iconPath: Assets.icons.cash.path,
                              label: 'CASH',
                              isActive: value == 1,
                              onPressed: () {
                                indexValue.value = 1;
                                context.read<OrderBloc>().add(
                                  OrderEvent.addPaymentMethod(
                                    'Tunai',
                                    data,
                                    draftName,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SpaceWidth(16.0),
                          Flexible(
                            child: MenuButton(
                              iconPath: Assets.icons.qrCode.path,
                              label: 'QR',
                              isActive: value == 2,
                              onPressed: () {
                                indexValue.value = 2;
                                context.read<OrderBloc>().add(
                                  OrderEvent.addPaymentMethod(
                                    'QRIS',
                                    data,
                                    draftName,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SpaceWidth(16.0),
                          Flexible(
                            child: MenuButton(
                              iconPath: Assets.icons.debit.path,
                              label: 'TRANSFER',
                              isActive: value == 3,
                              onPressed: () {
                                indexValue.value = 3;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SpaceHeight(20.0),
            ProcessButton(
              price: 0,
              onPressed: () async {
                if (indexValue.value == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih metode pembayaran')),
                  );
                  return;
                }

                if (indexValue.value == 1) {
                  showDialog(
                    context: context,
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<OrderBloc>()),
                        BlocProvider(
                          create: (_) => ReservationBloc(
                            ReservationRemoteDatasource(),
                            ReservationLocalDatasource.instance,
                          ),
                        ),
                      ],
                      child: PaymentCashDialog(
                        price: totalPrice,
                        tableId: selectedTable?.id ?? 0, // ✅ tambahkan ini),
                      ),
                    ),
                  );
                }

                if (indexValue.value == 2) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => PaymentQrisDialog(price: totalPrice),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
