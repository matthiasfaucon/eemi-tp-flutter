import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/create',
      builder: (context, state) => const ProductFormScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/product/:id/edit',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductFormScreen(
          productId: productId,
          isEditing: true,
        );
      },
    ),
  ],
);
