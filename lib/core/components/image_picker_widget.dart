import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoguh/core/constants/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/assets.gen.dart';
import '../constants/colors.dart';
import 'buttons.dart';
import 'spaces.dart';

class ImagePickerWidget extends StatefulWidget {
  final String label;
  final void Function(XFile? file) onChanged;
  final bool showLabel;

  /// Bisa berupa URL lengkap, nama file, atau path lokal
  final String? initialImage;

  /// Base URL untuk image jika hanya nama file
  final String baseUrl;

  const ImagePickerWidget({
    super.key,
    required this.label,
    required this.onChanged,
    this.showLabel = true,
    this.initialImage,
    this.baseUrl = '${Variables.baseUrl}/storage/categories/',
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? pickedFile;
  String? previewPath;

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      // Jika initialImage cuma nama file, gabungkan baseUrl
      previewPath = widget.initialImage!.startsWith('http')
          ? widget.initialImage
          : '${widget.baseUrl}${widget.initialImage}';
    }
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (file != null) {
        pickedFile = file;
        previewPath = file.path;
        widget.onChanged(file);
      } else {
        debugPrint('No image selected.');
        widget.onChanged(null);
      }
    });
  }

  Widget _buildImagePreview() {
    if (previewPath == null || previewPath!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.black.withOpacity(0.05),
        child: Assets.icons.image.svg(),
      );
    }

    final lower = previewPath!.toLowerCase();

    // SVG network
    if (lower.endsWith('.svg')) {
      if (previewPath!.startsWith('http')) {
        return SvgPicture.network(
          previewPath!,
          width: 80,
          height: 80,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      } else {
        return SvgPicture.file(
          File(previewPath!),
          width: 80,
          height: 80,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
    }

    // File lokal
    if (pickedFile != null || File(previewPath!).existsSync()) {
      return Image.file(
        File(previewPath!),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // Network image PNG/JPG/JPEG
    return Image.network(
      previewPath!,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (_, __, ___) => Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.black.withOpacity(0.05),
        child: Assets.icons.image.svg(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SpaceHeight(12),
        ],
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: _buildImagePreview(),
                ),
              ),
              const Spacer(),
              Button.filled(
                height: 30,
                width: 127,
                onPressed: _pickImage,
                label: 'Choose Photo',
                fontSize: 10,
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
