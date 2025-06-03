import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../components/products_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<Product> products = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  int totalProducts = 0;
  String? error;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoading && !isLoadingMore && hasMore) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> fetchProducts({bool reset = true}) async {
    if (reset) {
      setState(() {
        currentPage = 1;
        isLoading = true;
        error = null;
      });
    }

    try {
      final result = await _apiService.fetchProducts(
        searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
        page: currentPage
      );
      
      final fetchedProducts = result['products'] as List<Product>;
      final count = result['count'] as int;
      final hasMoreProducts = result['hasMore'] as bool;
      
      setState(() {
        if (reset) {
          products = fetchedProducts;
        } else {
          products = [...products, ...fetchedProducts];
        }
        
        totalProducts = count;
        hasMore = hasMoreProducts;
        isLoading = false;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        error = 'Erreur: $e';
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;
    
    setState(() {
      isLoadingMore = true;
      currentPage++;
    });
        
    await fetchProducts(reset: false);
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() {
      searchQuery = query;
      isLoading = true;
    });
    
    // Un peu de debounce
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (searchQuery == query) {
      fetchProducts();
    }
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await _apiService.deleteProduct(product.id);
      
      setState(() {
        products.removeWhere((p) => p.id == product.id);
        totalProducts--;
      });
      
      if (!mounted) return;
      
      toastification.show(
        context: context,
        title: Text('Produit supprimé'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
      );
    } catch (e) {
      if (!mounted) return;
      
      toastification.show(
        context: context,
        title: Text('Erreur lors de la suppression'),
        description: Text(e.toString()),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.error,
      );
    }
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer "${product.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ProductsList(
                  products: products,
                  isLoading: isLoading,
                  error: error,
                  scrollController: _scrollController,
                  onRetry: () {
                    setState(() {
                      isLoading = true;
                      error = null;
                    });
                    fetchProducts();
                  },
                  onDeleteProduct: _showDeleteConfirmation,
                ),                
                if (isLoadingMore)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/product/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
