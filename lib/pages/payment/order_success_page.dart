import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderID;
  final int status;
  const OrderSuccessPage({Key? key, required this.orderID, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(status == 0){
      Future.delayed(const Duration(seconds: 1),(){

      });
    }
    return Scaffold(
      body: Center(child: SizedBox(width: Dimensions.screenWidth, child:
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(status==1? Icons.check_circle_outline:Icons.warning_amber_outlined,
        size: 100, color: AppColors.mainColor),

        SizedBox(height: Dimensions.height30),

        Text(
          status == 1? 'You placed the order successfully' : 'Your order failed',
          style: TextStyle(fontSize: Dimensions.font20),
        ),

        Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height20,
            vertical: Dimensions.height10),
          child: Text(
          status == 1 ? 'Successful order' : 'Failed order',
            style: TextStyle(fontSize: Dimensions.font20,
            color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
            ),
        ),

        SizedBox(height:Dimensions.height10),

        Padding(padding: EdgeInsets.all(Dimensions.height10),
        child: CustomButton(buttonText: 'Back to Home', onPressed:
        ()=> Get.offNamed(RouteHelper.getInitial())
        ),
        )

      ])
      )),
    );
  }
}
