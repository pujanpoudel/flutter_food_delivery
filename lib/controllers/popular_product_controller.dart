import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/products_model.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  PopularProductController(
      {required this.popularProductRepo, required PopularProductRepo});

  List<ProductModel> _popularProductList = [];

  List<ProductModel> get popularProductList => _popularProductList;
  late CartController _cart;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  int _quantity = 0;
  int get quantity => _quantity;
  int _intCartItems = 0;
  int get intCartItems => _intCartItems + _quantity;

  Future <void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      _popularProductList = [];
      _popularProductList.addAll(Product
          .fromJson(response.body)
          .products);
      _isLoaded = true;
      update();
    } else {

    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
      //print("number of items "+_quantity.toString());
    } else {
      _quantity = checkQuantity(_quantity - 1);
      //print("decrement"+_quantity.toString());
    }
    update();
  }

  int checkQuantity(int quantity) {
    if ((_intCartItems + quantity) < 0) {
      Get.snackbar("Item count", "You can't order less than 0!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      if(_intCartItems>0){
        _quantity = -_intCartItems;
        return _quantity;
      }
      return 0;
    } else if ((_intCartItems + quantity) > 20) {
      Get.snackbar("Item count", "Visit store for bulk orders!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController cart) {
    _quantity = 0;
    _intCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.existInCart(product);
    //if exists
    //get from storage _inCartItems
    //print("exist or not" + exist.toString());
    if (exist) {
      _intCartItems = _cart.getQuantity(product);
    }
    //print("the quantity in the cart is" + _intCartItems.toString());
  }

  void addItem(ProductModel product){

    _cart.addItem(product, _quantity);

    _quantity = 0;
    _intCartItems = _cart.getQuantity(product);

    // _cart.items.forEach((key, value) {
    //   print("The id is" + value.id.toString() + " The quantity is " +
    //       value.quantity.toString());
    // });

    update();
    }
    int get totalItems{
     return _cart.totalItems;
    }
    List<CartModel> get getItems{
    return _cart.getItems;
    }
  }