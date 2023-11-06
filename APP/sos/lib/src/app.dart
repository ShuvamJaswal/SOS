import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/src/onboarding/data/onboarding_provider.dart';
import 'package:sos/src/routing/app_router.dart';
import 'package:sos/globals.dart';

class MyApp extends ConsumerStatefulWidget with WidgetsBindingObserver {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final goRouter = ref.read(goRouterProvider);
    // onBoarding();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {
    //     Map data = message.data;
    //     goRouter.push(
    //         '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   Map data = event.data;
    //   goRouter.push(
    //       '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    ref.read(appStateProvider).sink.add(1);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies, Check this
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      scaffoldMessengerKey: snackbarKey,

      // theme: ThemeData.dark().copyWith(useMaterial3: true),
      routerConfig: goRouter,
    );
  }
}
