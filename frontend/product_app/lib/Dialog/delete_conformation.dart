import 'package:flutter/material.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Screens/provider/home_screen_provider.dart';
import 'package:provider/provider.dart';

class UserDialog {
  static void confirmDelete(
    BuildContext context,
    HomeScreenProvider provider,
    ProductModel product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Product',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.teal,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${product.name}"?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal,
              ),
            ),
          ),
          Consumer<HomeScreenProvider>(
            builder: (context, provider, _) => ElevatedButton.icon(
              onPressed: provider.isDeleting
                  ? null
                  : () async {
                      Navigator.pop(context); 
                      try {
                        await provider.deleteProduct(product.id,context);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} deleted'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              icon: provider.isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.delete),
              label: Text(
                provider.isDeleting ? 'Deleting...' : 'Delete',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  static Future<bool?> showNoInternetDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your network and try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); 
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); 
            },
            child: const Text('Retry'),
          ),
        ],
      );
    },
  );
}
}