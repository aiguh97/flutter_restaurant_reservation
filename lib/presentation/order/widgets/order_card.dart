import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restoguh/core/extensions/int_ext.dart';
import 'package:restoguh/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:restoguh/presentation/home/models/order_item.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class OrderCard extends StatelessWidget {
  final OrderItem data;
  final VoidCallback onDeleteTap;
  final EdgeInsetsGeometry? padding;

  const OrderCard({
    super.key,
    required this.data,
    required this.onDeleteTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F1F1), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Image Section ---
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    imageUrl: data.product.image,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[100],
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

              // --- Info Section ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.product.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SpaceHeight(4.0),
                          Text(
                            data.product.price.currencyFormatRp,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      // --- Quantity Controller ---
                      Row(
                        children: [
                          _buildQtyButton(
                            icon: Icons.remove,
                            onTap: () => context.read<CheckoutBloc>().add(
                              CheckoutEvent.removeCheckout(data.product),
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: Center(
                              child: Text(
                                '${data.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          _buildQtyButton(
                            icon: Icons.add,
                            onTap: () => context.read<CheckoutBloc>().add(
                              CheckoutEvent.addCheckout(data.product),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // --- Delete Section ---
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: onDeleteTap,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk tombol quantity yang rapi
  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
