import 'package:flutter/material.dart';
import 'package:product_app/Screens/provider/home_screen_provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Product App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreenView(),
      ),
    );
  }
}
