import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../services/api_service.dart';
import '../components/back-button.dart';
import '../components/loading_error_empty_state.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;
  final bool isEditing;

  const ProductFormScreen({
    super.key,
    this.productId,
    this.isEditing = false,
  });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.productId != null) {
      _loadProduct();
    } else {
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final product = await _apiService.fetchProductById(widget.productId!);
      
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toString();
      _imageController.text = product.image;
      
      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
      
      toastification.show(
        context: context,
        title: const Text("Erreur lors du chargement"),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final image = _imageController.text.trim();
    
    try {
      if (widget.isEditing) {
        await _apiService.updateProduct(
          widget.productId!,
          name,
          description,
          price,
          image,
        );
        if (!mounted) return;
        
        toastification.show(
          context: context,
          title: const Text("Produit mis à jour"),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        await _apiService.createProduct(
          name,
          description,
          price,
          image,
        );
        if (!mounted) return;
        
        toastification.show(
          context: context,
          title: const Text("Produit créé"),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
      
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      toastification.show(
        context: context,
        title: const Text("Erreur"),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Modifier le produit' : 'Créer un produit'),
        leading: const CustomBackButton(),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),      body: !_isInitialized || _isLoading
              ? LoadingErrorEmptyState(
                  isLoading: true,
                  emptyMessage: '',
                  onRetry: () {},
                  loadingType: LoadingType.productForm,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nom
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom du produit *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer un nom de produit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer une description';
                            }
                            return null;
                          },
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        
                        // Prix
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Prix (€) *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer un prix';
                            }
                            
                            final price = double.tryParse(value);
                            if (price == null || price <= 0) {
                              return 'Veuillez entrer un prix valide';
                            }
                            
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // URL de l'image
                        TextFormField(
                          controller: _imageController,
                          decoration: const InputDecoration(
                            labelText: 'URL de l\'image *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer une URL d\'image';
                            }
                            
                            // Validation simple d'URL
                            if (!Uri.tryParse(value)!.isAbsolute) {
                              return 'Veuillez entrer une URL valide';
                            }
                            
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Aperçu de l'image
                        if (_imageController.text.isNotEmpty)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              _imageController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Bouton de soumission
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveProduct,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            widget.isEditing ? 'Mettre à jour' : 'Créer',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
