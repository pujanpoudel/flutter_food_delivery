import 'package:flutter/material.dart';
import 'package:food_delivery/base/common_text_button.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/pages/order/delivery_options.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/styles.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/pages/order/payment_option_button.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../models/place_order_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: Dimensions.height20*3,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: AppIcon(icon: Icons.arrow_back_ios,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.mainColor,
                  iconSize: Dimensions.iconSize24,
                ),
              ),
              SizedBox(width: Dimensions.width20*5,),
              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteHelper.getInitial());
                },
                child: AppIcon(icon: Icons.home_outlined,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.mainColor,
                  iconSize: Dimensions.iconSize24,
                ),
              ),
              AppIcon(icon: Icons.shopping_cart,
                iconColor: Colors.white,
                backgroundColor: AppColors.mainColor,
                iconSize: Dimensions.iconSize24,
              )
            ],
          )),
          GetBuilder<CartController>(builder: (cartController){
            return cartController.getItems.isNotEmpty?Positioned(
                top: Dimensions.height20*5,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: 0,

                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height15),
                  //color: Colors.red,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GetBuilder<CartController>(builder: (cartController){
                      var cartList = cartController.getItems;
                      return ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: (_ , index){
                            return SizedBox(
                              width: double.maxFinite,
                              height: Dimensions.height20*5,
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        var popularIndex = Get.find<PopularProductController>()
                                            .popularProductList
                                            .indexOf(cartList[index].product!);
                                        if(popularIndex>=0){
                                          Get.toNamed(RouteHelper.getPopularFood(popularIndex,"cartpage"));
                                        }else{
                                          var recommendedIndex = Get.find<RecommendedProductController>()
                                              .recommendedProductList
                                              .indexOf(cartList[index].product!);
                                          if(recommendedIndex<0){
                                            Get.snackbar("History product", "Product review is not available for history product",
                                                backgroundColor: AppColors.mainColor,
                                                colorText: Colors.white
                                            );
                                          }else{
                                            Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cartpage"));
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: Dimensions.height20*5,
                                        height: Dimensions.height20*5,
                                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit:BoxFit.cover,
                                                image: NetworkImage(
                                                  AppConstants.BASE_URL+AppConstants.UPLOAD_URL+cartController.getItems[index].img!,
                                                )
                                            ),
                                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(child: SizedBox(
                                    height: Dimensions.height20*5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BigText(text: cartController.getItems[index].name!, color: Colors.black54),
                                        SmallText(text: "spicy"),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            BigText(text: "Rs ${cartController.getItems[index].price}", color: Colors.green),
                                            Container(
                                              padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10, left: Dimensions.width10, right: Dimensions.width10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                  color: Colors.white
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: (){
                                                        cartController.addItem(cartList[index].product!, -1);
                                                      },
                                                      child: const Icon(Icons.remove, color: AppColors.signColor)),
                                                  SizedBox(width: Dimensions.width10),
                                                  BigText(text: cartList[index].quantity.toString()),//popularProduct.intCartItems.toString()),
                                                  SizedBox(width: Dimensions.width10),
                                                  GestureDetector(
                                                      onTap: (){
                                                        cartController.addItem(cartList[index].product!, 1);
                                                      },
                                                      child: const Icon(Icons.add, color: AppColors.signColor))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          });
                    }),
                  ),
                )):const NoDataPage(text: "Your cart is empty!");
          })
        ],
      ),
      bottomNavigationBar: GetBuilder<OrderController>(builder: (orderController){
        noteController.text = orderController.foodNote;
        return GetBuilder<CartController>(builder:(cartController){
          return Container(
              height: Dimensions.bottomHeightBar+50,
              padding: EdgeInsets.only(top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20*2),
                      topRight: Radius.circular(Dimensions.radius20*2)
                  )
              ),
              child: cartController.getItems.isNotEmpty?Column(
                children: [
                  InkWell(
                    onTap: ()=>showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_){
                          return Column(
                            children:[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                      height: MediaQuery.of(context).size.height*0.9,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(Dimensions.radius20),
                                              topRight: Radius.circular(Dimensions.radius20)
                                          )
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 600,
                                            padding: EdgeInsets.only(
                                                left: Dimensions.width20,
                                                right: Dimensions.width20,
                                                top: Dimensions.height20
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const PaymentOptionButton(
                                                  icon: Icons.money,
                                                  title: 'cash on delivery',
                                                  subTitle: 'you pay after getting food',
                                                  index: 0,
                                                ),
                                                SizedBox(height: Dimensions.height10),
                                                const PaymentOptionButton(
                                                  icon: Icons.payment,
                                                  title: 'Pay with Khalti',
                                                  subTitle: 'faster and safer',
                                                  index: 1,
                                                ),
                                                SizedBox(height: Dimensions.height30),
                                                Text("Delivery 0ptions", style: robotoMedium,),
                                                SizedBox(height: Dimensions.height10),
                                                DeliveryOptions(value: "delivery",
                                                  title: "home delivery",
                                                  amount: double.parse(Get.find<CartController>().totalAmount.toString()),
                                                  isFree: false,),
                                                SizedBox(height: Dimensions.height10),
                                                const DeliveryOptions(value: "Take away",
                                                  title: "Take away",
                                                  amount: 10.0,
                                                  isFree: true,),
                                                SizedBox(height: Dimensions.height20,),
                                                Text("Additional note",style: robotoMedium,),
                                                SizedBox(height: Dimensions.height10/2),
                                                AppTextField(textController: noteController,
                                                  hintText: '',
                                                  icon: Icons.note,
                                                  maxLines: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    ).whenComplete(() => orderController.setFoodNote(noteController.text.trim())),
                    child: const SizedBox(
                      width: double.maxFinite,
                      child: CommonTextButton(text: "Payment Option"),
                    ),
                  ),
                  SizedBox(height: Dimensions.height10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: Dimensions.height20,
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white
                        ),
                        child: Row(
                          children: [

                            SizedBox(width: Dimensions.width10/2),
                            BigText(text: "Rs ${cartController.totalAmount}"),
                            SizedBox(width: Dimensions.width10/2),

                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: (){
                            if(Get.find<AuthController>().userLoggedIn()){
                              if(Get.find<LocationController>().addressList.isEmpty){
                                Get.toNamed(RouteHelper.getAddressPage());
                              }else{
                                var location = Get.find<LocationController>().getUserAddress();
                                var cart = Get.find<CartController>().getItems;
                                var user = Get.find<UserController>().userModel;
                                PlaceOrderBody placeOrder = PlaceOrderBody(
                                    cart: cart,
                                    orderAmount: 100.0,
                                    orderNote: orderController.foodNote,
                                    address: location.address,
                                    latitude: location.latitude,
                                    longitude: location.longitude,
                                    contactPersonNumber: user!.phone,
                                    contactPersonName: user.name,
                                    scheduleAt: '',
                                    distance: 10.0,
                                    orderType: orderController.orderType,
                                    paymentMethod: orderController.paymentIndex==0?'cash_on_delivery':'digital_payment',
                                );
                                Get.find<OrderController>().placeOrder(
                                    placeOrder,
                                    _callback
                                );
                              }
                            }else {
                              Get.toNamed(RouteHelper.getSignInPage());
                            }
                          },
                          child: const CommonTextButton(text: "Check Out",)
                      )
                    ],
                  )
                ],
              ):Container()
          );
        });
      })
    );
  }
  void _callback(bool isSuccess, String message, String orderID){
    if(isSuccess){
      Get.find<CartController>().clear();
      Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
      if(Get.find<OrderController>().paymentIndex==0){
        Get.offNamed(RouteHelper.getOrderSuccessPage(orderID, "success"));
      }else{
        Get.toNamed(RouteHelper.getPaymentPage(orderID, Get.find<UserController>().userModel!.id));

      }
    }else{
      showCustomSnackBar(message);
    }
  }
}
