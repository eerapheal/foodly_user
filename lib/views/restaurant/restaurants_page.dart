// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/divida.dart';
import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/common/values/common_error_screen.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/models/distance_time.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/services/distance.dart';
import 'package:foodly_user/views/auth/login_page.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/restaurant/directions_page.dart';
import 'package:foodly_user/views/restaurant/rating_page.dart';
import 'package:foodly_user/views/restaurant/widgets/explore.dart';
import 'package:foodly_user/views/restaurant/widgets/menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glass/glass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantPage extends StatefulHookWidget {

  RestaurantPage({Key? key, }):

        super(key: key);


  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with TickerProviderStateMixin {

  late TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  final box =  GetStorage();
  final AddressController? controller = Get.find<AddressController>();
  final UserLocationController? location = Get.find<UserLocationController>();
  String accessToken = "";
  late DistanceTime distanceTime;
  bool isLoading = true;
  Restaurants? restaurant;
  LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();

    _initializeRestaurant();
  }

  Future<void> _initializeRestaurant() async {
    try {
      var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      // Wait for the mapController to be initialized
      // await _waitForMapController();
      // Now we can safely access mapController
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      final passedRestaurant = Get.arguments?["restaurant"] as Restaurants?;
      if (passedRestaurant != null) {
        setState(() {
          restaurant = passedRestaurant;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Defer to hook for fetching by ID
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing restaurant: $e");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantId = Get.parameters['id'];
    final hookResult = restaurantId != null ? useFetchRestaurant(restaurantId) : null;

    if (isLoading) {
      return const CommonLoadingScreen();
    } else if (restaurant != null) {
      return _buildContent(restaurant!);
    } else if (hookResult != null && hookResult.isLoading) {
      return const CommonLoadingScreen();
    } else if (hookResult != null && hookResult.data != null) {
      return _buildContent(hookResult.data!);
    } else {
      return const CommonErrorScreen();
    }
  }


  Widget _buildContent(Restaurants restaurant) {

    String? token = box.read('token');

    if (token != null) {
       if(controller==null||location==null){
         return const NotFoundPage(crash: true,);
       }
        //this is for logged in user
       accessToken = jsonDecode(token);
       double? lat = box.read("userLat");
       double? lng = box.read("userLng");
       print("lat $lat");
       print("lng $lng");
       distanceTime = Distance().calculateDistanceTimePrice(
          lat!,
           lng!,
          restaurant.coords.latitude,
           restaurant.coords.longitude,
          10,
           Get.find<AppSetupController>().deliveryFee);

    }else{

      distanceTime = Distance().calculateDistanceTimePrice(
          _center.latitude,
          _center.longitude,
          restaurant.coords.latitude,
          restaurant.coords.longitude,
          10,
          Get.find<AppSetupController>().deliveryFee);

    }

    // String numberString = widget.restaurant.time.substring(0, 2);
    double totalTime = 25 + distanceTime.time;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: kLightWhite,
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: padding),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 230.h,
                      width: width,
                      child: Image.network(
                        fit: BoxFit.cover,
                          restaurant.imageUrl!
                      ) /*CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: restaurant.imageUrl!)*/,
                    ),

                    Positioned(
                      top: kIsWeb ? 10.h : 40.h,
                      left: 0,
                      right: 8,
                      child: RestaurantTopBar(
                        title: restaurant.title!,
                        restaurant: restaurant,
                      ),
                    ),
                  ],
                ),
                //text for restaurant
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  height: 85.h,
                  child: ListView(
                    padding: EdgeInsets.zero,
                   // physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      RowText(
                          first: "Distance To Restaurant",
                          second:
                              "${distanceTime.distance.toStringAsFixed(3)} km"),
                      SizedBox(
                        height: 10.h,
                      ),
                      RowText(
                          first: "Delivery Price From Current Location",
                          second: "\$ ${distanceTime.price.toStringAsFixed(3)}"),
                      SizedBox(
                        height: 10.h,
                      ),
                      RowText(
                          first: "Estimated Delivery Time to Current Location",
                          second: "${totalTime.toStringAsFixed(0)} mins")
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Divida(),
                ),

                 //restaurant tab bar
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SizedBox(
                    height: 25.h,
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                      unselectedLabelColor: Colors.grey.withOpacity(0.7),
                      tabs:  <Widget>[
                        Tab(
                          child: SizedBox(
                            width:MediaQuery.of(context).size.width/2,
                            //margin: EdgeInsets.only(left: 20, right: 20),
                            height: 25,
                            child: const Center(child: Text("Menu")),
                          ),
                        ),
                         Tab(
                          child: SizedBox(
                            width:MediaQuery.of(context).size.width/2,
                            height: 25,

                            child: const Center(child: Text("Explore")),
                          ),
                        )
                      ],
                    ),
                  ).asGlass(
                      tintColor: kPrimary,
                      clipBorderRadius: BorderRadius.circular(19.0),
                      blurX: 8,
                      blurY: 8),
                ),
                SizedBox(

                    height: hieght / 1.3,
                    child:  TabBarView(controller: _tabController, children: [
                        SingleChildScrollView(
                          child: RestaurantMenu(
                            restaurantId: restaurant!.id!,
                          ),
                        ),
                      
                        const SingleChildScrollView(child: Explore())
                      ]),
                    )
              ],
            ),
          )),
    );
  }
}

class RestaurantRatingBar extends StatelessWidget {
  const RestaurantRatingBar({
    super.key,
    required this.restaurant,
  });

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read("token");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35.h,
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBarIndicator(
              rating: restaurant.rating.toDouble(),
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              itemCount: 5,
              itemSize: 25.0,
              direction: Axis.horizontal,
            ),
            CustomButton(
              onTap: () {
                if (token == null) {
                  Get.to(() => const Login(),
                      transition: Transition.fadeIn,
                      duration: const Duration(seconds: 2));
                } else {
                  Get.to(() => RatingPage(
                        restaurant: restaurant,
                      ));
                }
              },
              text: "Rate Restaurant",
              btnWidth: width / 3,
            )
          ],
        ),
      ),
    );
  }
}

class RestaurantTopBar extends StatelessWidget {
  const RestaurantTopBar({
    super.key,
    required this.title,
    required this.restaurant,
  });

  final String title;
  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CommonBackButton(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(10)
          ),
          child: ReusableText(
              text: title, style: appStyle(14, kOffWhite, FontWeight.w500)),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(RouteNames.getRestaurantDirectionRoute(restaurant.title!, restaurant.id!),
            arguments: {
              "restaurant":restaurant,
              "id":restaurant.id!,
              "name":restaurant.title!
            });
          },
          icon: const Icon(
            Entypo.direction,
            color: kLightWhite,
            size: 38,
          ),
        )
      ],
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.first,
    required this.second,
  });

  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(text: first, style: appStyle(kFontSizeSmall, kGray, FontWeight.w500)),
        Flexible(
            child: Text(second,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: appStyle(kFontSizeSmall, kGray, FontWeight.w400)))
      ],
    );
  }
}
