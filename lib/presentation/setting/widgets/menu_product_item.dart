import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restoguh/data/models/response/product_response_model.dart';
import 'package:restoguh/presentation/home/bloc/product/product_bloc.dart';
import 'package:restoguh/presentation/setting/pages/add_product_page.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuProductItem extends StatelessWidget {
  final Product data;
  final VoidCallback? onDelete; // callback hapus
  const MenuProductItem({super.key, required this.data, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 3, color: AppColors.blueLight),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          // Thumbnail image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: CachedNetworkImage(
              imageUrl: data.image,
              placeholder: (context, url) => const SizedBox(
                width: 80,
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.food_bank_outlined, size: 80),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SpaceWidth(16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: const TextStyle(fontSize: 16)),
                const SpaceHeight(4.0),
                Text(
                  data.categorySafe,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SpaceHeight(8.0),
                // Tombol Edit dan Delete di kiri bawah
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        // 1. Tunggu proses edit selesai
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddProductPage(product: data),
                          ),
                        );

                        // 2. SETELAH kembali dari AddProductPage, panggil Fetch
                        // Ini akan memicu BlocBuilder di halaman ManageProductPage untuk merender ulang data terbaru
                        if (context.mounted) {
                          context.read<ProductBloc>().add(
                            const ProductEvent.fetch(),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AlertDialog(
                              title: const Text('Hapus Produk'),
                              content: Text(
                                'Apakah Anda yakin ingin menghapus ${data.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // trigger event delete via Bloc
                                    context.read<ProductBloc>().add(
                                      ProductEvent.deleteProduct(data!.id!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${data.name} berhasil dihapus',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
