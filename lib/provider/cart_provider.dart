import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_api_model.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/repository/cart_repo.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../data/model/response/base/api_response.dart';
import '../helper/api_checker.dart';
import 'auth_provider.dart';
import 'localization_provider.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({required this.cartRepo});
  List<CartApiModel> _cartApiList = [];
  bool connection = true;
  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  List<CartApiModel> get cartApiList => _cartApiList;
  double get amount => _amount;

  Future<void> connectionChecker() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connection = true;
      }
    } on SocketException catch (_) {
      connection = false;
    }
  }

  Future<void> getMyCartData(
      BuildContext context, String? token, String? languageCode) async {
    ApiResponse apiResponse =
        await cartRepo.getMyCartDataList(token, languageCode);
    if (apiResponse.response.statusCode == 200) {
      _cartApiList = [];
      apiResponse.response.data.forEach(
          (category) => _cartApiList.add(CartApiModel.fromJson(category)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> addToMyCart(BuildContext context, String? token,
      String? languageCode, int? id, int? quantity) async {
    ApiResponse apiResponse =
        await cartRepo.addToMyCart(token, languageCode, id, quantity);
    if (apiResponse.response.statusCode == 200) {
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> increamentProduct(
      BuildContext context, String? token, String? languageCode, int? id) async {
    ApiResponse apiResponse = await cartRepo.increment(token, languageCode, id);
    if (apiResponse.response.statusCode == 200) {
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> decreamentProduct(
      BuildContext context, String? token, String? languageCode, int? id) async {
    ApiResponse apiResponse = await cartRepo.decrement(token, languageCode, id);
    if (apiResponse.response.statusCode == 200) {
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> delete(
      BuildContext context, String? token, String? languageCode, int? id) async {
    ApiResponse apiResponse = await cartRepo.delete(token, languageCode, id);
    if (apiResponse.response.statusCode == 200) {
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void getCartData() {
    _cartList = [];
    _amount = 0.0;
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
      _amount = double?.parse((_amount).toStringAsFixed(2));
    });
  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice! * cartModel.quantity!);
    _amount = double.parse((_amount).toStringAsFixed(2));
    notifyListeners();
  }

  void setQuantity(bool isIncrement, int index, BuildContext context) {
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity! + 1;
      _amount = _amount + _cartList[index].discountedPrice!;
      _amount = double.parse((_amount).toStringAsFixed(2));
    } else {
      bool isLoged =
          Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
      if (isLoged) {
        connectionChecker();
        if (connection) {
          if (_cartList[index].quantity! > 1) {
            _cartList[index].quantity = _cartList[index].quantity! - 1;
          } else if (_cartList[index].quantity == 1) {
            _cartList[index].quantity = _cartList[index].quantity! - 1;
            _cartList.removeAt(index);
            Provider.of<CartProvider>(context, listen: false).delete(
                context,
                Provider.of<AuthProvider>(context, listen: false)
                    .getUserToken(),
                Provider.of<LocalizationProvider>(context, listen: false)
                    .locale
                    .languageCode,
                cartList[index].id);
          }
          if (_cartList[index].quantity! > 1) {
            _cartList[index].quantity = _cartList[index].quantity! - 1;
          } else if (_cartList[index].quantity == 1) {
            _cartList[index].quantity = _cartList[index].quantity! - 1;
            _cartList.removeAt(index);
          }
          _amount = _amount - _cartList[index].discountedPrice!;
          _amount = double.parse((_amount).toStringAsFixed(2));
        }
      } else {
        if (_cartList[index].quantity! > 1) {
          _cartList[index].quantity = _cartList[index].quantity! - 1;
        } else if (_cartList[index].quantity == 1) {
          _cartList[index].quantity = _cartList[index].quantity! - 1;
          _cartList.removeAt(index);
        }
        _amount = _amount - _cartList[index].discountedPrice!;
        _amount = double.parse((_amount).toStringAsFixed(2));
      }
    }
    cartRepo.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(int index, BuildContext context) async {
    bool isLoged =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoged) {
      Provider.of<CartProvider>(context, listen: false).delete(
          context,
          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
          Provider.of<LocalizationProvider>(context, listen: false)
              .locale
              .languageCode,
          cartList[index].id);
      _amount = _amount -
          (cartList[index].discountedPrice! * cartList[index].quantity!);
      _amount = double.parse((_amount).toStringAsFixed(2));
      showCustomSnackBar(getTranslated('remove_from_cart', context), context);
      _cartList.removeAt(index);
      cartRepo.addToCartList(_cartList);
    } else {
      _amount = _amount -
          (cartList[index].discountedPrice! * cartList[index].quantity!);
      _amount = double.parse((_amount).toStringAsFixed(2));
      showCustomSnackBar(getTranslated('remove_from_cart', context), context);
      _cartList.removeAt(index);
      cartRepo.addToCartList(_cartList);
    }

    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  int? isExistInCart(CartModel cartModel) {
    for (int? index = 0; index! < _cartList.length; index++) {
      if (_cartList[index].id == cartModel.id &&
          _cartList[index].variation.type == cartModel.variation.type) {
        return index;
      }
    }
    return -1;
  }
}
