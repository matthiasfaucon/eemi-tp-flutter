import 'package:flutter/material.dart';
import 'skeleton_loading.dart';

class LoadingErrorEmptyState extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final String emptyMessage;
  final VoidCallback onRetry;
  final String retryButtonText;
  final LoadingType loadingType;

  const LoadingErrorEmptyState({
    super.key,
    required this.isLoading,
    this.error,
    required this.emptyMessage,
    required this.onRetry,
    this.retryButtonText = 'Réessayer',
    this.loadingType = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {      switch (loadingType) {
        case LoadingType.productsList:
          return const ProductsGridSkeleton();
        case LoadingType.productDetails:
          return const ProductDetailsSkeleton();
        case LoadingType.productForm:
          return const ProductFormSkeleton();
        case LoadingType.circular:
          return const Center(child: CircularProgressIndicator());
      }
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryButtonText),
            ),
          ],
        ),
      );
    }

    // État vide
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(retryButtonText),
          ),
        ],
      ),
    );
  }
}

enum LoadingType {
  circular,
  productsList,
  productDetails,
  productForm,
}
