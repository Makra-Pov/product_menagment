import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Services/product_service.dart';

class EditScreenProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final ProductService _service = ProductService();
  late ProductModel product;
  bool isLoading = false;

  void initialize(ProductModel p) {
    product = p;
    nameController.text = p.name;
    priceController.text = p.price.toString();
    stockController.text = p.stock.toString();
  }

  Future<void> update(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final name = nameController.text.trim();
      final priceText = priceController.text.trim();
      final stockText = stockController.text.trim();

      // Additional validation for parsing
      final price = Decimal.tryParse(priceText);
      if (price == null) {
        throw const FormatException('Invalid price format');
      }
      final stock = int.tryParse(stockText);
      if (stock == null) {
        throw const FormatException('Invalid stock format');
      }

      final updated = ProductModel(
        id: product.id,
        name: name,
        price: price,
        stock: stock,
      );

      await _service.updateProduct(updated);

      if (context.mounted) {
        Navigator.pop(context, updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: $e')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    nameController.clear();
    priceController.clear();
    stockController.clear();
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}