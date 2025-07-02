import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/Models/product_models.dart';

class ProductService {
  //localhost URL for testing on web
  // static String baseUrl = "http://localhost:3000";
  // Base URL for the physical device 
  static String baseUrl = "http://192.168.1.198:3000";

  Future<PaginatedProducts> getAllProductUnpaginate() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PaginatedProducts.fromJson(data);
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<PaginatedProducts> getAllProducts({
    required int page,
    required int limit,
    String search = '',
    String sort = '',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          if (search.isNotEmpty) 'search': search,
          if (sort.isNotEmpty) 'sort': sort,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Map backend pagination fields to model fields
        final adjustedJson = {
          'products': json['products'],
          'pagination': {
            'currentPage': json['pagination']['currentPage'],
            'pageSize': limit, 
            'totalCount': json['pagination']['totalItems'], 
            'totalPages': json['pagination']['totalPages'],
          },
        };
        return PaginatedProducts.fromJson(adjustedJson);
      } else {
        throw Exception('Failed to fetch products: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
  Future<ProductModel> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Product not found');
    }
  }

  Future<void> createProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'PRODUCTNAME': product.name,
        'PRICE': product.price.toString(),
        'STOCK': product.stock,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'PRODUCTNAME': product.name,
        'PRICE': product.price.toString(),
        'STOCK': product.stock,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
