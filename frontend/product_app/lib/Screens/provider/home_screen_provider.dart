import 'package:flutter/material.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Services/product_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 0;
  final int limit = 10;

  final ProductService _service = ProductService();

  Future<void> fetchInitialProducts() async {
    page = 0;
    products.clear();
    hasMore = true;
    await fetchMoreProducts();
  }

  Future<void> fetchMoreProducts() async {
    if (!hasMore || isLoading) return;
    isLoading = true;
    notifyListeners();

    try {
      final newItems = await _service.getAllProducts(); // Replace with paginated endpoint if available
      if (newItems.length < limit) hasMore = false;
      products.addAll(newItems.skip(page * limit).take(limit));
      page++;
    } catch (e) {
      // handle error
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await fetchInitialProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _service.deleteProduct(id);
    products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
