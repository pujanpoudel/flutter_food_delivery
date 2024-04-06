import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/utils/styles.dart';
import 'package:get/get.dart';
import '../../utils/dimensions.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final double amount;
  final bool isFree;
  const DeliveryOptions({Key? key,
    required this.value,
    required this.title,
    required this.isFree,
    required this.amount
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      return Row(
        children: [
          Radio(value: value,
            groupValue: orderController.orderType,
            onChanged: (String? value)=>orderController.setDeliveryType(value!),
            activeColor: Theme.of(context).primaryColor,

          ),
          SizedBox(
            width: Dimensions.width10/2,
          ),
          Text(title, style: robotoRegular),
          SizedBox(
            width: Dimensions.width10/2,
          ),
          Text(
            '(${(value== 'take away'||isFree)?'Free':'Rs${amount/10}'})',
            style: robotoMedium,
          )
        ],
      );
    });
  }
}
