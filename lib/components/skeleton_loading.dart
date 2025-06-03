import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 140,
              color: Colors.white,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                const SkeletonLoading(
                  width: 120,
                  height: 20,
                ),
                const SizedBox(height: 8),
                
                // Price placeholder
                const SkeletonLoading(
                  width: 80,
                  height: 16,
                ),
                
                const SizedBox(height: 20),
                
                // Action buttons placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SkeletonLoading(
                      width: 36,
                      height: 36,
                      borderRadius: 18,
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

class ProductsGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ProductsGridSkeleton({
    super.key, 
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ProductCardSkeleton();
      },
    );
  }
}

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 250,
              color: Colors.white,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                const SkeletonLoading(
                  width: 200,
                  height: 24,
                ),
                const SizedBox(height: 8),
                
                // Price placeholder
                const SkeletonLoading(
                  width: 100,
                  height: 20,
                ),
                const SizedBox(height: 16),
                
                // Description title placeholder
                const SkeletonLoading(
                  width: 150,
                  height: 18,
                ),
                const SizedBox(height: 8),
                
                // Description content placeholder
                Column(
                  children: List.generate(4, (index) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SkeletonLoading(
                        width: double.infinity,
                        height: 16,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Info title placeholder
                const SkeletonLoading(
                  width: 180,
                  height: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ProductFormSkeleton extends StatelessWidget {
  const ProductFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field placeholder
          const SkeletonLoading(
            width: 120,
            height: 16,
          ),
          const SizedBox(height: 8),
          SkeletonLoading(
            width: double.infinity,
            height: 56,
            borderRadius: 4,
          ),
          const SizedBox(height: 16),
          
          // Description field placeholder
          const SkeletonLoading(
            width: 120,
            height: 16,
          ),
          const SizedBox(height: 8),
          SkeletonLoading(
            width: double.infinity,
            height: 100,
            borderRadius: 4,
          ),
          const SizedBox(height: 16),
          
          // Price field placeholder
          const SkeletonLoading(
            width: 80,
            height: 16,
          ),
          const SizedBox(height: 8),
          SkeletonLoading(
            width: double.infinity,
            height: 56,
            borderRadius: 4,
          ),
          const SizedBox(height: 16),
          
          // Image URL field placeholder
          const SkeletonLoading(
            width: 140,
            height: 16,
          ),
          const SizedBox(height: 8),
          SkeletonLoading(
            width: double.infinity,
            height: 56,
            borderRadius: 4,
          ),
          const SizedBox(height: 24),
          
          // Image preview placeholder
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: SkeletonLoading(
              width: double.infinity,
              height: 200,
              borderRadius: 8,
            ),
          ),
          
          // Submit button placeholder
          Align(
            alignment: Alignment.center,
            child: SkeletonLoading(
              width: 200,
              height: 48,
              borderRadius: 4,
            ),
          ),
        ],
      ),
    );
  }
}
