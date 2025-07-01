import 'package:flutter/material.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:provider/provider.dart';

import 'package:product_app/Screens/provider/home_screen_provider.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeScreenProvider>(context, listen: false);
    provider.fetchInitialProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        provider.fetchMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeScreenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        centerTitle: true,
      ),
      body: provider.isLoading && provider.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await provider.refreshProducts();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: provider.products.length + (provider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < provider.products.length) {
                    final ProductModel product = provider.products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: \$${product.price} • Stock: ${product.stock}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.deleteProduct(product.id),
                      ),
                      onTap: () {
                        // Navigate to edit page if needed
                      },
                    );
                  } else {
                    // Loading indicator at the end for lazy loading
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
    );
  }
}
