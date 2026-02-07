import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pos_2/core/constants/variables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildCategoryImage extends StatelessWidget {
  /// Bisa berupa file path lokal atau nama file / URL
  final String? imageUrl;

  /// Ukuran width & height
  final double size;

  /// Placeholder saat loading
  final Widget? placeholder;

  /// Icon error saat gagal load
  final Widget? errorWidget;

  /// Base URL untuk image jika hanya nama file
  final String baseUrl;

  const BuildCategoryImage({
    super.key,
    required this.imageUrl,
    this.size = 50,
    this.placeholder,
    this.errorWidget,
    this.baseUrl = '${Variables.baseUrl}/storage/categories/',
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return errorWidget ?? Icon(Icons.broken_image, size: size);
    }

    // Tentukan URL lengkap
    final lower = imageUrl!.toLowerCase();
    final fullUrl = imageUrl!.startsWith('http')
        ? imageUrl!
        : '$baseUrl$imageUrl';

    // SVG dari network
    if (lower.endsWith('.svg')) {
      return SvgPicture.network(
        fullUrl,
        width: size,
        height: size,
        placeholderBuilder: (_) =>
            placeholder ?? const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    // PNG/JPG/JPEG dari network
    return Image.network(
      fullUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder ?? const CircularProgressIndicator(strokeWidth: 2);
      },
      errorBuilder: (_, __, ___) =>
          errorWidget ?? Icon(Icons.broken_image, size: size),
    );
  }
}
