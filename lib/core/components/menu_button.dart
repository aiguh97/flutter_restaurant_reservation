import 'package:flutter/material.dart';
import 'package:flutter_pos_2/core/components/spaces.dart';
import 'package:flutter_pos_2/core/extensions/build_context_ext.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class MenuButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final bool isImage; // true = png/jpg/jpeg, false = svg
  final double size;
  final bool isNetwork; // true = load image dari url

  const MenuButton({
    super.key,
    required this.iconPath,
    required this.label,
    this.isActive = false,
    required this.onPressed,
    this.isImage = false,
    this.size = 90,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (isNetwork) {
      // support network image
      if (iconPath.toLowerCase().endsWith('.svg')) {
        iconWidget = SvgPicture.network(
          iconPath,
          width: size,
          height: size,
          placeholderBuilder: (context) => const CircularProgressIndicator(),
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.white : AppColors.primary,
            BlendMode.srcIn,
          ),
        );
      } else {
        iconWidget = Image.network(
          iconPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          color: isActive ? AppColors.white : AppColors.primary,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.broken_image, size: size, color: AppColors.primary),
        );
      }
    } else {
      // asset image
      iconWidget = isImage
          ? Image.asset(
              iconPath,
              width: size,
              height: size,
              fit: BoxFit.contain,
              color: isActive ? AppColors.white : AppColors.primary,
            )
          : SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.white : AppColors.primary,
                BlendMode.srcIn,
              ),
            );
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      child: Container(
        width: context.deviceWidth,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20.0,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0,
              color: AppColors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpaceHeight(8.0),
            iconWidget,
            const SpaceHeight(8.0),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
