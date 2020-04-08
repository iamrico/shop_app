import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value( //alternative syntax as opposed to using a builder method cuz we dont need context
		value: Products(), // difference between using ChangeNotifierProvider.value and using builder argument: there is a difference cuz flutter reuses widgets and the .value syntax allows your widgets to attach,persist and keep up with the correct data that is always changing but builder argument and method cannot eg best use case is within grid systems or scrollable lists
		child: MaterialApp(
			title: 'MyShop',
			theme: ThemeData(
				primarySwatch: Colors.blue,
				primaryColor: Colors.blueGrey,
				accentColor: Colors.green,
				fontFamily: 'Lato'),
			home: ProductOverviewScreen(),
			routes: {
			ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
			},
		),
		);
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
