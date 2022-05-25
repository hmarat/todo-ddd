import 'package:auto_route/auto_route.dart';
import 'package:ddd/presentation/sign_in/sign_in_page.dart';
import 'package:ddd/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage),
    AutoRoute(page: SplashPage, initial: true),
  ],
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {}
