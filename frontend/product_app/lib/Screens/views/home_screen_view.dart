import 'dart:async';
import 'package:flutter/material.dart';
import 'package:product_app/Dialog/delete_conformation.dart';
import 'package:product_app/Models/product_models.dart';
import 'package:product_app/Routes/routes.dart';
import 'package:product_app/Screens/provider/home_screen_provider.dart';
import 'package:provider/provider.dart';

class HomeScreenView extends StatelessWidget {
  HomeScreenView({super.key});

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _selectedSort = ValueNotifier<String>('none');
  final ValueNotifier<Timer?> _debounce = ValueNotifier<Timer?>(null);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeScreenProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.products.isEmpty && !provider.isInitialLoading && !provider.hasError) {
        provider.fetchInitialProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Management',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isInitialLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          }
          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? 'An error occurred',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.refreshProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Products',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (_debounce.value?.isActive ?? false) {
                      _debounce.value?.cancel();
                    }
                    _debounce.value = Timer(const Duration(milliseconds: 700), () {
                      provider.updateSearchAndSort(value.trim(), _selectedSort.value);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort by:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal,
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: _selectedSort,
                      builder: (context, sort, _) {
                        return DropdownButton<String>(
                          value: sort,
                          items: const [
                            DropdownMenuItem(value: 'none', child: Text('None')),
                            DropdownMenuItem(value: 'price', child: Text('Price')),
                            DropdownMenuItem(value: 'stock', child: Text('Stock')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _selectedSort.value = value;
                              provider.updateSearchAndSort(
                                  _searchController.text.trim(), value);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          underline: Container(
                            height: 2,
                            color: Colors.teal,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshProducts,
                  color: Colors.teal,
                  displacement: 40.0,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.pixels >=
                              scrollNotification.metrics.maxScrollExtent - 200 &&
                          !provider.isLoadingMore &&
                          provider.hasMore) {
                        provider.fetchMoreProducts();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: provider.products.length +
                          (provider.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.products.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: provider.hasMore
                                  ? const CircularProgressIndicator(
                                      color: Colors.teal,
                                    )
                                  : const Text(
                                      'No more products',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          );
                        }

                        final product = provider.products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Price: \$${product.price} • Stock: ${product.stock}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () => _navigateToEdit(
                                    context,
                                    product: product,
                                    provider: provider,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => UserDialog.confirmDelete(
                                      context, provider, product),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProduct(context),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEdit(
    BuildContext context, {
    required ProductModel product,
    required HomeScreenProvider provider,
  }) async {
    final result = await Navigator.pushNamed(context, Routes.editProduct, arguments: product);
    if (result != null && result is ProductModel) {
      await provider.refreshProducts();
    }
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.pushNamed(context, Routes.addProduct);
  }
}