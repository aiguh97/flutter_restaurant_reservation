import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import 'package:badges/badges.dart' as badges;

class NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? color; // Tambahkan parameter color agar tidak error di dashboard

  const NavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.color, // Tambahkan ke constructor
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan warna dari parameter color, jika null gunakan AppColors.primary saat aktif
    final Color displayColor =
        color ?? (isActive ? AppColors.primary : AppColors.disabled);

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          label == 'Orders'
              ? BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: SvgPicture.asset(
                            iconPath,
                            colorFilter: ColorFilter.mode(
                              displayColor, // Gunakan displayColor
                              BlendMode.srcIn,
                            ),
                          ),
                        );
                      },
                      success: (data, qty, total, _) {
                        if (data.isEmpty) {
                          return SizedBox(
                            width: 25.0,
                            height: 25.0,
                            child: SvgPicture.asset(
                              iconPath,
                              colorFilter: ColorFilter.mode(
                                displayColor, // Gunakan displayColor
                                BlendMode.srcIn,
                              ),
                            ),
                          );
                        } else {
                          return badges.Badge(
                            badgeContent: Text(
                              '$qty',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            child: SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: SvgPicture.asset(
                                iconPath,
                                colorFilter: ColorFilter.mode(
                                  displayColor, // Gunakan displayColor
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                )
              : SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(
                      displayColor, // Gunakan displayColor
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          const SpaceHeight(4.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: displayColor, // Gunakan displayColor
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
