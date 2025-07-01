import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/Models/product_models.dart';


class ProductService {
  static  String baseUrl = "http://192.168.1.198:3000";

   Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
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

  static Future<void> createProduct(ProductModel product) async {
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
