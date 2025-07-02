import 'package:decimal/decimal.dart';

class ProductModel {
  final int id;
  final String name;
  final Decimal price;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['PRODUCTID'] ?? 0,
      name: json['PRODUCTNAME'] ?? '',
      price: Decimal.parse(json['PRICE'].toString()),
      stock: json['STOCK'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PRODUCTID': id,
      'PRODUCTNAME': name,
      'PRICE': price.toString(),
      'STOCK': stock,
    };
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}

class PaginatedProducts {
  final List<ProductModel> products;
  final Pagination pagination;

  PaginatedProducts({
    required this.products,
    required this.pagination,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List<dynamic>? ?? [];
    return PaginatedProducts(
      products: productsList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
