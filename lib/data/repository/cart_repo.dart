import 'dart:convert';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_model.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<String> cart=[];
  List<String> cartHistory=[];

  void addToCartList(List<CartModel> cartList){
    /*sharedPreferences.remove(AppConstants.CART_LIST);
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    return;*/
    var time = DateTime.now().toString();
    cart=[];
    /*
    convert objects to string because sharedpreferences only accepts string
     */

    for (var element in cartList) {
      element.time = time;
      continue;
    }

    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    //print(sharedPreferences.getStringList(AppConstants.CART_LIST));
    //getCartList();
  }

    List<CartModel> getCartList(){
    List<String> carts=[];
    if(sharedPreferences.containsKey(AppConstants.CART_LIST)){
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
      print("inside getCartList$carts");
    }
    List<CartModel> cartList=[];

    for (var element in carts) {
      cartList.add(CartModel.fromJson(jsonDecode(element)));
    }
     return cartList;
    }

    List<CartModel> getCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      //cartHistory=[];
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    List<CartModel> cartListHistory=[];
    for (var element in cartHistory) {
      cartListHistory.add(CartModel.fromJson(jsonDecode(element)));
    }
    return cartListHistory;
    }

    void addToCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for(int i=0; i<cart.length; i++){
      cartHistory.add(cart[i]);
    }
    cart=[];
    sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistory);
    }
    void removeCart(){
      cart=[];
      sharedPreferences.remove(AppConstants.CART_LIST);
    }

    void clearCartHistory(){
      removeCart();
      cartHistory=[];
      sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    }
    void removeCartSharedPreference(){
    sharedPreferences.remove(AppConstants.CART_LIST);
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    }
}

