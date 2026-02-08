import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/extensions/build_context_ext.dart';
import 'package:restoguh/presentation/home/pages/dashboard_page.dart';
import '../../../core/components/spaces.dart';
import '../../home/bloc/product/product_bloc.dart';
import '../widgets/menu_product_item.dart';
import 'add_product_page.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  Future<void> _refreshProducts() async {
    context.read<ProductBloc>().add(const ProductEvent.fetch());
    // Bisa tunggu sebentar jika mau animasi loading terlihat
    await Future.delayed(const Duration(milliseconds: 500));
  }

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
          'Manage Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => ListView.separated(
                  itemCount: 5, // skeleton 5 item
                  separatorBuilder: (_, __) => const SpaceHeight(20),
                  itemBuilder: (_, __) => const _ProductSkeleton(),
                ),
                success: (products) => ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SpaceHeight(20),
                  itemBuilder: (context, index) =>
                      MenuProductItem(data: products[index]),
                ),
                orElse: () => const Center(child: Text('No products found')),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Skeleton sederhana untuk loading
class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SpaceWidth(22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: double.infinity,
                color: Colors.grey.shade300,
              ),
              const SpaceHeight(8),
              Container(height: 12, width: 150, color: Colors.grey.shade300),
              const SpaceHeight(16),
              Row(
                children: [
                  Container(height: 31, width: 60, color: Colors.grey.shade300),
                  const SpaceWidth(6),
                  Container(height: 31, width: 31, color: Colors.grey.shade300),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
