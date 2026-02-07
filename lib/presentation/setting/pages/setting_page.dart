import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_2/core/extensions/build_context_ext.dart';
import 'package:flutter_pos_2/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos_2/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos_2/presentation/common/widgets/logout_button.dart';
import 'package:flutter_pos_2/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos_2/presentation/setting/bloc/report/close_cashier/close_cashier_bloc.dart';
import 'package:flutter_pos_2/presentation/setting/pages/manage_printer_page.dart';
import 'package:flutter_pos_2/presentation/setting/pages/report/report_page.dart';
import 'package:flutter_pos_2/presentation/setting/pages/save_server_key_page.dart';
import 'package:flutter_pos_2/presentation/setting/pages/sync_data_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../home/bloc/logout/logout_bloc.dart';
import '../bloc/sync_order/sync_order_bloc.dart';
import 'manage_product_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.push(const DashboardPage());
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.manageProduct.path,
                      label: 'Manage Product',
                      onPressed: () => context.push(const ManageProductPage()),
                      isImage: true,
                    ),
                  ),
                  const SpaceWidth(15.0),
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.managePrinter.path,
                      label: 'Setting Printer',
                      onPressed: () {
                        context.push(const ManagePrinterPage());
                      },
                      isImage: true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.close.path,
                      label: 'Manage Category',
                      onPressed: () => context.push(const ManageProductPage()),
                      isImage: true,
                    ),
                  ),
                  const SpaceWidth(15.0),
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.report.path,
                      label: 'Report',
                      onPressed: () => context.push(const ReportPage()),
                      isImage: true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.manageQr.path,
                      label: 'QRIS Server Key',
                      onPressed: () => context.push(const SaveServerKeyPage()),
                      isImage: true,
                    ),
                  ),
                  const SpaceWidth(15.0),
                  Flexible(
                    child: MenuButton(
                      iconPath: Assets.images.sync.path,
                      label: 'Sync Data',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SyncDataPage(),
                          ),
                        );
                      },
                      isImage: true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(20.0),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: Row(
            //     children: [
            //       Flexible(
            //         child: MenuButton(
            //           iconPath: Assets.images.report.path,
            //           label: 'Report',
            //           onPressed: () => context.push(const ReportPage()),
            //           isImage: true,
            //         ),
            //       ),
            //       const SpaceWidth(15.0),
            //       Flexible(
            //         child: BlocListener<SyncOrderBloc, SyncOrderState>(
            //           listener: (context, state) {
            //             state.maybeMap(
            //               orElse: () {},
            //               successCloseChasier: (_) {
            //                 context.read<CloseCashierBloc>().add(
            //                   const CloseCashierEvent.closeCashier(),
            //                 );

            //                 context.pushReplacement(const LoginPage());
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                   const SnackBar(
            //                     backgroundColor: Colors.green,
            //                     content: Text('Close Kasir Success'),
            //                   ),
            //                 );
            //               },
            //             );
            //           },
            //           child: MenuButton(
            //             iconPath: Assets.images.close.path,
            //             label: 'Close Kasir',
            //             onPressed: () async {
            //               showDialog(
            //                 context: context,
            //                 builder: (context) {
            //                   return AlertDialog(
            //                     title: const Text('Close Kasir'),
            //                     content: const Text(
            //                       'Are you sure want to close kasir?',
            //                     ),
            //                     actions: [
            //                       TextButton(
            //                         onPressed: () {
            //                           Navigator.pop(context);
            //                         },
            //                         child: const Text('Cancel'),
            //                       ),
            //                       TextButton(
            //                         onPressed: () {
            //                           context.read<SyncOrderBloc>().add(
            //                             const SyncOrderEvent.sendOrderForCloseChasier(),
            //                           );
            //                           Navigator.pop(context);
            //                         },
            //                         child: const Text('Yes'),
            //                       ),
            //                     ],
            //                   );
            //                 },
            //               );
            //               // context.read<SyncOrderBloc>().add(
            //               //     const SyncOrderEvent.sendOrderForCloseChasier());
            //               // Navigator.push(
            //               //     context,
            //               //     MaterialPageRoute(
            //               //         builder: (context) => const SyncDataPage()));
            //             },
            //             isImage: true,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SpaceHeight(60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LogoutButton(),
            ),

            // const Divider(),
          ],
        ),
      ),
    );
  }
}
