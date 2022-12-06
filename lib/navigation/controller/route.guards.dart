

import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class   ProfileRouteGuard extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    return authService.user.isAuthenticated
        ? null
        : const RouteSettings(name: AppRoutes.authSignIn);
  }
}

class   AppEmailVerificationRouteGuard extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    return authService.user.emailIsVerified
        ? null
        : const RouteSettings(name: AppRoutes.authSignIn);
  }
}