import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Services/product_service.dart';

class AddProductProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  bool isInitialLoading = true;
  bool isLoading = false;

  final ProductService _service = ProductService();

  Future<void> create(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final newProduct = ProductModel(
      id: 0,
      name: nameController.text.trim(),
      price: Decimal.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
    );
    try {
      isLoading = true;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating product: $e")),
      );
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }

    await _service.createProduct(newProduct);

    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product created")),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
