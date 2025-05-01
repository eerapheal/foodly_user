import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:foodly_user/views/orders/client_orders/active.dart';
import 'package:foodly_user/views/orders/client_orders/cancelled.dart';
import 'package:foodly_user/views/orders/client_orders/delivered.dart';
import 'package:foodly_user/views/orders/client_orders/paid.dart';
import 'package:foodly_user/views/orders/client_orders/pending.dart';
import 'package:foodly_user/views/orders/client_orders/preparing.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class ClientOrderPage extends StatefulHookWidget {
  const ClientOrderPage({Key? key}) : super(key: key);

  @override
  _ClientOrderPageState createState() => _ClientOrderPageState();
}

class _ClientOrderPageState extends State<ClientOrderPage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 6,
    vsync: this,
  );
  final box = GetStorage();
  late String? userToken;
  @override
  void initState() {
     userToken =box.read("token");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(userToken==null){
      return const NotFoundPage();
    }
    return  Container(
      color: kOffWhite,
      padding:  EdgeInsets.symmetric(horizontal: padding),
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          backgroundColor: kOffWhite,
          appBar: AppBar(
            backgroundColor: kOffWhite,
            elevation: 0,
            leading: const CommonBackButton(),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                Get.find<MainScreenController>().setTabIndex=0;
                Get.offAll(()=>MainScreen());

              }, icon: const Icon(Icons.home))
            ],
            title: ReusableText(
              text: "Orders",
              style: appStyle(16, Colors.black, FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(35.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 5),
                  height: 25.h,
                  width: width,
                  decoration: BoxDecoration(
                    color: kLightWhite,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    labelPadding: EdgeInsets.zero,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                    unselectedLabelColor: Colors.grey.withOpacity(0.7),
                    tabs:  <Widget>[
                      Tab(
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Pending")),
                        ),
                      ),
                      Tab(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),

                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Paid")),
                        ),
                      ),
                      Tab(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Preparing")),
                        ),
                      ),
                      Tab(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Delivering")),
                        ),
                      ),
                      Tab(
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Delivered")),
                        ),
                      ),
                      Tab(
                        child: Container(
                          margin:const EdgeInsets.symmetric(horizontal: 5),
                          width:MediaQuery.of(context).size.width/6,
                          //margin: EdgeInsets.only(left: 20, right: 20),
                          height: 25,
                          child: const Center(child: Text("Canceled")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          body: CustomContainer(
            color: kOffWhite,
            containerContent: SizedBox(
              height: hieght,
              child: TabBarView(controller: _tabController, children: const [
                PendingOrders(),
                PaidOrders(),
                PreparingOrders(),
                ActiveOrders(),
                DeliveredOrders(),
                CancelledOrders(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

}

class TabTitle extends StatelessWidget {
  const TabTitle({
    super.key, required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 25,
      child:  Center(child: Text(title)),
    );
  }
}
