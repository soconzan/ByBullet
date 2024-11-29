import 'package:bybullet/app/features/main/bindings/main_binding.dart';
import 'package:get/get.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/main/pages/daily_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/login', page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: '/signup', page: () => SignUpPage(), binding: AuthBinding()),
    GetPage(name: '/daily', page: () => DailyPage(), binding: MainBinding()),
  ];
}