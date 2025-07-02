import 'package:flutter/material.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Services/product_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool isInitialLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  bool hasError = false;
  String? errorMessage;
  int currentPage = 1;
  final int itemsPerPage = 6; 
  String searchQuery = '';
  String sortBy = '';
    bool isDeleting = false;

  final ProductService _service = ProductService();

 
  void updateSearchAndSort(String newSearchQuery, String newSortBy) {
    searchQuery = newSearchQuery.trim();
    sortBy = newSortBy.toLowerCase(); 
    refreshProducts();
  }

  Future<void> fetchInitialProducts() async {
    try {
      isInitialLoading = true;
      hasError = false;
      errorMessage = null;
      notifyListeners();

      final paginatedProducts = await _service.getAllProducts(
        page: 1,
        limit: itemsPerPage,
        search: searchQuery,
        sort: sortBy,
      );

      products = paginatedProducts.products;
      currentPage = 1;
      hasMore = paginatedProducts.pagination.totalPages > currentPage;
    } catch (e) {
      hasError = true;
      errorMessage = _parseError(e);
    } finally {
      isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreProducts() async {
    if (!hasMore || isLoadingMore) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      final paginatedProducts = await _service.getAllProducts(
        page: currentPage + 1,
        limit: itemsPerPage,
        search: searchQuery,
        sort: sortBy,
      );

      if (paginatedProducts.products.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(paginatedProducts.products);
        currentPage++;
        hasMore = paginatedProducts.pagination.currentPage <
            paginatedProducts.pagination.totalPages;
      }
    } catch (e) {
      hasError = true;
      errorMessage = _parseError(e);
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    products.clear();
    currentPage = 1;
    hasMore = true;
    hasError = false;
    errorMessage = null;

    await fetchInitialProducts();
  }

  Future<void> deleteProduct(int id,BuildContext context) async {
    try {
      isDeleting = true;
      hasError = false;
      errorMessage = null;
      notifyListeners();

      await _service.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      updateSearchAndSort(searchQuery, sortBy);
    } catch (e) {
      hasError = true;
      errorMessage = 'Failed to delete product';
      notifyListeners();
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }



  void clearError() {
    hasError = false;
    errorMessage = null;
    notifyListeners();
  }


  String _parseError(dynamic e) {
    final errorStr = e.toString();
    if (errorStr.contains('DioError') || errorStr.contains('HttpException')) {
      return 'Failed to connect to the server. Please check your network or server status.';
    }
    if (errorStr.contains('Failed to fetch products')) {
      return 'Error loading products. Please try again.';
    }
    return errorStr.replaceAll('Exception: ', '');
  }
}