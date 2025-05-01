import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/address_modal.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/custom_textfield.dart';
import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/discount_calculator.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/common/values/common_error_screen.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/cart_controller.dart';
import 'package:foodly_user/controllers/contact_controller.dart';
import 'package:foodly_user/controllers/counter_controller.dart';
import 'package:foodly_user/controllers/food_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/hooks/fetchSingleFood.dart';
import 'package:foodly_user/models/cart_request.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/models/response_model.dart';
import 'package:foodly_user/views/auth/login_page.dart';
import 'package:foodly_user/views/auth/phone_verification.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/tab_controller.dart';
import '../../models/restaurants.dart';
import '../../services/distance.dart';
import '../entrypoint.dart';


class FoodPage extends StatefulHookWidget {
  const FoodPage({
    super.key,
    this.foods,
    // required this.food,
  });

  final Food? foods;

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _preferences = TextEditingController();

  final CounterController counterController = Get.find<CounterController>();
  final PageController _pageController = PageController();
  final ContactController _controller = Get.find<ContactController>();
  bool restauarantDistance = true;
  Food? food;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _initializeFood();
  }

  Future<void> _initializeFood() async {
    try {
      final passedFood = Get.arguments?["food"] as Food?;
      // Set the title dynamically
      if (passedFood != null) {
        setState(() {
         /* //  START_DISABLE
          if(kIsWeb){

            html.document.title = '${passedFood.title} - Foodly';
             print("${html.document.title}");
                setDynamicMeta(
                   html.document.title,
                   passedFood.description
               );

           }
        //  END_DISABLE*/
          food = passedFood;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Defer to hook for fetching by ID
        });
      }
    } catch (e) {
      print("Error initializing food: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodId = Get.parameters['id'];
    final hookResult = foodId != null ? useFetchSingleFood(foodId) : null;

    if (isLoading) {
      return const CommonLoadingScreen();
    } else if (food != null) {
      return _buildContent(food!);
    } else if (hookResult != null && hookResult.isLoading) {
      return const CommonLoadingScreen();
    } else if (hookResult != null && hookResult.data != null) {
      return _buildContent(hookResult.data!);
    } else {
      return const CommonErrorScreen();
    }
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildContent(Food food) {
    final box = GetStorage();
    var phone_verification = box.read('phone_verification');
    var address = box.read('default_address') ?? false;
    final foodController = Get.put(FoodController());
    final cartController = Get.put(CartController());
    foodController.loadAdditives(food.additives);
    final hookResult = useFetchRestaurant(food.restaurant);
    var restaurantData; //= hookResult.data;
    final load = hookResult.isLoading;
    String? token = box.read('token');

    if (load == false) {
      restaurantData = hookResult.data;

      if (restaurantData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(restaurantData);

        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the restaurant ID to the controller state
        _controller.state.restaurantId.value = resData["_id"];

        // Load chat data
        loadChatData();
        if (token != null) {
          restauarantDistance = checkDistance(restaurantData);
        }

      } else {
        if (kDebugMode) {
          print("restaurantData is null");
        }
      }
    }

    return load == true
        ? const CommonLoadingScreen()
        : Scaffold(
            backgroundColor: kLightWhite,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(25)),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 230.h,
                                      child: PageView.builder(
                                          itemCount: food.imageUrl.length,
                                          controller: _pageController,
                                          onPageChanged: (i) {
                                            foodController.currentPage(i);
                                          },
                                          itemBuilder: (context, i) {
                                            return Container(
                                              height: 230.h,
                                              width: width,
                                              color: kLightWhite,
                                              child:Image.network(
                                                  fit: BoxFit.cover,
                                                  food.imageUrl[i]
                                              ) /*CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: food.imageUrl[i],
                                              )*/,
                                            );
                                          }),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      child: Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            food.imageUrl.length,
                                            (index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  margin: EdgeInsets.all(4.h),
                                                  width: foodController
                                                              .currentPage ==
                                                          index
                                                      ? 10
                                                      : 8,
                                                  // ignore: unrelated_type_equality_checks
                                                  height: foodController
                                                              .currentPage ==
                                                          index
                                                      ? 10
                                                      : 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: foodController
                                                                .currentPage ==
                                                            index
                                                        ? kSecondary
                                                        : kGrayLight,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //back buttons
                              Positioned(
                                top: kIsWeb ? 10.h : 40.h,
                                left: 0,
                                right: 8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonBackButton(
                                      onPressed: (){
                                        Get.find<OrderController>()
                                            .clearOrderItems();
                                        counterController.clearCounter();
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const CommonBackButton(
                                        icon: Entypo.share,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //show promotion
                              (food.promotion == true &&
                                      food.promotionPrice! > 0)
                                  ? Positioned(
                                      bottom: 10,
                                      left: screenButtonWidth(10),
                                      child: Container(
                                          height: screenButtonHeight(45),
                                          width: screenButtonWidth(100),
                                          decoration: BoxDecoration(
                                              color: kPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(appBorderRadius)),
                                          child: Center(
                                              child: ReusableText(
                                            text: DiscountCalculator
                                                .calculateDiscountPercentage(
                                                    food!.price,
                                                    food!.promotionPrice!),
                                            // Call the method from the class
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: kWhite,
                                                fontSize: screenFontSize(
                                                    kFontSizeLarge)),
                                          ))))
                                  : const SizedBox.shrink(),
                              kIsWeb
                                  ? Positioned(
                                      bottom: 10,
                                      child: SizedBox(
                                        width: screenButtonWidth(18),
                                      ))
                                  : const SizedBox.shrink(),
                              //chat button
                              Positioned(
                                  bottom: 10,
                                  right: screenButtonWidth(15),
                                  child: CustomButton(
                                      btnWidth: screenButtonWidth(65),
                                      btnHieght: screenButtonHeight(45),
                                      radius: appBorderRadius,
                                      color: kPrimary,
                                      onTap: () async {
                                        if (restaurantData == null) {
                                          Get.to(
                                              () => const NotFoundPage(
                                                    text:
                                                        "Can not open restaurant page",
                                                  ),
                                              transition: Transition.fade,
                                              duration:
                                                  const Duration(seconds: 1),
                                              arguments: {});
                                        } else {

                                          ResponseModel status =
                                              await _controller
                                                  .goChat(restaurantData);

                                          if (status.isSuccess == false) {
                                            showCustomSnackBar(status.message!,
                                                title: status.title!);
                                          }
                                        }
                                      },
                                      text: "Chat")),
                              kIsWeb
                                  ? Positioned(
                                      bottom: 10,
                                      child: SizedBox(
                                        width: screenButtonWidth(18),
                                      ))
                                  : const SizedBox.shrink(),

                              //restaurant button
                              Positioned(
                                  bottom: 10,
                                  right: screenButtonWidth(100),
                                  child: CustomButton(
                                      btnWidth: screenButtonWidth(144),
                                      btnHieght: screenButtonHeight(45),
                                      radius: appBorderRadius,
                                      color: kSecondary,
                                      onTap: () {
                                        if (token == null) {
                                          showCustomSnackBar(
                                            "You are not logged in. Your distance measure is not correct",
                                            title: "Distance alert",
                                          );
                                        }
                                        if (restaurantData == null) {
                                          Get.to(
                                              () => const NotFoundPage(
                                                    text:
                                                        "Can not open restaurant page",
                                                  ),
                                              transition: Transition.fade,
                                              duration:
                                                  const Duration(seconds: 1));
                                        } else {
                                          Get.toNamed(
                                            RouteNames.getRestaurantRoute(
                                                restaurantData.title!,
                                                restaurantData.id!),
                                            arguments: {
                                              "restaurant":restaurantData
                                            },
                                          );
                                        }
                                      },
                                      text: "Go to store")),
                            ],
                          ),

                          //food Price and title and description
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row for Title and Price
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ReusableText(
                                        text: food!.title,
                                        style: appStyle(
                                            18, kDark, FontWeight.w600),
                                      ),
                                      Obx(() => ReusableText(
                                            text:
                                                "\$ ${((food!.price + foodController.additiveTotal - food!.promotionPrice!.toDouble()) * counterController.count.toDouble()).toStringAsFixed(2)}",
                                            style: appStyle(
                                                18, kPrimary, FontWeight.w600),
                                          )),
                                    ],
                                  ),

                                  SizedBox(height: 5.h),

                                  // Promotion Row
                                  // Promotion Badge
                                  if (food!.promotion == true)
                                    Column(
                                      children: [
                                        //future widget
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Container(
                                            width: screenButtonWidth(100),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Text(
                                              "Now ${DiscountCalculator.calculateDiscountPercentage(food!.price, food!.promotionPrice!)}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenFontSize(
                                                    kFontSizeSmall),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  SizedBox(height: 10.h),

                                  SizedBox(height: 10.h),

                                  // Food Description
                                  Text(
                                    food!.description,
                                    maxLines: 8,
                                    style: appStyle(kDefaultFontSize, kGray,
                                        FontWeight.w400),
                                  ),

                                  SizedBox(height: 10.h),

                                  // Food Tags
                                  SizedBox(
                                    height: 15.h,
                                    child: ListView.builder(
                                      itemCount: food!.foodTags.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, i) {
                                        final tag = food!.foodTags[i];
                                        return Container(
                                          margin: EdgeInsets.only(right: 5.h),
                                          decoration: BoxDecoration(
                                            color: kPrimary,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.r)),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: ReusableText(
                                                text: tag,
                                                style: appStyle(8, kLightWhite,
                                                    FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 15.h),

                                  // Additives Section
                                  ReusableText(
                                    text: "Additives and Toppings",
                                    style: appStyle(18, kDark, FontWeight.w600),
                                  ),

                                  Column(
                                    children: List.generate(
                                      foodController.additivesList.length,
                                      (i) {
                                        final additive =
                                            foodController.additivesList[i];
                                        return Obx(() => CheckboxListTile(
                                              title: RowText(
                                                first: additive.title,
                                                second: "\$ ${additive.price}",
                                              ),
                                              contentPadding: EdgeInsets.zero,
                                              value: additive.isChecked.value,
                                              dense: true,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onChanged: (bool? newValue) {
                                                additive.toggleChecked();
                                                foodController.getTotalPrice();
                                                foodController.getList();
                                              },
                                              activeColor: kPrimary,
                                              checkColor: Colors.white,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              tristate: false,
                                            ));
                                      },
                                    ),
                                  ),

                                  SizedBox(height: 5.h),
                                  // Quantity Section
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ReusableText(
                                        text: "Quantity",
                                        style: appStyle(
                                            18, kDark, FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: counterController.increment,
                                            child: CircleAvatar(
                                              backgroundColor: kSecondary,
                                              radius: screenButtonWidth(15),
                                              child: const Icon(
                                                Entypo.plus,
                                                color: kLightWhite,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Obx(() => Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: ReusableText(
                                                  text:
                                                      "${counterController.count}",
                                                  style: appStyle(16, kDark,
                                                      FontWeight.w500),
                                                ),
                                              )),
                                          SizedBox(width: 6.w),
                                          GestureDetector(
                                            onTap: counterController.decrement,
                                            child: CircleAvatar(
                                              backgroundColor: kSecondary,
                                              radius: screenButtonWidth(15),
                                              child: const Icon(
                                                Entypo.minus,
                                                color: kLightWhite,
                                              ),
                                            ) /*const Icon(
                                                AntDesign.minussquareo,
                                                color: kPrimary)*/,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  // Preferences Section
                                  ReusableText(
                                    text: "Preferences",
                                    style: appStyle(18, kDark, FontWeight.w600),
                                  ),
                                  //preferences
                                  SizedBox(
                                    height: 64.h,
                                    child: CustomTextField(
                                      controller: _preferences,
                                      hintText: "Add a note",
                                      maxLines: 3,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter a note";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Obx(() {
                      if (cartController.placeOrder.value == false) {
                        return Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40.h,
                                width: width,
                                decoration: BoxDecoration(
                                  color: kPrimary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (token == null) {
                                          Get.to(() => const Login(),
                                              transition: Transition.fade,
                                              duration:
                                                  const Duration(seconds: 1));
                                        } else if (!restauarantDistance) {
                                          showCustomSnackBar(
                                              "It's more than 100km from your place",
                                              isError: false,
                                              title: "Distance alert");
                                        } else {
                                          double totalPrice = 0.0;

                                          if (food!.promotion!) {
                                            totalPrice = (DiscountCalculator
                                                        .calculateDiscountedPrice(
                                                            food!.price,
                                                            food!
                                                                .promotionPrice!) +
                                                    foodController
                                                        .additiveTotal) *
                                                counterController.count
                                                    .toDouble();
                                          } else {
                                            totalPrice = (food!.price +
                                                    foodController
                                                        .additiveTotal) *
                                                counterController.count
                                                    .toDouble();
                                          }

                                          ToCart item = ToCart(
                                              productId: food!.id,
                                              instructions: _preferences.text,
                                              additives:
                                                  foodController.getList(),
                                              quantity: counterController.count
                                                  .toInt(),
                                              totalPrice: totalPrice,
                                              promotion: food.promotion,
                                              promotionPrice:
                                                  food.promotionPrice);
                                          String cart = toCartToJson(item);
                                          cartController.addToCart(cart);
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: kSecondary,
                                        radius: screenButtonWidth(20),
                                        child: const Icon(
                                          Entypo.plus,
                                          color: kLightWhite,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (token == null) {
                                          Get.to(() => const Login(),
                                              transition: Transition.fade,
                                              duration:
                                                  const Duration(seconds: 1));
                                        } else {
                                          // var user = controller.getUserData();
                                          /* if (phone_verification == false ||
                                  phone_verification == null) {
                                _showVerificationSheet(context);

                              } else*/
                                          if (address == false) {
                                            showAddressSheet(context);
                                          } else {
                                            /*OrderItems orderItem = OrderItems(
                                                foodId: widget.food.id,
                                                additives: foodController.getList(),
                                                quantity:
                                                counterController.count.toString(),
                                                price: ((widget.food.price +
                                                    foodController
                                                        .additiveTotal) *
                                                    counterController.count
                                                        .toDouble())
                                                    .toStringAsFixed(2),
                                                instructions: _preferences.text,
                                                */ /*unitPrice: widget.food.price
                                                .toStringAsFixed(2), */ /*
                                                foodImageUrl: '',
                                                foodTitle: '',
                                                cartItemId: '',
                                                restaurantAddress: '',
                                                restaurantId: '',
                                                restaurantCoords: [],
                                                restaurantImageUrl: '',
                                                restaurantTitle: '',
                                                restaurantTime: '',
                                                distance: 0.0);*/

                                            final mainController = Get.find<
                                                MainScreenController>();
                                            mainController.setTabIndex = 2;
                                            Get.find<OrderController>()
                                                .clearOrderItems();
                                            counterController.clearCounter();

                                            Get.to(() => MainScreen());
                                          }
                                        }
                                      },
                                      child: ReusableText(
                                          text: "Place Order",
                                          style: appStyle(screenFontSize(18),
                                              kLightWhite, FontWeight.w600)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final mainController =
                                            Get.find<MainScreenController>();
                                        mainController.setTabIndex = 2;
                                        Get.find<OrderController>()
                                            .clearOrderItems();
                                        counterController.clearCounter();

                                        Get.to(() => MainScreen());
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: kSecondary,
                                        radius: screenButtonWidth(20),
                                        child: Badge(
                                          label: ReusableText(
                                              text: box.read('cart') ?? "0",
                                              style: appStyle(9, kLightWhite,
                                                  FontWeight.normal)),
                                          child: Icon(
                                            Ionicons.fast_food_outline,
                                            color: kLightWhite,
                                            size: screenIconSize(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      } else {
                        return GlobalLoading(
                          bottom: 10,
                          right: 0,
                          left: 0,
                        );
                      }
                    })
                  ],
                ),
              ),
            ));
  }

  Future<ResponseModel> loadData() async {
    //prepare the contact list for this user.
    //get the restaurant info from the firebase
    //get only one restaurant info
    return _controller.asyncLoadSingleRestaurant();
  }

  void loadChatData() async {
    ResponseModel response = await loadData();
    if (response.isSuccess == false) {
      showCustomSnackBar(response.message!, title: "Login issue");
    }
  }

  bool checkDistance(Restaurants restaurant) {
   // final controller = Get.put(AddressController());
    DistanceTime? distanceTime;
    final box = GetStorage();
      double? lat = box.read("userLat");
      double? lng = box.read("userLng");
      distanceTime = Distance().calculateDistanceTimePrice(
          lat!,
          lng!,
          restaurant.coords.latitude,
          restaurant.coords.longitude,
          10,
          Get.find<AppSetupController>().deliveryFee);

    bool distance = distanceTime!.distance > 100.0 ? false : true;

    box.write("distance", jsonDecode(distanceTime.distance.toString()));
    return distance;
  }

  Future<dynamic> _showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        barrierColor: kPrimary.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500.h,
            width: width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/restaurant_bk.png",
                    ),
                    fit: BoxFit.fill),
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  ReusableText(
                      text: "Verify Your Phone Number",
                      style: appStyle(20, kPrimary, FontWeight.bold)),
                  SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                          itemCount: verificationReasons.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                verificationReasons[index],
                                textAlign: TextAlign.justify,
                                style:
                                    appStyle(11, kGrayLight, FontWeight.normal),
                              ),
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: kPrimary,
                              ),
                            );
                          })),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                      onTap: () {
                        Get.to(() => const PhoneVerificationPage());
                      },
                      btnHieght: 40.h,
                      text: "Verify Phone Number"),
                ],
              ),
            ),
          );
        });
  }
}
