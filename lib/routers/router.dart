import 'package:auto_route/auto_route.dart';

import 'package:tripman/pages/BlocNavigate.dart';
import 'package:tripman/pages/adminPage/createAddressPage.dart';
import 'package:tripman/pages/adminPage/createCampPage.dart';
import 'package:tripman/pages/adminPage/createPricePage.dart';
import 'package:tripman/pages/adminPage/objectOrderPage.dart';
import 'package:tripman/pages/homePage.dart';
import 'package:tripman/pages/licensePage.dart';
import 'package:tripman/pages/loginPage.dart';
import 'package:tripman/pages/phoneLoginPage.dart';
import 'package:tripman/pages/registPage.dart';
import 'package:tripman/pages/otpPage.dart';
import 'package:tripman/pages/singleItemPage.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: BlocNavigate, path: '/', initial: true),
    AutoRoute(page: homePage, path: '/home'),
    AutoRoute(page: LoginPage, path: '/login'),
    AutoRoute(page: RegistrPage, path: '/reg'),
    AutoRoute(page: PhoneLoginPage, path: '/phoneLogin'),
    AutoRoute(page: optPage, path: '/opt'),
    AutoRoute(page: LicensePage, path: '/license'),
    AutoRoute(page: SingleItemPage, path: '/item/:id'),
    AutoRoute(page: CreateCampPage, path: '/createCamp'),
    AutoRoute(page: CreateAddressPage, path: '/createAddress'),
    AutoRoute(page: CreatePricePage, path: '/createPrice'),
    AutoRoute(page: ObjectOrderPage, path: '/objectOrder'),
  ],
)
class $AppRouter {}
