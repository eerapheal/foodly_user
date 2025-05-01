import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';


class AppVersionInfo extends StatelessWidget {
  final List<Map<String, String>> versionHistory = [
    {'date': '38. 11-12-24', 'description': 'Added feedback on web app user app (V4.7.0)'},
    {'date': '37. 07-12-24', 'description': 'Added chatting on web apps(user and vendor) (V4.6.0)'},
    {'date': '36. 02-12-24', 'description': 'Added map accuracy for restaurant and user (V4.5.1)'},
    {'date': '35. 25-11-24', 'description': 'Released vendor web app'},
    {'date': '34. 21-11-24', 'description': 'Added basic SEO to the web app'},
    {'date': '33. 20-11-24', 'description': 'Added web and mobile based code automation (V4.4.1)'},
    {'date': '32. 19-11-24', 'description': 'Released official flutter web version for user (V4.4.1)'},
    {'date': '31. 10-11-24', 'description': 'Added web url and sharing items through url (V4.3.2)'},
    {'date': '30. 09-11-24', 'description': 'Added Paystack support for web payment (beta) (V4.3.1)'},
    {'date': '29. 04-11-24', 'description': 'Added Stripe support for web payment (beta) (V4.1.1)'},
    {'date': '28. 29-10-24', 'description': 'Released Flutter Web App Beta for User App (V4.0.1)'},
  ];

  AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          title: const Text('Version History'),
          backgroundColor: kWhite,
          leading: const CommonBackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: versionHistory.length,
            itemBuilder: (context, index) {
              final version = versionHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(
                        version['date']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      subtitle: Text(
                        version['description']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                    ),
                    const SizedBox(
                      height: 10,
                      child:kIsWeb? Divider(thickness: 0.3,):null,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
