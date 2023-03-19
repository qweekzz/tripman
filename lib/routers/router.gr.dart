// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;

import '../pages/adminPage/createAddressPage.dart' as _i10;
import '../pages/adminPage/createCampPage.dart' as _i9;
import '../pages/adminPage/createPricePage.dart' as _i11;
import '../pages/adminPage/objectOrderPage.dart' as _i12;
import '../pages/BlocNavigate.dart' as _i1;
import '../pages/homePage.dart' as _i2;
import '../pages/licensePage.dart' as _i7;
import '../pages/loginPage.dart' as _i3;
import '../pages/otpPage.dart' as _i6;
import '../pages/phoneLoginPage.dart' as _i5;
import '../pages/registPage.dart' as _i4;
import '../pages/singleItemPage.dart' as _i8;

class AppRouter extends _i13.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    BlocNavigate.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.BlocNavigate(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.homePage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    RegistrRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.RegistrPage(),
      );
    },
    PhoneLoginRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneLoginRouteArgs>(
          orElse: () => const PhoneLoginRouteArgs());
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PhoneLoginPage(
          key: args.key,
          controllerNumb: args.controllerNumb,
        ),
      );
    },
    OptRoute.name: (routeData) {
      final args = routeData.argsAs<OptRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.optPage(
          key: args.key,
          controllerNumb: args.controllerNumb,
        ),
      );
    },
    LicenseRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.LicensePage(),
      );
    },
    SingleItemRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleItemRouteArgs>(
          orElse: () => SingleItemRouteArgs(itemId: pathParams.getInt('id')));
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.SingleItemPage(
          key: args.key,
          itemId: args.itemId,
          controllerPhone: args.controllerPhone,
          controllerComment: args.controllerComment,
        ),
      );
    },
    CreateCampRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.CreateCampPage(),
      );
    },
    CreateAddressRoute.name: (routeData) {
      final args = routeData.argsAs<CreateAddressRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.CreateAddressPage(
          key: args.key,
          adminId: args.adminId,
          name: args.name,
          type: args.type,
          desc: args.desc,
          human: args.human,
          img: args.img,
          closeDate: args.closeDate,
        ),
      );
    },
    CreatePriceRoute.name: (routeData) {
      final args = routeData.argsAs<CreatePriceRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.CreatePricePage(
          key: args.key,
          adminId: args.adminId,
          name: args.name,
          type: args.type,
          desc: args.desc,
          human: args.human,
          img: args.img,
          closeDate: args.closeDate,
          address: args.address,
        ),
      );
    },
    ObjectOrderRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.ObjectOrderPage(),
      );
    },
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig(
          BlocNavigate.name,
          path: '/',
        ),
        _i13.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i13.RouteConfig(
          LoginRoute.name,
          path: '/login',
        ),
        _i13.RouteConfig(
          RegistrRoute.name,
          path: '/reg',
        ),
        _i13.RouteConfig(
          PhoneLoginRoute.name,
          path: '/phoneLogin',
        ),
        _i13.RouteConfig(
          OptRoute.name,
          path: '/opt',
        ),
        _i13.RouteConfig(
          LicenseRoute.name,
          path: '/license',
        ),
        _i13.RouteConfig(
          SingleItemRoute.name,
          path: '/item/:id',
        ),
        _i13.RouteConfig(
          CreateCampRoute.name,
          path: '/createCamp',
        ),
        _i13.RouteConfig(
          CreateAddressRoute.name,
          path: '/createAddress',
        ),
        _i13.RouteConfig(
          CreatePriceRoute.name,
          path: '/createPrice',
        ),
        _i13.RouteConfig(
          ObjectOrderRoute.name,
          path: '/objectOrder',
        ),
      ];
}

/// generated route for
/// [_i1.BlocNavigate]
class BlocNavigate extends _i13.PageRouteInfo<void> {
  const BlocNavigate()
      : super(
          BlocNavigate.name,
          path: '/',
        );

  static const String name = 'BlocNavigate';
}

/// generated route for
/// [_i2.homePage]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i13.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.RegistrPage]
class RegistrRoute extends _i13.PageRouteInfo<void> {
  const RegistrRoute()
      : super(
          RegistrRoute.name,
          path: '/reg',
        );

  static const String name = 'RegistrRoute';
}

/// generated route for
/// [_i5.PhoneLoginPage]
class PhoneLoginRoute extends _i13.PageRouteInfo<PhoneLoginRouteArgs> {
  PhoneLoginRoute({
    _i14.Key? key,
    dynamic controllerNumb,
  }) : super(
          PhoneLoginRoute.name,
          path: '/phoneLogin',
          args: PhoneLoginRouteArgs(
            key: key,
            controllerNumb: controllerNumb,
          ),
        );

  static const String name = 'PhoneLoginRoute';
}

class PhoneLoginRouteArgs {
  const PhoneLoginRouteArgs({
    this.key,
    this.controllerNumb,
  });

  final _i14.Key? key;

  final dynamic controllerNumb;

  @override
  String toString() {
    return 'PhoneLoginRouteArgs{key: $key, controllerNumb: $controllerNumb}';
  }
}

/// generated route for
/// [_i6.optPage]
class OptRoute extends _i13.PageRouteInfo<OptRouteArgs> {
  OptRoute({
    _i14.Key? key,
    required String controllerNumb,
  }) : super(
          OptRoute.name,
          path: '/opt',
          args: OptRouteArgs(
            key: key,
            controllerNumb: controllerNumb,
          ),
        );

  static const String name = 'OptRoute';
}

class OptRouteArgs {
  const OptRouteArgs({
    this.key,
    required this.controllerNumb,
  });

  final _i14.Key? key;

  final String controllerNumb;

  @override
  String toString() {
    return 'OptRouteArgs{key: $key, controllerNumb: $controllerNumb}';
  }
}

/// generated route for
/// [_i7.LicensePage]
class LicenseRoute extends _i13.PageRouteInfo<void> {
  const LicenseRoute()
      : super(
          LicenseRoute.name,
          path: '/license',
        );

  static const String name = 'LicenseRoute';
}

/// generated route for
/// [_i8.SingleItemPage]
class SingleItemRoute extends _i13.PageRouteInfo<SingleItemRouteArgs> {
  SingleItemRoute({
    _i14.Key? key,
    required int itemId,
    dynamic controllerPhone,
    dynamic controllerComment,
  }) : super(
          SingleItemRoute.name,
          path: '/item/:id',
          args: SingleItemRouteArgs(
            key: key,
            itemId: itemId,
            controllerPhone: controllerPhone,
            controllerComment: controllerComment,
          ),
          rawPathParams: {'id': itemId},
        );

  static const String name = 'SingleItemRoute';
}

class SingleItemRouteArgs {
  const SingleItemRouteArgs({
    this.key,
    required this.itemId,
    this.controllerPhone,
    this.controllerComment,
  });

  final _i14.Key? key;

  final int itemId;

  final dynamic controllerPhone;

  final dynamic controllerComment;

  @override
  String toString() {
    return 'SingleItemRouteArgs{key: $key, itemId: $itemId, controllerPhone: $controllerPhone, controllerComment: $controllerComment}';
  }
}

/// generated route for
/// [_i9.CreateCampPage]
class CreateCampRoute extends _i13.PageRouteInfo<void> {
  const CreateCampRoute()
      : super(
          CreateCampRoute.name,
          path: '/createCamp',
        );

  static const String name = 'CreateCampRoute';
}

/// generated route for
/// [_i10.CreateAddressPage]
class CreateAddressRoute extends _i13.PageRouteInfo<CreateAddressRouteArgs> {
  CreateAddressRoute({
    _i14.Key? key,
    required String adminId,
    required String name,
    required String type,
    required String desc,
    required String human,
    required List<String> img,
    required List<DateTime> closeDate,
  }) : super(
          CreateAddressRoute.name,
          path: '/createAddress',
          args: CreateAddressRouteArgs(
            key: key,
            adminId: adminId,
            name: name,
            type: type,
            desc: desc,
            human: human,
            img: img,
            closeDate: closeDate,
          ),
        );

  static const String name = 'CreateAddressRoute';
}

class CreateAddressRouteArgs {
  const CreateAddressRouteArgs({
    this.key,
    required this.adminId,
    required this.name,
    required this.type,
    required this.desc,
    required this.human,
    required this.img,
    required this.closeDate,
  });

  final _i14.Key? key;

  final String adminId;

  final String name;

  final String type;

  final String desc;

  final String human;

  final List<String> img;

  final List<DateTime> closeDate;

  @override
  String toString() {
    return 'CreateAddressRouteArgs{key: $key, adminId: $adminId, name: $name, type: $type, desc: $desc, human: $human, img: $img, closeDate: $closeDate}';
  }
}

/// generated route for
/// [_i11.CreatePricePage]
class CreatePriceRoute extends _i13.PageRouteInfo<CreatePriceRouteArgs> {
  CreatePriceRoute({
    _i14.Key? key,
    required String adminId,
    required String name,
    required String type,
    required String desc,
    required String human,
    required List<String> img,
    required List<DateTime> closeDate,
    required String address,
  }) : super(
          CreatePriceRoute.name,
          path: '/createPrice',
          args: CreatePriceRouteArgs(
            key: key,
            adminId: adminId,
            name: name,
            type: type,
            desc: desc,
            human: human,
            img: img,
            closeDate: closeDate,
            address: address,
          ),
        );

  static const String name = 'CreatePriceRoute';
}

class CreatePriceRouteArgs {
  const CreatePriceRouteArgs({
    this.key,
    required this.adminId,
    required this.name,
    required this.type,
    required this.desc,
    required this.human,
    required this.img,
    required this.closeDate,
    required this.address,
  });

  final _i14.Key? key;

  final String adminId;

  final String name;

  final String type;

  final String desc;

  final String human;

  final List<String> img;

  final List<DateTime> closeDate;

  final String address;

  @override
  String toString() {
    return 'CreatePriceRouteArgs{key: $key, adminId: $adminId, name: $name, type: $type, desc: $desc, human: $human, img: $img, closeDate: $closeDate, address: $address}';
  }
}

/// generated route for
/// [_i12.ObjectOrderPage]
class ObjectOrderRoute extends _i13.PageRouteInfo<void> {
  const ObjectOrderRoute()
      : super(
          ObjectOrderRoute.name,
          path: '/objectOrder',
        );

  static const String name = 'ObjectOrderRoute';
}
