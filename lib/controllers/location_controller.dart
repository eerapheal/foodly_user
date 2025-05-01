// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/hooks/fetchPromotionFood.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
class UserLocationController extends GetxController {
  RxInt _reloadItems = 1.obs;
  int get reloadItems => _reloadItems.value;
  set reloadItems(int val)=> _reloadItems.value=val;
  Rx<UserLocation> userLocation = Rx<UserLocation>(UserLocation());
  final box = GetStorage();
  RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
  }

  RxBool _defaultAddress = true.obs;
  bool get defaultAddress => _defaultAddress.value;
  set defaultAddress(bool newDefaultAddress) {
    _defaultAddress.value = newDefaultAddress;
  }

  var _restaurantLocation = const LatLng(0, 0).obs;

  LatLng get restaurantLocation => _restaurantLocation.value;


  var _currentLocation = const LatLng(0, 0).obs;

  LatLng get currentLocation => _currentLocation.value;

  void setUserLocation(LatLng newLocation) {
    _currentLocation.value = newLocation;
    update();
  }

  UserLocation get location => userLocation.value;

  void setLocation(LatLng newLocation) {
    userLocation.value.currentLocation.value = newLocation;
    update();  // Update the UI or data in the controller
  }

  void setUserAddress(String newAddress, String newDistrict, String newCity, String newPostalCode, String newCountry, double userNewLat, double userNewLng) {
    userLocation.value.address.value = newAddress;
    userLocation.value.district.value = newDistrict;
    userLocation.value.city.value = newCity;
    userLocation.value.postalCode.value = newPostalCode;
    userLocation.value.country.value = newCountry;
    userLocation.value.lat.value = userNewLat;
    userLocation.value.lng.value = userNewLng;
    box.write('userAddress', newAddress);
    box.write('userCity', newCity);
    box.write('userDistrict', newDistrict);
    box.write('userPostalCode', newPostalCode);
    box.write('userCountry', newCountry);
    box.write('userLat', userNewLat);
    box.write('userLng', userNewLng);
    Get.find<ReloadController>().clearCache();
    //this means user has allowed the locaiton
    _reloadItems.value=1;
    update(); // Update the UI or data in the controller
  }

  void getAddressFromLatLng(LatLng latLng) async {

    String? token = box.read("token");
    String? country = box.read("userCountry");
    if(token!=null){
      if(userLocation.value.country.value.isNotEmpty){
        userLocation.value.address.value = box.read("userAddress");
        userLocation.value.country.value = box.read("userCountry");
        return;
      }else if(country!=null){
        userLocation.value.address.value = box.read("userAddress");
        userLocation.value.country.value = box.read("userCountry");
        return;
      }else{
        if (kDebugMode) {
          print("Found in the storage ${box.read("userAddress")}");
        }
        //ShowDialogue().showDialog(title: "Logged in user location problem",middleText: "Your current location may not be correct");
      }

    }else{
      //user did not login
      if(country!=null){
        userLocation.value.address.value = box.read("userAddress");
        userLocation.value.country.value = box.read("userCountry");
        //ShowDialogue().showDialog(title: "Location problem",middleText: "Your current location may not be correct");
        if (kDebugMode) {
          print("User not logged in and found address in the storage ${box.read("userAddress")}");
        }
        return;
      }else{
        if (kDebugMode) {
          print("User not logged in and found address in the storage is ${box.read("userAddress")}");
        }
      }
    }

    final url = Uri.parse(
        '${Environment.appBaseUrl}/api/address/proxy/reverse-geocode?lat=${latLng.latitude}&lng=${latLng.longitude}');
    try {

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody != null && responseBody['address'] != null) {
          final address = responseBody['address'];
          final city = responseBody['city'] ?? 'Unknown city';
          final district = responseBody['district'] ?? 'Unknown district';
          final postalCode = responseBody['postalCode'] ?? 'Unknown postal code';
          final country = responseBody['country'] ?? 'Unknown country';
          // Assuming coordinates are returned in the response
          setUserAddress(address, district, city, postalCode, country, latLng.latitude, latLng.longitude);

        } else {
          print('No address results found.');
        }
      } else {
        print('Failed to fetch address details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching address details: $e');
    }
  }
}
class UserLocation {
  Rx<LatLng> currentLocation;
  Rx<String> address;
  Rx<String> postalCode;
  Rx<String> district;
  Rx<String> city;
  Rx<String> country;
  Rx<double> lat;
  Rx<double> lng;

  UserLocation({
    LatLng? initialLocation,
    String? initialAddress,
    String? initialPostalCode,
    String? initialDistrict,
    String? initialCity,
    String? initialCountry,
    double? initialLat,
    double? initialLng
  })  : currentLocation = Rx(initialLocation ?? LatLng(0, 0)),
        address = Rx(initialAddress ?? ''),
        postalCode = Rx(initialPostalCode ?? ''),
        district = Rx(initialDistrict ?? ''),
        city = Rx(initialCity ?? ''),
        country = Rx(initialCountry ?? ''),
        lat = Rx(initialLat??0.0),
        lng = Rx(initialLng??0.0);

// You can add more helper methods here for other logic if needed
}

/*
class UserLocationController extends GetxController {
  RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
  }

  RxBool _defaultAddress = true.obs;
  bool get defaultAddress => _defaultAddress.value;
  set defaultAddress(bool newDefaultAddress) {
    _defaultAddress.value = newDefaultAddress;
  }

  var _restaurantLocation = const LatLng(0, 0).obs;

  LatLng get restaurantLocation => _restaurantLocation.value;

  void setLocation(LatLng newLocation) {
    _restaurantLocation.value = newLocation;
    update();
  }

  var _currentLocation = const LatLng(0, 0).obs;

  LatLng get currentLocation => _currentLocation.value;

  void setUserLocation(LatLng newLocation) {
    _currentLocation.value = newLocation;
    update();
  }

  var _userAddress = const Placemark(
    name: "Central Park",
    street: "59th St to 110th St",
    isoCountryCode: "US",
    country: "United States",
    postalCode: "10022",
    administrativeArea: "New York",
    subAdministrativeArea: "New York County",
    locality: "New York",
    subLocality: "Manhattan",
    thoroughfare: "Central Park West",
    subThoroughfare: "1",
  ).obs;

  Placemark get userAddress => _userAddress.value;

  void setUserAddress(Placemark newAddress) {
    _userAddress.value = newAddress;
    update();
  }

  var _address = ''.obs;
  String get address => _address.value;
  set address(String newAddress) {
    _address.value = newAddress;
    update();
  }

  var _postalCode = ''.obs;
  String get postalCode => _postalCode.value;
  set postalCode(String newPostalCode) {
    _postalCode.value = newPostalCode;
    update();
  }

  var _district = ''.obs;
  String get district => _district.value;
  set district(String newDistrict) {
    _district.value = newDistrict;
    update();
  }

  var _city = ''.obs;
  String get city => _city.value;
  set city(String newCity) {
    _city.value = newCity;
    update();
  }

   var _country = ''.obs;
  String get country => _country.value;
  set country(String newCountry) {
    _country.value = newCountry;
    update();
  }

  void getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
        'https://ffoodly.dbestech.com/api/address/proxy/reverse-geocode?lat=${latLng.latitude}&lng=${latLng.longitude}'); // Node.js API endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Ensure that we have valid address data from the server
        if (responseBody != null && responseBody['address'] != null) {
          final address = responseBody['address'];
          final city = responseBody['city'] ?? 'Unknown city';
          final district = responseBody['district'] ?? 'Unknown district';
          final postalCode = responseBody['postalCode'] ?? 'Unknown postal code';
          final country = responseBody['country'] ?? 'Unknown country';

          // Reset address components before processing new data
          this.address = address;
          this.district = district;
          this.city = city;
          this.postalCode = postalCode;

          _country.value = country; // Store the country value

          update(); // Update the UI or data in the controller
        } else {
          print('No address results found.');
          // Handle no results (you could set a default value, show a message, etc.)
        }
      } else {
        print('Failed to fetch address details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching address details: $e');
    }
  }


}*/
