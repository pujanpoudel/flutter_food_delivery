import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/order_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';

class PaymentPage extends StatefulWidget {
  final OrderModel orderModel;
  const PaymentPage({Key? key, required this.orderModel}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String referenceId = "";
  late String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late WebViewController controllerGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Options"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  payWithKhaltiInApp();
                },
                child: const Text("Pay with Khalti")),
            Text(referenceId)
          ],
        ),
      ),
    );
  }

  payWithKhaltiInApp() {
    var orderId = widget.orderModel.id;
    double? orderAmt = widget.orderModel.orderAmount;
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: orderId.toString(),//'Product id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,

      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),

          actions: [
            SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                    print(success.token);
                  });

                  Navigator.pop(context);
                }),

          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }
  void _redirect(String url) {
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
      }
      if (isSuccess) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(widget.orderModel.id.toString(), 'success'));
      } else if (isFailed || isCancel) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(widget.orderModel.id.toString(), 'fail'));
      }else{
        print("Encountered problem");
      }
    }
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      print("app exited");
      return true;
      //return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
    }
  }
}