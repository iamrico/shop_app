import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart_provider.dart';


class ProductItem extends StatelessWidget {
  ProductItem();

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context); alternative syntax, side note: every time this is called, it runs entire build method again, having consumer is better cuz u can insert precisely where data should change so fewer widgets rebuild
    //Consumer is used for better widget splitting and rebuilding
	
    final cart = Provider.of<Cart>(context, listen: false);

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
						onPressed: () {
							product.toggleFavorite();
						},
						color: Theme.of(context).accentColor,
						),
						trailing: IconButton(
							icon: Icon(Icons.shopping_cart),
							onPressed: () {
                cart.addItem(product.id, product.price, product.title);
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
