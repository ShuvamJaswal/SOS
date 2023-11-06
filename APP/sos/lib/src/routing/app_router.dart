// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/src/chat_screen/presentation/chat_screen.dart';
import 'package:sos/src/home_screen/presentation/home_screen.dart';
import 'package:sos/src/onboarding/data/onboarding_provider.dart';
import 'package:sos/src/onboarding/presentation/onboarding_screen.dart';
import 'go_router_refresh_stream.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_router.g.dart';

enum AppRoute {
  onBoarding,
  home,
  profile,
  about,
  chat,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  Stream refreshStream = StreamGroup.merge([
    FirebaseAuth.instance.authStateChanges(),
    Geolocator.getServiceStatusStream(),
    ref.watch(appStateProvider).stream,
  ]);
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      refreshListenable: GoRouterRefreshStream(refreshStream),
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/chat',
          name: AppRoute.chat.name,
          pageBuilder: (context, state) {
            return MaterialPage(
              // fullscreenDialog: true,
              child: ChatS(
                  requestId: state.queryParameters['requestId'] ?? '',
                  userId: state.queryParameters['userId'] ?? ''),
            );
          },
        ),
        GoRoute(
          path: '/onboarding',
          name: AppRoute.onBoarding.name,
          builder: (context, state) => OnboardingScreen(),
        ),
      ],
      redirect: (context, state) async {
        
        final isOnboardingComplete =
            await ref.watch(onboardingrepositoryProvider).onBoardingComplete();
        if (!isOnboardingComplete) {
          if (state.location != '/onboarding') {
            return state.namedLocation(AppRoute.onBoarding.name);
          }
        } else if (state.location == '/onboarding') {
          return state.namedLocation(AppRoute.home.name);
        }
        return null;
      });
}
