import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('empty', [], ''),
          update: (ctx, auth, previousProducts) => Products(auth.token,
              previousProducts == null ? [] : previousProducts.items, auth.userId),
        ),
        ChangeNotifierProvider.value(
          //alternative syntax as opposed to using a builder method cuz we dont need context
          value:
              Cart(), // difference between using ChangeNotifierProvider.value and using builder argument: there is a difference cuz flutter reuses widgets and the .value syntax allows your widgets to attach,persist and keep up with the correct data that is always changing but builder argument and method cannot eg best use case is within grid systems or scrollable lists
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('empty', [], ''), 
          update: (_, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, child) {
        print('in main.dart: ${auth.isAuth}');
        return MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blueGrey,
              accentColor: Colors.green,
              fontFamily: 'Lato'),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        );
      }),
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
