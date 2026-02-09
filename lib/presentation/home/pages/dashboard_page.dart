import 'package:flutter/material.dart';
import 'package:restoguh/data/datasources/auth_local_datasource.dart';
import 'package:restoguh/presentation/history/pages/history_page.dart';
import 'package:restoguh/presentation/home/pages/home_page.dart';
import 'package:restoguh/presentation/my-history/pages/my_history_page.dart';
import 'package:restoguh/presentation/my_accounts/pages/my_account_page.dart';
import 'package:restoguh/presentation/order/pages/order_page.dart';
import 'package:restoguh/presentation/setting/pages/setting_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/colors.dart';
import '../widgets/nav_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool? _isAdmin;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // dashboard_page.dart
  Future<void> _loadUser() async {
    final authData = await AuthLocalDatasource().getAuthData();

    // Tambahkan pengecekan null sebelum setState
    if (authData != null && authData.user != null) {
      setState(() {
        _isAdmin = authData.user!.roles == 'admin';
      });
      debugPrint("User data is null, redirecting...");
    } else {
      // Jika tidak ada data, arahkan kembali ke login atau set default
      debugPrint("User data is null, redirecting...");
    }
  }

  List<Widget> get _pages {
    if (_isAdmin == true) {
      return const [
        HomePage(),
        OrderPage(),
        HistoryPage(),
        SettingPage(),
        MyAccountPage(),
      ];
    } else {
      return const [HomePage(), OrderPage(), MyHistoryPage(), MyAccountPage()];
    }
  }

  List<NavItem> get _navItems {
    if (_isAdmin == true) {
      return [
        NavItem(
          iconPath: Assets.icons.home.path,
          label: 'Home',
          isActive: _selectedIndex == 0,
          onTap: () => _onItemTapped(0),
        ),
        NavItem(
          iconPath: Assets.icons.orders.path,
          label: 'Orders',
          isActive: _selectedIndex == 1,
          onTap: () => _onItemTapped(1),
        ),
        NavItem(
          iconPath: Assets.icons.payments.path,
          label: 'History',
          isActive: _selectedIndex == 2,
          onTap: () => _onItemTapped(2),
        ),
        NavItem(
          iconPath: Assets.icons.dashboard.path,
          label: _isAdmin ?? false ? 'admin' : 'bukan',
          isActive: _selectedIndex == 3,
          onTap: () => _onItemTapped(3),
        ),
        NavItem(
          iconPath: Assets.icons.user.path,
          label: 'Account',
          isActive: _selectedIndex == 4,
          onTap: () => _onItemTapped(4),
        ),
      ];
    } else {
      return [
        NavItem(
          iconPath: Assets.icons.home.path,
          label: 'Home',
          isActive: _selectedIndex == 0,
          onTap: () => _onItemTapped(0),
        ),
        NavItem(
          iconPath: Assets.icons.orders.path,
          label: 'Orders',
          isActive: _selectedIndex == 1,
          onTap: () => _onItemTapped(1),
        ),
        NavItem(
          iconPath: Assets.icons.payments.path,
          label: 'My History',
          isActive: _selectedIndex == 2,
          onTap: () => _onItemTapped(2),
        ),
        NavItem(
          iconPath: Assets.icons.user.path,
          label: 'Account',
          isActive: _selectedIndex == 3,
          onTap: () => _onItemTapped(3),
        ),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdmin == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 30,
              color: AppColors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _navItems,
        ),
      ),
    );
  }
}
