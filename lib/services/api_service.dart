import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://eemi-39b84a24258a.herokuapp.com/products';

  Future<Map<String, dynamic>> fetchProducts({
    String? searchQuery,
    int page = 1,
  }) async {
    final Uri uri;
    final int limit = 30;

    final queryParameters = <String, String>{
      'page': page.toString()
    };

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters['search'] = searchQuery;
    }

    uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic decodedResponse = json.decode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('rows') &&
          decodedResponse['rows'] is List) {

        final List<dynamic> productsData = decodedResponse['rows'];
        final int count = decodedResponse['count'] ?? productsData.length;

        final List<Product> productsList =
            productsData
                .map<Product>((data) => Product.fromJson(data))
                .toList();

        return {
          'products': productsList,
          'count': count,
          'hasMore': (page * limit) < count,
        };
      }
      else if (decodedResponse is List) {
        final List<Product> productsList =
            decodedResponse
                .map<Product>((data) => Product.fromJson(data))
                .toList();

        return {
          'products': productsList,
          'count': productsList.length,
          'hasMore': false,
        };
      }

      // Réponse de format inattendu
      else {
        throw Exception('Format de réponse inattendu: ${response.body}');
      }
    } else {
      throw Exception(
        'Échec de chargement des produits: ${response.statusCode}',
      );
    }
  }

  Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
        return Product.fromJson(jsonData['data']);
      } else {
        return Product.fromJson(jsonData);
      }
    } else {
      throw Exception('Échec de chargement du produit: ${response.statusCode}');
    }
  }

  Future<Product> createProduct(
    String name,
    String description,
    double price,
    String image,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      }),
    );

    if (response.statusCode == 201) {
      final dynamic jsonData = json.decode(response.body);

      // Si la réponse est enveloppée dans un objet
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
        return Product.fromJson(jsonData['data']);
      } else {
        return Product.fromJson(jsonData);
      }
    } else {
      throw Exception(
        'Échec de la création du produit: ${response.statusCode}',
      );
    }
  }

  Future<Product> updateProduct(
    String id,
    String name,
    String description,
    double price,
    String image,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      // Si la réponse est enveloppée dans un objet
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
        return Product.fromJson(jsonData['data']);
      } else {
        return Product.fromJson(jsonData);
      }
    } else {
      throw Exception(
        'Échec de la mise à jour du produit: ${response.statusCode}',
      );
    }
  }

  Future<bool> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    // Accepter les codes 200, 202 et 204 comme succès
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      throw Exception(
        'Échec de la suppression du produit: ${response.statusCode}',
      );
    }
  }
}
