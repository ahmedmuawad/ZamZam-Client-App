import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/category_provider.dart';

class ProductWidget extends StatelessWidget {
  final int flag = 0;
  final Product product;
  final CartModel? cart;
  final CategoryModel categoryModel;

  ProductWidget(
      {required this.product, this.cart, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    void _loadData(BuildContext context) async {
      if (flag == 0) {
        Provider.of<CategoryProvider>(context, listen: false)
            .getCategory(categoryModel.id, context);
        Provider.of<ProductProvider>(context, listen: false)
            .initCategoryProductList(
          categoryModel.id.toString(),
          context,
          Provider.of<LocalizationProvider>(context, listen: false)
              .locale
              .languageCode,
        );
        Provider.of<ProductProvider>(context, listen: false)
            .initializeAllSortBy(context);
        Provider.of<CategoryProvider>(context, listen: false)
            .setFilterIndex(-1);
        flag + 1;
      }
    }

    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      double _price = product.variations.length > 0
          ? double.parse(product.variations[0].price!) 
          : product.price ?? 0.0;
      int? _stock = product.variations.length > 0
          ? product.variations[0].stock
          : product.totalStock;
      CartModel _cartModel = CartModel(
        product.id,
        product.image[0],
        product.name,
        _price,
        PriceConverter.convertWithDiscount(
            context, _price, product.discount, product.discountType),
        1,
        product.variations.isNotEmpty ? product.variations[0] : Variations(),
        (_price -
            PriceConverter.convertWithDiscount(
                context, _price , product.discount, product.discountType)!),
        (_price -
            PriceConverter.convertWithDiscount(
                context, _price , product.tax, product.taxType)!),
        product.capacity,
        product.unit,
        _stock,
      );
      bool isExistInCart = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(_cartModel) !=
          -1;
      int? cardIndex = Provider.of<CartProvider>(context, listen: false)
          .isExistInCart(_cartModel);
      bool _isLogged =
          Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
                RouteHelper.getProductDetailsRoute(product.id!),
                arguments: ProductDetailsScreen(
                    product: product,
                    index: cardIndex,
                    cart: isExistInCart
                        ? Provider.of<CartProvider>(context, listen: false)
                            .cartList[cardIndex!]
                        : null));
          },
          child: Container(
            height: 85,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.getCardBgColor(context),
            ),
            child: Row(children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: ColorResources.getGreyColor(context)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image[0]}',
                    fit: BoxFit.cover,
                    width: 85,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder,
                        width: 85,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name!,
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text('${product.capacity}  ${product.unit}',
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.getTextColor(context))),
                      ]),
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  PriceConverter.convertPrice(context, product.price,
                      discount: product.discount,
                      discountType: product.discountType)!,
                  style: poppinsBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
                product.discount! > 0
                    ? Text(
                        PriceConverter.convertPrice(context, product.price)!,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(),
                Expanded(child: SizedBox()),
                Provider.of<CartProvider>(context).isExistInCart(_cartModel) ==
                        -1
                    ? InkWell(
                        onTap: () {
                          if (isExistInCart) {
                            showCustomSnackBar(
                                getTranslated('already_added', context),
                                context);
                          } else if (_stock! < 1) {
                            showCustomSnackBar(
                                getTranslated('out_of_stock', context),
                                context);
                          } else {
                            _loadData(context);
                            if (_isLogged) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToMyCart(
                                      context,
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .getUserToken(),
                                      Provider.of<LocalizationProvider>(context,
                                              listen: false)
                                          .locale
                                          .languageCode,
                                      product.id,
                                      1);
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(_cartModel);

                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context,
                                  isError: false);
                            } else {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(_cartModel);

                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context,
                                  isError: false);
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          margin: EdgeInsets.all(2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: ColorResources.getHintColor(context)
                                    .withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add,
                              color: Theme.of(context).primaryColor),
                        ))
                    : Consumer<CartProvider>(
                        builder: (context, cart, child) => Row(children: [
                          InkWell(
                            onTap: () {
                              if (_isLogged) {
                                if (cart.cartList[cardIndex!].quantity! > 1) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .decreamentProduct(
                                          context,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                          Provider.of<LocalizationProvider>(
                                                  context,
                                                  listen: false)
                                              .locale
                                              .languageCode,
                                          cart.cartList[cardIndex].id);

                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .setQuantity(false, cardIndex, context);
                                  _loadData(context);
                                } else if (cart.cartList[cardIndex].quantity ==
                                    1) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeFromCart(cardIndex, context);
                                  _loadData(context);
                                }
                              } else {
                                if (cart.cartList[cardIndex!].quantity! > 1) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .setQuantity(false, cardIndex, context);
                                  _loadData(context);
                                  /* Provider.of<CartProvider>(context,
                                          listen: false)
                                      .decreamentProduct(
                                          context,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                          Provider.of<LocalizationProvider>(
                                                  context,
                                                  listen: false)
                                              .locale
                                              .languageCode,
                                          cart.cartList[cardIndex].id); */
                                } else if (cart.cartList[cardIndex].quantity ==
                                    1) {
                                  _loadData(context);
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeFromCart(cardIndex, context);
                                  (context as Element).markNeedsBuild();
                                }
                              }

                              (context as Element).markNeedsBuild();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.remove,
                                  size: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Text(cart.cartList[cardIndex!].quantity.toString(),
                              style: poppinsSemiBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                  color: Theme.of(context).primaryColor)),
                          InkWell(
                            onTap: () {
                              if (cart.cartList[cardIndex].quantity! <
                                  cart.cartList[cardIndex].stock!) {
                                if (_isLogged) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .setQuantity(true, cardIndex, context);
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .increamentProduct(
                                          context,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                          Provider.of<LocalizationProvider>(
                                                  context,
                                                  listen: false)
                                              .locale
                                              .languageCode,
                                          cart.cartList[cardIndex].id);
                                  _loadData(context);
                                } else {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .setQuantity(true, cardIndex, context);
                                  _loadData(context);
                                }
                              } else {
                                showCustomSnackBar(
                                    getTranslated('out_of_stock', context),
                                    context);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.add,
                                  size: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ]),
                      ),
              ]),
            ]),
          ),
        ),
      );
    });
  }
}
