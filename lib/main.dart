import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/notification_service.dart';
import 'package:massageapp/route_handler.dart';
import 'package:massageapp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController());
  Get.put<CategoryController>(CategoryController());
  Get.put<ShopController>(ShopController());
  Get.put<BookingController>(BookingController());
  NotificationService().initializeLocalNotifications();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color(0Xffa0b43f)));
  runApp(GetMaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    locale: Locale('ko'),
    supportedLocales: [
      Locale('en', ''),
      Locale('ko', ''),
    ],
    scrollBehavior: CupertinoScrollBehavior(),
    theme: ThemeData(
        primaryColor: Color(0Xffa0b43f),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0Xffa0b43f),
            iconTheme: IconThemeData(
              color: Colors.white,
            )),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
            headline6: TextStyle(color: Colors.black, fontSize: 16),
            bodyText1: TextStyle(color: Colors.white))),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    onGenerateRoute: RouterHandler.generateRoute,
  ));
}
