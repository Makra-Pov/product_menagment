import 'package:flutter/material.dart';
import 'package:product_app/Routes/routes.dart';
import 'package:product_app/Screens/provider/add_product_provider.dart';
import 'package:product_app/Screens/provider/edit_screen_provider.dart';
import 'package:product_app/Screens/provider/home_screen_provider.dart';
import 'package:product_app/Screens/views/add_product_view.dart';
import 'package:product_app/Screens/views/edit_product_view.dart';
import 'package:product_app/Screens/views/home_screen_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (_) => HomeScreenProvider(), 
         
        ),
        ChangeNotifierProvider(create: (_) => AddProductProvider()),
        ChangeNotifierProvider(
          create: (_) => EditScreenProvider(), // Assuming you have an EditScreenProvider
        ),
      ],
      child: MaterialApp(
        initialRoute: Routes.homeScreen,

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
       routes: {
          Routes.homeScreen: (context) =>  HomeScreenView(),
          Routes.editProduct: (context) => const EditProductView(
            // Passing null for adding a new product
          ),
          Routes.addProduct: (context) => AddProductView(
           

          ),
        },
      ),
    );
  }
}
