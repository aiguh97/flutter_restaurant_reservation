import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/auth/bloc/google_auth/google_auth_bloc.dart';
import 'package:restoguh/presentation/auth/bloc/register/register_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Core & Constants
import 'core/constants/colors.dart';
import 'core/assets/assets.gen.dart';

// Datasources
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/midtrans_remote_datasource.dart';
import 'data/datasources/order_remote_datasource.dart';
import 'data/datasources/product_local_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/report_remote_datasource.dart';

// Pages
import 'presentation/auth/pages/login_page.dart';
import 'presentation/home/pages/dashboard_page.dart';

// Blocs
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/home/bloc/logout/logout_bloc.dart';
import 'presentation/home/bloc/product/product_bloc.dart';
import 'presentation/home/bloc/checkout/checkout_bloc.dart';
import 'presentation/order/bloc/order/order_bloc.dart';
import 'presentation/order/bloc/qris/qris_bloc.dart';
import 'presentation/history/bloc/history/history_bloc.dart';
import 'presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'presentation/setting/bloc/category/category_bloc.dart';
import 'presentation/draft_order/bloc/draft_order/draft_order_bloc.dart';
import 'presentation/setting/bloc/report/summary/summary_bloc.dart';
import 'presentation/setting/bloc/report/product_sales/product_sales_bloc.dart';
import 'presentation/setting/bloc/report/close_cashier/close_cashier_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan plugin terinisialisasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(AuthRemoteDatasource())),
        BlocProvider(create: (context) => LogoutBloc(AuthRemoteDatasource())),
        BlocProvider(create: (context) => RegisterBloc(AuthRemoteDatasource())),

        BlocProvider(
          create: (context) =>
              ProductBloc(ProductRemoteDatasource())
                ..add(const ProductEvent.fetchLocal()),
        ),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(
          create: (context) => GoogleAuthBloc(AuthRemoteDatasource()),
        ),

        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (context) => QrisBloc(MidtransRemoteDatasource())),
        BlocProvider(create: (context) => HistoryBloc()),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        // Pastikan CategoryRepository sudah di-import atau ganti ke Datasource yang benar
        BlocProvider(create: (context) => CategoryBloc(CategoryRepository())),
        BlocProvider(
          create: (context) => DraftOrderBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => SummaryBloc(ReportRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductSalesBloc(ReportRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CloseCashierBloc(ReportRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'POS App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(color: AppColors.primary),
          ),
        ),
        // Routes untuk navigasi pushNamed
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const DashboardPage(),
        },
        // Auto-login logic
        home: FutureBuilder<bool>(
          future: AuthLocalDatasource().isAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // Jika auth benar (sudah login & punya token)
            if (snapshot.data == true) {
              return const DashboardPage();
            }
            // Jika tidak, pasti ke login
            return const LoginPage();
          },
        ),
      ), // MaterialApp tutup di sini
    ); // MultiBlocProvider tutup di sini
  }
}
