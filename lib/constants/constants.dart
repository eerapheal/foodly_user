import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

// Padding Constant
double get padding {
  double width = Get.width; // Get the screen width
  return width > 800 ? width * 0.1:0.01; // Adjust padding based on screen width
}
// For padding values
double screenPad(double pad) {
  double basePad = pad.w;
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 375) {
    return basePad * 0.9; // Slightly smaller for very small screens
  } else if (screenWidth > 1280) {
    return basePad * 1.2; // Slightly larger for large screens
  }
  return basePad;
}

// For margin values
double screenMargin(double margin) {
  double baseMargin = margin.w;
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 375) {
    return baseMargin * 0.9;
  } else if (screenWidth > 1280) {
    return baseMargin * 1.2;
  }
  return baseMargin;
}

// For font sizes
double screenFontSize(double fontSize) {

    double baseFontSize = fontSize;
    double screenWidth = ScreenUtil().screenWidth;

    // Fine-grained scaling based on screen width
    if (screenWidth < 320) {
      return baseFontSize * 0.85; // Very small screens
    } else if (screenWidth < 375) {
      return baseFontSize * 0.9;  // Small screens
    } else if (screenWidth < 414) {
      return baseFontSize * 0.95; // Small-medium screens
    } else if (screenWidth < 768) {
      return baseFontSize;        // Medium screens, default scaling
    } else if (screenWidth < 1024) {
      return baseFontSize * 1.05; // Larger tablets
    } else if (screenWidth < 1280) {
      return baseFontSize * 1.1;  // Small desktops
    } else if (screenWidth < 1440) {
      return baseFontSize * 1.15; // Medium desktops
    } else {
      return baseFontSize * 1.2;  // Large desktops
    }
  }


// For icon sizes
double screenIconSize(double iconSize) {
  double baseIconSize = iconSize;
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 375) {
    return baseIconSize * 0.9;
  } else if (screenWidth > 1280) {
    return baseIconSize * 1.1;
  }
  return baseIconSize;
}

// For button height
double screenButtonHeight(double height) {
  double baseHeight = height;
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 320) {
    return baseHeight * 0.65; // Extra small screens
  } else if (screenWidth < 375) {
    return baseHeight * 0.75; // Small screens
  } else if (screenWidth >= 375 && screenWidth <= 768) {
    return baseHeight * 0.9; // Default for mobile
  } else if (screenWidth > 768 && screenWidth <= 1280) {
    return baseHeight*0.85; // Medium screens
  } else if (screenWidth > 1280 && screenWidth <= 1440) {
    return baseHeight * 1; // Large screens
  } else if (screenWidth > 1440) {
    return baseHeight * 1.3; // Extra large screens
  }
  return baseHeight;
}


// For button width
double screenButtonWidth(double width) {
  double baseWidth = width;
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 320) {
    return baseWidth * 0.65; // Extra small screens
  } else if (screenWidth < 375) {
    return baseWidth * 0.7; // Small screens
  } else if (screenWidth >= 375 && screenWidth <= 768) {
    return baseWidth * 0.8; // Default for mobile
  } else if (screenWidth > 768 && screenWidth <= 1280) {
    return baseWidth*0.95; // Medium screens
  } else if (screenWidth > 1280 && screenWidth <= 1440) {
    return baseWidth * 1.2; // Large screens
  } else if (screenWidth > 1440) {
    return baseWidth * 1.3; // Extra large screens
  }
  return baseWidth;
}



double screenTextBoxWidth() {
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 375) {
    return 300.w; // Adjust for small screens
  } else if (screenWidth > 1280) {
    return 500.w; // Adjust for larger screens
  }
  return 400.w; // Default for mid-sized screens
}
Size responsiveBoxSize(double baseWidth, double baseHeight) {
  double screenWidth = ScreenUtil().screenWidth;

  if (screenWidth < 375) {
    return Size(baseWidth * 0.9.w, baseHeight * 0.9.h); // Smaller for small screens
  } else if (screenWidth > 1280) {
    return Size(baseWidth * 1.2.w, baseHeight * 1.2.h); // Larger for large screens
  }
  return Size(baseWidth.w, baseHeight.h); // Default scaling
}

const double appBorderRadius = 10;

// Color Constants
const kPrimary = Color(0xFF30b9b2);
const kPrimaryLight = Color(0xFF40F3EA);
const kSecondary = Color(0xffff7a4f);
const kSecondaryLight = Color(0xFFffe5db);
const kTertiary = Color(0xff0078a6);
const kGray = Color(0xff83829A);
const kGrayLight = Color(0xffC1C0C8);
const kLightWhite = Color(0xffFAFAFC);
const kWhite = Color(0xffffffff);
const kDark = Color(0xFF121212);
const kRed = Color(0xffe81e4d);
const kOffWhite = Color(0xffF3F4F8);
const kMenu = Color(0xffff7a4f);
const kTextBoxBackground = Color(0xFF7f8f97);

// Screen Dimensions Constants
// Screen Dimensions Constants
double hieght = ScreenUtil().screenHeight;
double width = ScreenUtil().screenWidth;

// You can also define a constant for minimum padding if needed
const double minPadding = 20.0; // For example, set a minimum padding value
const double minTextBoxPadFactor=3;
// Final padding calculation with a minimum constraint
double finalPadding = padding < minPadding ? minPadding : padding;
double textBoxPadding = padding * minTextBoxPadFactor;
// Font Size Constants
double kFontSizeSmaller = 10;
// Use for small labels, captions, or secondary text that requires less emphasis.
double kFontSizeSmall = 12;
// Suitable for general body text or descriptive text on the screen.
double kFontSizeMedium = 14;

// Use for highlighted text, main body content, or important information that should stand out slightly more.
double kFontSizeLarge = 16;

// Ideal for subtitles, section headers, or key content that needs to grab user attention without being too large.
double kFontSizeExtraLarge = 20.sp;

// Use for titles of sections, main headings, or any major content on the screen.
double kFontSizeTitle = 24.sp;

// Best for prominent headings like page titles or key areas of the UI, like headers in settings or splash screens.
double kFontSizeHeading = 28.sp;


// Padding and Margin Constants

// Use for subtle padding or spacing between smaller UI components, such as icons or buttons in a compact layout.
double kPaddingSmall = 8;
double kPaddingSmallMedium = 12;
// Suitable for general padding around text fields, buttons, or smaller containers.
double kPaddingMedium = 16;

// Use for more spacious padding around larger sections or components, like cards or modals.
double kPaddingLarge = 24.w;

// Best for significant padding around large UI sections, or when creating white space between large content areas.
double kPaddingExtraLarge = 32.w;


// Margin Constants

// Ideal for slight spacing between small UI elements like icons or closely placed buttons.
double kMarginSmall = 8.w;

// Suitable for adding consistent spacing between components like text fields, buttons, or cards.
double kMarginMedium = 16.w;

// Use for moderate spacing between UI sections, like lists or groups of components.
double kMarginLarge = 24.w;

// Best for large spaces between major UI components, or creating structured layouts in large areas.
double kMarginExtraLarge = 32.w;

//images
double kImageHeightTile = 75;
double kImageWidthTile = 80;
// Text Style Constants
TextStyle kTextStyleSmall = TextStyle(
  fontSize: kFontSizeSmall,
  fontWeight: FontWeight.normal,
  color: kDark,
);

TextStyle kTextStyleMedium = TextStyle(
  fontSize: kFontSizeMedium,
  fontWeight: FontWeight.w500,
  color: kDark,
);

TextStyle kTextStyleLarge = TextStyle(
  fontSize: kFontSizeLarge,
  fontWeight: FontWeight.bold,
  color: kDark,
);

TextStyle kTextStyleTitle = TextStyle(
  fontSize: kFontSizeTitle,
  fontWeight: FontWeight.bold,
  color: kPrimary,
);

// List of Verification Reasons
final List<String> verificationReasons = [
  'Real-time Updates: Get instant notifications about your order status.',
  'Direct Communication: A verified number ensures seamless communication.',
  'Enhanced Security: Protect your account and confirm orders securely.',
  'Effortless Rescheduling: Easily address issues with a quick call.',
  'Exclusive Offers: Stay in the loop for special deals and promotions.'
];

// List of Reasons to Add Address
List<String> reasonsToAddAddress = [
  "Ensures that food orders are delivered accurately to the customer’s location.",
  "Allows users to check if the delivery service is available in their area.",
  "Provides a personalized experience by showing nearby restaurants, estimated delivery times, and special offers.",
  "Streamlines the checkout process by saving addresses for quicker order placement.",
  "Enables management of multiple addresses (e.g., home, work) for easy switching.",
];

double kPriceHeight = 20.h;
