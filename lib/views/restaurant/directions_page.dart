import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/divida.dart';

import 'package:foodly_user/common/positioned_back_button.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/values/common_error_screen.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/services/distance.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionsPage extends StatefulHookWidget {
  const DirectionsPage({super.key,  this.restaurant});

  final Restaurants? restaurant;

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Placemark? place;
  late GoogleMapController? mapController;
  LatLng _center = const LatLng(45.521563, -122.677433);
  bool isMapControllerInitialized = false;

  Map<MarkerId, Marker> markers = {};
  Restaurants?  restaurantObj;
  bool isLoadingMap = true;
  bool isLoading = true;
  double distance=0.0;
  DistanceTime? distanceTime;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _initializeRestaurant();

  }

  _calulateDistanceAndTime(Restaurants restaurantObj) async {
    final box = GetStorage();
    String? token = box.read('token');

    if(token!=null){
      final lat = box.read("userLat");
      final lng = box.read("userLng");
      distanceTime = Distance().calculateDistanceTimePrice(
          lat,
          lng,
          restaurantObj.coords.latitude,
          restaurantObj.coords.longitude,
          10, //speed per hour
          Get.find<AppSetupController>().deliveryFee); //price per kilo
    }else{

      distanceTime = Distance().calculateDistanceTimePrice(
          _center.latitude,
          _center.longitude,
          restaurantObj.coords.latitude,
          restaurantObj.coords.longitude,
          10,
          Get.find<AppSetupController>().deliveryFee);
    }
  }

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    mapController = controller;

    if (kDebugMode) {
      print("MapController initialized successfully.");
    }
    isMapControllerInitialized = true;
    _getCurrentLocation();
  }
  // Helper function to wait for the mapController to be initialized
  Future<void> _waitForMapController() async {
    // Retry loop to wait for the controller to be initialized
    while (mapController == null||!isMapControllerInitialized) {
      await Future.delayed(const Duration(milliseconds: 500));  // Delay before retrying
    }
    print("mapController initialized successfully.");
  }

  Future<void> _getCurrentLocation() async {
    try {

      // Fetch the current location
      var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      // Wait for the mapController to be initialized
      await _waitForMapController();
      String? token = box.read("token");
      if(token!=null){
        double? lat = box.read("userLat");
        double? lng = box.read("userLng");
        if(lat!=null && lng!=null){
          _center = LatLng(lat, lng);
          if (kDebugMode) {
            print("Got lat lng from the box storage");
          }
        }else{
          _center = LatLng(currentLocation.latitude, currentLocation.longitude);
        }
      }else{
        // Now we can safely access mapController
        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      }

      // Debug log to ensure coordinates are valid
      if (kDebugMode) {
        print('Current Location: Latitude = ${currentLocation.latitude}, Longitude = ${currentLocation.longitude}');
      }
      // Add markers for current location and restaurant location
      _addMarker(_center, "user");
      _addMarker(
        LatLng(  restaurantObj!.coords.latitude,   restaurantObj!.coords.longitude),
        "restaurant",
      );

      // Focus on the map to show both markers
      _focusMapOnMarkers(_center, LatLng(  restaurantObj!.coords.latitude,   restaurantObj!.coords.longitude));
      // Fetch polyline data
      _getPolyline();
      //_getPolylineTest();
      setState(() {
        isLoadingMap = false; // Stop loading when complete
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  void _addMarker(LatLng position, String id) async {
    // Perform the asynchronous operation outside of setState
    final markerId = MarkerId(id);

    // Create the custom marker icon asynchronously
    BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      id=="restaurant"?'assets/images/restaurant_location.png':'assets/images/user_location.png', // Optional: specify custom marker image, or remove this line for default marker
    );
    // Now update the state with the new marker
    setState(() {
      final marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: InfoWindow(title: id), // InfoWindow with the title
        icon: customIcon,  // Set the custom icon for the marker
      );
      markers[markerId] = marker;  // Add the marker to the markers map
    });

    if (kDebugMode) {
      print('Added marker at: $position');
    } // Debugging line
  }


  void _focusMapOnMarkers(LatLng position1, LatLng position2) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(position1.latitude, position2.latitude),
        min(position1.longitude, position2.longitude),
      ),
      northeast: LatLng(
        max(position1.latitude, position2.latitude),
        max(position1.longitude, position2.longitude),
      ),
    );
    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }


  _getPolylineTest() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey:"AIzaSyD2663o-Nefzh5loUvP1UJi2rKClNZtJdI",
        request: PolylineRequest(
          origin:PointLatLng(_center.latitude, _center.longitude),
          destination:PointLatLng(restaurantObj!.coords.latitude,
              restaurantObj!.coords.longitude),
          mode: TravelMode.driving,
          optimizeWaypoints: true,
        )
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      if (kDebugMode) {
        print(result.errorMessage);
      }
    }
    _addPolyLine();
  }

  Future<void> _getPolyline() async {

    try {

      //distance = getDistanceInKm(originLat, originLng, destLat, destLng);
      distanceTime = Distance().calculateDistanceTimePrice(
          _center.latitude,
          _center.longitude,
          restaurantObj!.coords.latitude,
          restaurantObj!.coords.longitude,
          10,
          Get.find<AppSetupController>().deliveryFee);

      const double thresholdDistance = 100; // km

      if (distance > thresholdDistance) {
        ShowDialogue().showDialog(title: "Distance",middleText: "Distance too large, unable to calculate a route.");
        return;
      }else{
        print("The current distance is ${distance}");
      }

      final response = await _fetchPolylineData();

      if (response != null && response['routes'] != null && response['routes'].isNotEmpty) {
        final points = response['routes'][0]['legs'][0]['steps'];

        for (var point in points) {
          polylineCoordinates.add(LatLng(point['end_location']['lat'], point['end_location']['lng']));
        }
        _addPolyLine();
      } else {
        print("Error: No route data found or routes are empty");
      }
    } catch (error) {
      print("Error fetching polyline data: $error");
    }
  }

  Future<Map<String, dynamic>?> _fetchPolylineData() async {
    try {
      print("Received coordinates:");
      print("Origin: ${_center.latitude}, ${_center.longitude}");
      print("Destination: ${  restaurantObj!.coords.latitude}, ${  restaurantObj!.coords.longitude}");
      final response = await http.get(Uri.parse(
          'https://ffoodly.dbestech.com/api/address/proxy/get-polyline?originLat=${_center.latitude}&originLng=${_center.longitude}&destLat=${  restaurantObj!.coords.latitude}&destLng=${  restaurantObj!.coords.longitude}'));


      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        //print("Parsed Response: $data");  // Log the parsed response for inspection
        return data;
      } else {
        print('Failed to fetch polyline data, Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching polyline data: $e');
      return null;
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Fetch the current location
    var currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    // Wait for the mapController to be initialized
    // await _waitForMapController();
    // Now we can safely access mapController
    _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
   // _getCurrentLocation();
  }

  double getDistanceInKm(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371; // Radius of the Earth in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLng = (lng2 - lng1) * pi / 180;
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Returns the distance in kilometers
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: kPrimary, points: polylineCoordinates, width: 6);
    polylines[id] = polyline;

    setState(() {});
  }

  Future<void> _initializeRestaurant() async {
    try {
      final passedRestaurant = Get.arguments?["restaurant"] as Restaurants?;
      if (passedRestaurant != null) {
        setState(() {
          restaurantObj = passedRestaurant;
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
    } else if (restaurantObj != null) {
      print("getting passed object");
      _calulateDistanceAndTime(restaurantObj!);
      return _buildContent(restaurantObj!);
    } else if (hookResult != null && hookResult.isLoading) {
      print("getting loading object");
      return const CommonLoadingScreen();
    } else if (hookResult != null && hookResult.data != null) {
      print("getting object from query");
      restaurantObj = hookResult.data!;
      _calulateDistanceAndTime(restaurantObj!);
      return _buildContent(hookResult.data!);
    } else {
      return const CommonErrorScreen();
    }
  }



  Widget _buildContent(Restaurants restaurantObj) {

    LatLng restaurant = LatLng(
          restaurantObj.coords.latitude,   restaurantObj.coords.longitude);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: restaurant,
                zoom: 18.0,
              ),
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: width,
                height: 280.h,
                decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r))),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                  decoration: BoxDecoration(
                      color: kLightWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text:   restaurantObj!.title!,
                              style: appStyle(20, kGray, FontWeight.bold)),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: kTertiary,
                            backgroundImage:
                                NetworkImage(  restaurantObj!.imageUrl!),
                          ),
                        ],
                      ),
                      const Divida(),
                      RowText(
                          first: "Distance To Restaurant",
                          second:
                              "${distanceTime!.distance.toStringAsFixed(3)} km"),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: "Price From Current Location",
                          second: "\$ ${distanceTime!.price.toStringAsFixed(3)}"),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: "Estimated Delivery Time",
                          second: "${(distanceTime!.time+25).toStringAsFixed(2)} mins"),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: "Business Hours",
                          second:   restaurantObj.time),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divida(),
                      RowText(
                          first: "Address",
                          second:   restaurantObj.coords.address),
                      SizedBox(
                        height: 10.h,
                      ),
                      const CustomButton(
                        color: kPrimary,
                        btnHieght: 35,
                        radius: 6,
                        text: "Make a reservation",
                      )
                    ],
                  ),
                ),
              ),
            ),
            const PositionedBackButton(),
            if (isLoading) const CommonLoadingScreen(),
            // Show loading overlay
          ],
        ),
      ),
    );
  }
}
