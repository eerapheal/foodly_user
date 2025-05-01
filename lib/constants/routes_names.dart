import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/middlewares/app_middlewares.dart';
import 'package:foodly_user/middlewares/food_middlewares.dart';
import 'package:foodly_user/middlewares/global_middlewares.dart';
import 'package:foodly_user/middlewares/store_middlewares.dart';
import 'package:foodly_user/middlewares/title_middlewares.dart';
import 'package:foodly_user/models/client_orders.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/views/app/app_version_info.dart';
import 'package:foodly_user/views/auth/login_page.dart';
import 'package:foodly_user/views/cart/cart_page.dart';
import 'package:foodly_user/views/categories/categories_page.dart';
import 'package:foodly_user/views/categories/more_categories.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:foodly_user/views/food/food_page.dart';
import 'package:foodly_user/views/home/all_nearby_restaurants.dart';
import 'package:foodly_user/views/home/fastest_foods_page.dart';
import 'package:foodly_user/views/home/recommendations.dart';
import 'package:foodly_user/views/message/chat/view.dart';
import 'package:foodly_user/views/message/photoview/index.dart';
import 'package:foodly_user/views/message/view.dart';
import 'package:foodly_user/views/orders/client_orders.dart';
import 'package:foodly_user/views/orders/multiple_item_checkout_page.dart';
import 'package:foodly_user/views/orders/order_details_page.dart';
import 'package:foodly_user/views/orders/payments/successful_web.dart';
import 'package:foodly_user/views/orders/points/point_gained.dart';
import 'package:foodly_user/views/points/user_points.dart';
import 'package:foodly_user/views/profile/address.dart';
import 'package:foodly_user/views/profile/shipping_address.dart';
import 'package:foodly_user/views/restaurant/directions_page.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:foodly_user/views/reviews/rating_review_page.dart';
import 'package:foodly_user/views/reviews/review_page.dart';
import 'package:foodly_user/views/settings/reset_password_page.dart';
import 'package:foodly_user/views/settings/settings_page.dart';
import 'package:foodly_user/views/splash/splash_screen.dart';
import 'package:get/get.dart';
import '../views/orders/payments/successful.dart';

class RouteNames {
  static const String initial = '/';
  static const String splash = '/splash';

  //food and restaurant
  static const String detailFood = '/detail-food';
  static const String orderDetail = '/order-detail';
  static const String clientOrders = '/client-orders';
  static const String restaurantInfo = '/restaurant-info';
  static const String restaurantDirection = '/restaurant-direction';

  static const String accountPage = '/account-page';
  static const String cartPage = '/cart-page';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';

  //static const String address = '/address';
  static const String pickMap = '/pick-map';

  //payment route
  static const String checkoutPage = '/checkout-page';
  static const String payment = '/payment';
  static const String orderSuccessWeb = '/checkout-success-web';
  static const String orderSuccess = '/checkout-success';

  static const String updateProfile = '/update-profile';
  static const String search = '/search';

  //rating and review
  static const String reviewRating = '/review-rating';
  static const String rateOrder = '/rate-orders';

  //address
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';

  //points
  static const String pointsGained = '/points-gained';
  static const String userPoints = '/user-points';

  //404
  static const String notFoundPage = '/not-found-page';

  //categories
  static const String allCategories = '/all-categories';
  static const String category = '/category';
  static const String allNearbyRestaurants = '/all-nearby-restaurants';
  static const String recommendations = '/recommendations';
  static const String fastestFoods = '/fastest-foods';
  //app settings and version
  static const String appVersion = '/app-version';

  //message and chat
  static const String chatList = '/chat-list';
  static const String chatPage = '/chat-page';
  static const String chatImageView = '/chat-image-view';

  //settings
  static const String settings = '/settings';
  static const String resetPassword = '/reset-password';

  static String getMainScreenRoute() => initial;

  static String getSplashRoute() => splash;

  static String getSignInRoute() => signIn;

  static String getCartRoute() => cartPage;

  static String getCheckoutPageRoute() => checkoutPage;

  static String getClientOrders() => clientOrders;

  //review rate
  static String getReviewRatingRoute() => reviewRating;

  static String getRateOrderRoute() => rateOrder;

  //points gained
  static String getPointsGained() => pointsGained;

  static String getUserPoints() => userPoints;

  static String getCheckoutSuccessWeb()=> orderSuccessWeb;

  //add address
  static String getAddresses() => addresses;

  static String getAddAddress() => addAddress;

  //404
  static String getNotFoundPage() => notFoundPage;

  //all categories
  static String getAllCategoriesPage() => allCategories;
  static String getAllNearbyRestaurantsPage() => allNearbyRestaurants;
  static String getRecommendations() => recommendations;
  static String getFastestFoods() => fastestFoods;

  //app version and info
  static String getAppVersionPage() => appVersion;

  static String getCategory(String name, String catId) =>
      '$category/${Uri.encodeComponent(name)}/$catId';

  static String getDetailFoodRoute(String name, String foodId) =>
      '$detailFood/${Uri.encodeComponent(name)}/$foodId';

  static String getRestaurantRoute(String name, String restaurantId) =>
      '$restaurantInfo/${Uri.encodeComponent(name)}/$restaurantId';

  static String getRestaurantDirectionRoute(String name, String restaurantId) =>
      '$restaurantDirection/${Uri.encodeComponent(name)}/$restaurantId';


  //chat and message
  static String getChatListRoute() => chatList;
  static String getChatPageRoute(String docId, String toUid, String toName) {
    return '$chatPage/${Uri.encodeComponent(docId)}/${Uri.encodeComponent(toUid)}/${Uri.encodeComponent(toName)}';
  }

/*
  static String getChatImageViewRoute (String imgUrl)=> '$chatImageView/${Uri.encodeComponent(imgUrl)}';
*/

  //settings
  static String getSettings ()=> settings;
  static String getResetPassword ()=> resetPassword;

  static List<GetPage> routes = [
    GetPage(
        name: initial,
        page: () => MainScreen(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: notFoundPage,
        page: () => const NotFoundPage(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: splash,
        page: () => const SplashScreen(),
        middlewares: [GlobalMiddleware()]),

    GetPage(
      name: orderSuccessWeb, page: () => SuccessfulWeb(),
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    GetPage(
      name: orderSuccess, page: () => Successful(),
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    GetPage(
      name: orderDetail, page: () => const OrderDetailsPage(),
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    GetPage(name: signIn, page: () => const Login()),
    GetPage(
      name: cartPage,
      page: () => const CartPage(),
    ),
    GetPage(
      name: clientOrders,
      page: () => const ClientOrderPage(),
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),

    //rating
    GetPage(
      name: reviewRating,
      page: () => const RatingReview(),
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),

    GetPage(
      name: rateOrder,
      page: () {
        final arguments = Get.arguments ?? {};
        final ClientOrders? order = arguments["order"];
        if (order == null) return const NotFoundPage();
        return ReviewPage(order: order);
      },
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    //add address
    GetPage(
      name: addresses,
      page: () => const Addresses(),
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    GetPage(
      name: addAddress,
      page: () => const AddAddress(),
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    //food detail
    GetPage(
      name: '$detailFood/:name/:id', // Dynamic parameter ":id"
      page: () => const FoodPage(),
      transition: Transition.fade,
      middlewares: [
        TitleMiddleware(),
        FoodMiddleware(),
        GlobalMiddleware(),
      ],
      // Apply middleware here
    ),
    //restaurant direction
    GetPage(
        name: '$restaurantInfo/:name/:id', // Dynamic parameter ":id"
        page: () {
          return RestaurantPage();
        },
        transition: Transition.fade,
        middlewares: [StoreMiddleware(), GlobalMiddleware()]),
    //restaurant detail
    GetPage(
        name: '$restaurantDirection/:name/:id', // Dynamic parameter ":id"
        page: () {
          return DirectionsPage();
        },
        transition: Transition.fade,
        middlewares: [StoreMiddleware(), GlobalMiddleware()]),
    //checkout page detail
    GetPage(
      name: checkoutPage, // Dynamic parameter ":id"
      page: () {
        final arguments = Get.arguments ?? {};
        final Restaurants? items = arguments["cartItems"];
        if (items == null) return const NotFoundPage();
        return MultiProductCheckout(restaurant: items);
      },
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    //points gained
    GetPage(
      name: pointsGained,
      page: () {
        final arguments = Get.arguments ?? {};
        final int points = arguments["pointsGained"] ?? 0;
        // if(points==0) return const NotFoundPage();
        return PointsBonusAnimation(points: points);
      },
      transition: Transition.fade,
      middlewares: [AuthMiddleware()], // Protect cartPage
    ),
    GetPage(
      name: userPoints,
      page: () {
        return const UserPoints();
      },
      transition: Transition.fade,
      middlewares: [AuthMiddleware(), GlobalMiddleware()], // Protect cartPage
    ),
    //all items
    GetPage(
        name: allCategories,
        page: () => const AllCategories(),
        transition: Transition.fade,
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: allNearbyRestaurants,
        page: () => const AllNearbyRestaurants(),
        transition: Transition.fade,
        middlewares: [GlobalMiddleware()]),

    GetPage(
        name: recommendations,
        page: () => const Recommendations(),
        transition: Transition.fade,
        middlewares: [GlobalMiddleware()]),

    GetPage(
        name: fastestFoods,
        page: () => const FastestFoods(),
        transition: Transition.fade,
        middlewares: [GlobalMiddleware()]),

    GetPage(
        name: '$category/:name/:catId', // Dynamic parameter ":id"
        page: () {
          return const CategoriesPage();
        },
        transition: Transition.fade,
        middlewares: [GlobalMiddleware()]),
    //app version and setting
    GetPage(
      name: appVersion,
      page: () =>  AppVersionInfo(),
      transition: Transition.fade,
    ),

    //chat and message
    GetPage(
      name: chatList,
      page: () => const MessagePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '$chatPage/:doc_id/:to_uid/:to_name',
      page: () => const ChatPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
        name: '$chatImageView/:imgUrl',
        page: () => PhotoImageView(),
        middlewares: [AuthMiddleware()]
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: resetPassword,
      page: () => const ResetPassword(),
      middlewares: [AuthMiddleware()],
    ),

    //
  ];
}
