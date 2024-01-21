import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/src/auth/data/my_profile.dart';
import 'package:sos/src/home_screen/presentation/widgets/help_button.dart';
import 'widgets/status_widget.dart';
import 'package:sos/src/home_screen/presentation/my_requests_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sos/src/routing/app_router.dart';
import 'widgets/welcome_user_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  OverlayEntry? overlayWidget;
  void closeOverlay() {
    if (overlayWidget == null) return;
    overlayWidget?.remove();
    overlayWidget = null;
  }

  void overlayWidgetDialog(BuildContext context, {required Widget child}) {
    closeOverlay();
    overlayWidget = OverlayEntry(builder: (context) {
      return child;
    });

    Overlay.of(context).insert(overlayWidget!);
  }

  void initializeMessages() async {
    final goRouter = ref.read(goRouterProvider);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Map data = message.data;
        if (goRouter.location.startsWith('/chat')) {
          context.pushReplacement(
              '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
        } else {
          context.push(
              '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      Map data = event.data;
      if (goRouter.location.startsWith('/chat')) {
        context.pushReplacement(
            '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
      } else {
        context.push(
            '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
      }
    });

    FirebaseMessaging.onMessage.listen((event) async {
      Map data = event.data;

      overlayWidgetDialog(context,
          child: Positioned(
              left: 0,
              top: 20,
              width: MediaQuery.of(context).size.width,
              child: Material(
                  type: MaterialType.transparency,
                  elevation: 10,
                  child: InkWell(
                      onTap: () async {
                        closeOverlay();
                        if (goRouter.location.startsWith('/chat')) {
                          context.pushReplacement(
                              '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
                        } else {
                          context.push(
                              '/chat?requestId=${data['requestId']}&userId=${data['userId']}');
                        }
                      },
                      child: Dismissible(
                          key: const Key('in_app_notification_dismissible_'),
                          direction: DismissDirection.up,
                          onDismissed: (direction) {
                            closeOverlay();
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.info),
                                      const Text(
                                          "You received a new request.\nTap to open",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      IconButton(
                                          onPressed: closeOverlay,
                                          icon: const Icon(Icons.close)),
                                    ]),
                              )))))));
      Future.delayed(const Duration(seconds: 4))
          .then((value) => closeOverlay());
    });
  }

  late TabController tabController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeMessages();
    initializeLocation();
  }

  void initializeLocation() async {
    print("Call InitializeLocation");
    Position p = await Geolocator.getCurrentPosition();
    print(p);
    GeoFirePoint geoFirePoint =
        GeoFlutterFire().point(latitude: p.latitude, longitude: p.longitude);
    String user = FirebaseAuth.instance.currentUser!.uid;
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(user).set(
      {'position': geoFirePoint.data, 'message_token': token},
      SetOptions(merge: true),
    );
  }

  @override
  void initState() {
    super.initState();
    print(
        "isOnboardingComplete HomeScreen ${FirebaseAuth.instance.currentUser != null}");
    tabController = TabController(length: 2, vsync: this);
  }

  final PanelController _pc = PanelController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SlidingUpPanel(
        minHeight: 70,
        controller: _pc,
        parallaxEnabled: true,
        backdropEnabled: true,
        parallaxOffset: .5,
        body: _body(),
        panelBuilder: (sc) => _panel(sc),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    ScrollController sc2 = ScrollController();
    final firestore = ref.watch(firestoreInstanceProvider);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(
          height: 12.0,
        ),
        GestureDetector(
          onTap: () {
            if (_pc.panelPosition > 0.9) {
              _pc.close();
            } else {
              _pc.open();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Text(
                "Requests",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 36.0,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                tabs: const <Widget>[
                  Tab(
                    text: "My Requests",
                  ),
                  Tab(
                    text: "History",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: [
                  ListView(
                    shrinkWrap: true,
                    controller: sc,
                    children: <Widget>[
                      Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: MyRequestsScreen(
                              requestsQuery: firestore
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('requests')
                                  .orderBy('time', descending: true))),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    controller: sc2,
                    children: <Widget>[
                      Container(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: MyRequestsScreen(
                              requestsQuery: firestore
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('history')
                                  .orderBy('time', descending: true))),
                      SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
                ]),
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget _body() {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WelcomeUserWidget(),
            SizedBox(
              height: 20,
            ),
            Text("ARE YOU IN EMERGENCY?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            SizedBox(
              height: 20,
            ),
            Text("Press the button below to call for help.",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            HelpButton(),
            SizedBox(
              height: 30,
            ),
            StatusWidget(),
          ],
        ),
      ),
    );
  }
}
