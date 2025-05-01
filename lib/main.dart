import 'package:feedback/feedback.dart';
import 'package:url_strategy/url_strategy.dart';

import 'common/not_found.dart';
import 'constants/routes_names.dart';

// // // // // // // // START_DISABLE
// import 'package:foodly_user/web_utils/main_web.dart'
// if (dart.library.io) 'package:foodly_user/mobile_utils/main_mobile.dart';
// // // // // // // // END_DISABLE
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/firebase_options.dart';
import 'package:foodly_user/services/init_dependencies.dart';
import 'package:foodly_user/views/auth/verification_page.dart';
import 'package:foodly_user/views/entrypoint.dart';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodly_user/services/notification_service.dart';
import 'package:get_storage/get_storage.dart';
import 'models/environment.dart'; // Import the new file

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Widget defaultHome = MainScreen();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.loadEnv();


  if (!kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Initialize Firebase Messaging only for mobile platforms (iOS/Android)
    FirebaseMessaging _fireMsg = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      String? apnsToken = await _fireMsg.getAPNSToken();
      if (apnsToken != null) {
        await _fireMsg.subscribeToTopic("foodly");
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await _fireMsg.getAPNSToken();
        if (apnsToken != null) {
          await _fireMsg.subscribeToTopic("foodly");
        }
      }
    } else {
      await _fireMsg.subscribeToTopic("foodly");
    }
  } else {
    // For web, initialize Firebase but skip Firebase Messaging
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBy0My66SO_S8p1BXajWuUQPiI_XRwQO7Y",
          authDomain: "flutter-foodly-final-7d6ce.firebaseapp.com",
          databaseURL:
              "https://flutter-foodly-final-7d6ce-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "flutter-foodly-final-7d6ce",
          storageBucket: "flutter-foodly-final-7d6ce.appspot.com",
          messagingSenderId: "478084903744",
          appId: "1:478084903744:web:0ef129fa03529bd7c100a5"),
    );
    // No Firebase Messaging setup for web
  }

  // Initialize dependencies
  await initDependencies();

  if (!kIsWeb) {
    await NotificationService().initialize(flutterLocalNotificationsPlugin);
  }
  setPathUrlStrategy();
  // Enables path-based routing

  runApp(BetterFeedback(

      child: MyApp())
  );
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    print("we are starting the process...");
// // // START_DISABLE
// webRedirectAfterPayment();
// // END_DISABLE

    if (!kIsWeb) {
     /// monitorNetwork();
    }
  }

  @override
  void dispose() {
    // Ensure to cancel the subscription when the widget is disposed
    connectivitySubscription.cancel();
    super.dispose();
  }

/*  void monitorNetwork() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Delay for 5 seconds to ensure no false positives
      await Future.delayed(const Duration(seconds: 5));

      bool connected = await checkNetworkConnection();

      if (connected) {
        setState(() {
          isConnected = true;
        });
        // Dismiss snackbar if reconnected
        Get.closeAllSnackbars();
      } else {
        setState(() {
          isConnected = false;
        });
        showNoConnectionMessage(context);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    bool? verification = box.read("verification");

    Widget defaultHome = MainScreen();
    if (token != null && verification == false) {
      defaultHome = const VerificationPage();
    } else if (token != null && verification == true) {
      defaultHome = MainScreen();
    }

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: kIsWeb ? const Size(1280, 720) : const Size(375, 825),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Default case when no redirect parameters are detected
        return GetMaterialApp(
          opaqueRoute: true,
          debugShowCheckedModeBanner: false,
          // scrollBehavior: AppScrollBehavior(),
          title: 'Foodly User App',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kWhite.value),
              iconTheme: IconThemeData(color: Color(kSecondary.value)),
              primarySwatch: Colors.grey,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: Colors.black,
            ),
            ),
          // home: defaultHome,
          navigatorKey: navigatorKey,
          initialRoute: RouteNames.getSplashRoute(),

          getPages: RouteNames.routes,
          defaultTransition: Transition.fade,

          routingCallback: (routing) {
            // Global check can also log current routing
            if (routing?.current == null) {
              Get.toNamed(RouteNames.notFoundPage);
            }
          },
          unknownRoute: GetPage(
            name: RouteNames.notFoundPage,
            page: () => const NotFoundPage(),
          ),
        );
      },
    );
  }

  // Show a message using context
  void showNoConnectionMessage(BuildContext context) {
    Get.snackbar(
      "No Internet Connection",
      "Please check your network settings",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

Future<bool> checkNetworkConnection() async {
  if (kIsWeb) {
    return true; // Check for web connectivity
  } else {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        ConnectivityResult == ConnectivityResult.wifi;
  }
}
