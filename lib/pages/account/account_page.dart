import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/account_widget.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';
//import 'package:dice_bear/dice_bear.dart';
import '../../base/custom_app_bar.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if(userLoggedIn){
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }
    return Scaffold(
      appBar: const CustomAppBar(
        title: ("Profile"),
      ),
      body: GetBuilder<UserController>(builder: (userController){
        return userLoggedIn?
        (userController.isLoading?Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(
            top: Dimensions.height20,
          ),
          child: Column(
            children: [
              //profile icon
              AppIcon(icon: Icons.person,
                  backgroundColor: AppColors.mainColor,
                  iconColor: Colors.white,
                  iconSize: Dimensions.height15*5,
                  size: Dimensions.height15*10),
              SizedBox(height: Dimensions.height30),
              //name
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //name
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.person,
                          backgroundColor: AppColors.mainColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
                        ),
                        bigText: BigText(text:userController.userModel!.name)
                      ),
                      SizedBox(height: Dimensions.height10),
                      //phone
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.phone,
                          backgroundColor: AppColors.yellowColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
                        ),
                        bigText: BigText(text:userController.userModel!.phone)
                      ),
                      SizedBox(height: Dimensions.height10),
                      //email
                      AccountWidget(
                        appIcon: AppIcon(icon: Icons.email,
                          backgroundColor: AppColors.yellowColor,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10*5/2,
                          size: Dimensions.height10*5,
                        ),
                        bigText: BigText(text:userController.userModel!.email)
                      ),
                      SizedBox(height: Dimensions.height10),
                      //address
                      GetBuilder<LocationController>(builder: (locationController){
                        if(userLoggedIn&&locationController.addressList.isEmpty){
                          return GestureDetector(
                            onTap: (){
                              Get.offNamed(RouteHelper.getAddressPage());
                            },
                            child: AccountWidget(
                              appIcon: AppIcon(icon: Icons.location_on,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10*5/2,
                                size: Dimensions.height10*5,
                              ),
                              bigText: BigText(text: "Your location"),
                            ),
                          );
                        }else{
                          return GestureDetector(
                            onTap: (){
                              Get.offNamed(RouteHelper.getAddressPage());
                            },
                            child: AccountWidget(
                              appIcon: AppIcon(icon: Icons.location_on,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10*5/2,
                                size: Dimensions.height10*5,
                              ),
                              bigText: BigText(text: "Delivery location"),
                            ),
                          );
                        }
                      }),
                      // SizedBox(height: Dimensions.height10),
                      // //message
                      // AccountWidget(
                      //   appIcon: AppIcon(icon: Icons.message_outlined,
                      //     backgroundColor: Colors.redAccent,
                      //     iconColor: Colors.white,
                      //     iconSize: Dimensions.height10*5/2,
                      //     size: Dimensions.height10*5,
                      //   ),
                      //   bigText: BigText(text: "Messages"),
                      // ),
                      SizedBox(height: Dimensions.height10),
                      GestureDetector(
                        onTap: (){
                          if(Get.find<AuthController>().userLoggedIn()){
                            Get.find<AuthController>().clearSharedData();
                            Get.find<CartController>().clear();
                            Get.find<CartController>().clearCartHistory();
                            Get.find<LocationController>().clearAddressList();
                            Get.offNamed(RouteHelper.getSignInPage());
                          }else{
                            Get.offNamed(RouteHelper.getSignInPage());
                          }
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(icon: Icons.logout,
                            backgroundColor: Colors.redAccent,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height10*5/2,
                            size: Dimensions.height10*5,
                          ),
                          bigText: BigText(text: "Log Out"),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ):
        const CustomLoader()):
        Container(

            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              height: Dimensions.height20*8,
              margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "assets/image/signintocontinue.png"
                      )
                  )
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.toNamed(RouteHelper.getSignInPage());
              },
              child: Container(

                width: double.maxFinite,
                height: Dimensions.height20*5,
                margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),

                ),
                child: Center(child: BigText(text: "Sign in", color: Colors.white, size: Dimensions.font26,)),
              ),
            ),
          ],
        )));
      }),
    );
  }
}
