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
