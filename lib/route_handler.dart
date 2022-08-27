import 'package:flutter/cupertino.dart';
import 'package:massageapp/admin/screens/admin_home_screen.dart';
import 'package:massageapp/admin/screens/chat_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_category_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_setting_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_shop_recomendations_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_shop_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_user_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_amin_shop_details_screen.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/screens/booking_screen.dart';
import 'package:massageapp/screens/forgot_password_screen.dart';
import 'package:massageapp/screens/nav_screen.dart';
import 'package:massageapp/screens/password_change_screen.dart';
import 'package:massageapp/screens/recomended_shop_screen.dart';
import 'package:massageapp/screens/resevation_payment_screen.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/screens/shop_by_category.dart';
import 'package:massageapp/screens/user_point_screen.dart';
import 'package:massageapp/screens/user_register_screen.dart';

import 'admin/screens/custom_reservation_time_setup_screen.dart';
import 'admin/screens/payment_information_screen.dart';
import 'admin/super_admin/screen/add_category_screen.dart';
import 'admin/super_admin/screen/payment_request_screen.dart';
import 'admin/super_admin/screen/super_admin_dashboard_screen.dart';
import 'screens/favorite_shop_list_screen.dart';
import 'screens/recomend_shop_screen.dart';

class RouterHandler {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final routeName = settings.name;
    switch (routeName) {
      case LoginScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => LoginScreen(), settings: settings);
      case ShopRegisteScreen.routeName:
        return CupertinoPageRoute(builder: (_) => ShopRegisteScreen());
      case HomeScreen.routeName:
        return CupertinoPageRoute(builder: (_) => HomeScreen());
      case ShopDetailScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ShopDetailScreen(
                  shop: args as Shop,
                ));
      case ShopByCategory.routeName:
        return CupertinoPageRoute(
            builder: (_) => ShopByCategory(
                  selectedCategory: args as ShopCategory,
                ));
      case AddWorkGalleryScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AddWorkGalleryScreen(
                  shop: args as Shop,
                ));
      case PhotoView.routeName:
        return CupertinoPageRoute(
            builder: (_) => PhotoView(
                  workGallery: args as WorkGallery,
                ));

      case UserPointScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => UserPointScreen(
                  userId: args is String ? args : null,
                ));
      case RecomendShopScreen.routeName:
        return CupertinoPageRoute(builder: (_) => RecomendShopScreen());

      case ShopRecomendedListScreen.routeName:
        return CupertinoPageRoute(builder: (_) => ShopRecomendedListScreen());

      //admin section

      case SuperAdminShopRecomendationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SuperAdminShopRecomendationScreen());
      case AdminHomeScreen.routeName:
        return CupertinoPageRoute(builder: (_) => AdminHomeScreen());
      //booking section
      case BookingScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => BookingScreen(shop: args as Shop));
      case NavigationScreen.routeName:
        return CupertinoPageRoute(builder: (_) => NavigationScreen());

      ///admin
      ///
      case SuperAdmninDashboardScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SuperAdmninDashboardScreen());
      case SuperAdminShopScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SuperAdminShopScreen());

      case SuperAdminUserScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SuperAdminUserScreen());
      case SuperAdminCategoryScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SuperAdminCategoryScreen());

      case SuperAdminSettingScreen.routeName:
        return CupertinoPageRoute(builder: (_) => SuperAdminSettingScreen());
      case AddCategoryScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AddCategoryScreen(
                  shopCategory: args is ShopCategory ? args : null,
                ));
      case SuperAdminShopDetailsScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => SuperAdminShopDetailsScreen(
                  shopId: args as String,
                ));
      case AdminChatScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => AdminChatScreen(
                  user: args is ApplicationUser ? args : null,
                  selectedShop: args is Shop ? args : null,
                ));
      case PaymentRequestScreen.routeName:
        return CupertinoPageRoute(builder: (_) => PaymentRequestScreen());
      case PaymentInformationScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => PaymentInformationScreen(
                  shop: args as Shop,
                ));

      case ReservationPaymentScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ReservationPaymentScreen(
                  shop: args as Shop,
                ));

      case UserRegisterScreen.routeName:
        return CupertinoPageRoute(builder: (_) => UserRegisterScreen());
      case PasswordChangeScreen.routeName:
        return CupertinoPageRoute(builder: (_) => PasswordChangeScreen());
      case ForgotPasswordScreen.routeName:
        return CupertinoPageRoute(builder: (_) => ForgotPasswordScreen());
      case FavoriteShopListScreen.routeName:
        return CupertinoPageRoute(builder: (_) => FavoriteShopListScreen());

      case CustomReservationTimeSetupScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => CustomReservationTimeSetupScreen());

      default:
        return CupertinoPageRoute(builder: (_) => LoginScreen());
    }
  }
}
