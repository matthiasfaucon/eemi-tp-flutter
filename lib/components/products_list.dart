import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_card.dart';
import 'loading_error_empty_state.dart';
import 'package:shimmer/shimmer.dart';

class ProductsList extends StatelessWidget {  final List<Product> products;
  final VoidCallback onRetry;
  final bool isLoading;
  final String? error;
  final Function(Product)? onDeleteProduct;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const ProductsList({
    super.key,
    required this.products,
    required this.onRetry,
    required this.isLoading,
    this.error,
    this.onDeleteProduct,
    this.scrollController,
    this.isLoadingMore = false,
  });
  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return LoadingErrorEmptyState(
        isLoading: true,
        error: null,
        emptyMessage: '',
        onRetry: onRetry,
        loadingType: LoadingType.productsList,
      );
    }

    if (error != null && products.isEmpty) {
      return LoadingErrorEmptyState(
        isLoading: false,
        error: error,
        emptyMessage: 'La liste des produits est vide',
        onRetry: onRetry,
      );
    }

    if (products.isEmpty) {
      return LoadingErrorEmptyState(
        isLoading: false,
        error: null,
        emptyMessage: 'Aucun produit trouvé',
        onRetry: onRetry,
      );
    }    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length && isLoadingMore) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              SizedBox(), // Pour centrer l'indicateur sur les deux colonnes
              LoadMoreIndicator(),
            ],
          );
        }
        
        return ProductCard(
          product: products[index],
          onDelete: onDeleteProduct != null 
              ? () => onDeleteProduct!(products[index])
              : null,
        );
      },
    );
  }
}

class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
