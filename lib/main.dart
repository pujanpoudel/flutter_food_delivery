import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'controllers/recommended_product_controller.dart';
import 'helper/dependencies.dart' as dep;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
  //await dotenv.load(fileName: ".env");
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(builder: (_) {
      return GetBuilder<RecommendedProductController>(builder: (_) {
        return KhaltiScope(
            publicKey: "test_public_key_d5d9f63743584dc38753056b0cc737d5",
            enabledDebugging: true,
            builder: (context, navKey) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Online Restaurant',
                //home: SignInPage(),
                //home: SplashScreen(),
                initialRoute: RouteHelper.getSplashPage(),
                getPages: RouteHelper.routes,
                theme: ThemeData(
                    primaryColor: AppColors.mainColor,
                    fontFamily: "Lato"
                ),
                navigatorKey: navKey,
                localizationsDelegates: const [
                  KhaltiLocalizations.delegate,
                ],
              );
            });
      });
    });
  }
}
