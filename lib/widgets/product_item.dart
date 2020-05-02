import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart_provider.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  ProductItem();

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context); alternative syntax, side note: every time this is called, it runs entire build method again, having consumer is better cuz u can insert precisely where data should change so fewer widgets rebuild
    //Consumer is used for better widget splitting and rebuilding

    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (ctx, product, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () async {
                await product.toggleFavorite(authData.token, authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added Item to Cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(label: 'UNDO', onPressed: (){
                      cart.removeSingleItem(product.id);
                    }),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
