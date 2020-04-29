import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(children: [
                UserProductItem(productsData.items[i].title,
                    productsData.items[i].imageUrl, productsData.items[i].id),
                Divider(),
              ]),
            ),
          ),
        ));
  }
}
