// import 'package:my_app/app/core/const/export.dart';
// import 'package:my_app/app/global_functions/global_functions.dart';
// import 'package:my_app/app/modules/make_a_payment/controllers/make_a_payment_controller.dart';
// import 'package:my_app/app/modules/my_wallet/bindings/my_wallet_binding.dart';
// import 'package:my_app/app/modules/my_wallet/controllers/my_wallet_controller.dart';
// import 'package:my_app/app/widgets/custom_button.dart';
// import 'package:my_app/app/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../generated/assets.dart';
// import '../../data/api_repository.dart';
// import '../../modules/coupon_details/controllers/coupon_details_controller.dart';
// import '../../modules/coupon_details/model/GetTaxModel.dart';
// import '../../modules/coupon_details/views/coupon_details_view.dart';
// import '../../modules/my_wallet/tax_model.dart';
// import '../../modules/onboarding/views/onboarding_view.dart';
// import '../../modules/scan_to_redeem/controllers/scan_to_redeem_controller.dart';
// import '../../modules/search/controllers/search_controller.dart';
// import '../../modules/signup/views/account_created_view.dart';
// import '../../routes/app_pages.dart';
// import '../../services/local_storage_services/local_storage_services.dart';
// import '../../widgets/custom_image_view.dart';
// import '../extensions.dart';
// import 'app_colors.dart';
// import 'app_dialogs.dart' hide LocalStorageService;
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../routes/app_pages.dart';
//
//
// class AppBottomSheet {
//
//   static void showInsufficientPointsSheet() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Sorry! But you not have enough Points to buy This Coupon"
//                       .style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Buy Points!", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showCouponPurchesedSuccessfully() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Congratulation! Coupon\nPurchased Successfully".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Continue", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showAlreadyCoupon() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   24.heightBox,
//                   // "Congratulation! Coupon\nPurchased Successfully".style.w620.lineHeight(1.3).center.make(),
//                   // 12.heightBox,
//                   "You already have this coupon in your wallet. Please Redeem it before you can purchase another one"
//                       .style.w416
//                       .color(Color.fromRGBO(35, 35, 35, 1))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   12.heightBox,
//                   CustomButton(text: "Take me there", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showPurchaseLimitReached() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   24.heightBox,
//                   // "Congratulation! Coupon\nPurchased Successfully".style.w620.lineHeight(1.3).center.make(),
//                   // 12.heightBox,
//                   "Sorry! Purchase Limit reached. This coupon cannot be allowed to purchase anymore"
//                       .style.w416
//                       .color(Color.fromRGBO(35, 35, 35, 1))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   12.heightBox,
//                   CustomButton(text: "Search Other", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showBonus50() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Congratulations! You\nearned 50 bonus points".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Continue", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showCodeInvalid() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Code is not valid.\nPlease enter again.".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Re-enter", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showRedeemCoupon({VoidCallback? onClose}) {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(
//               imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,
//             ),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto redeem the coupon"
//                       .style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(const Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Obx(() {
//                           return CustomButton(
//                             text: "Yes",
//                             isLoading: Get.find<ScanToRedeemController>().isLoading.value,
//                             onPressed: () async {
//                             bool isSucces =  await Get.find<ScanToRedeemController>().redeemCoupon();
//                             if(isSucces){
//                               Get.back();
//                               Get.back();
//                             }
//
//                               onClose?.call(); // âœ… Reset after close
//                             },
//                           );
//                         }),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(
//                           text: "No",
//                           isOutlined: true,
//                           onPressed: () {
//                             Get.back();
//                             onClose?.call(); // âœ… Reset after close
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   40.heightBox,
//                 ],
//               ).kpLR(26.w),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     ).whenComplete(() {
//       onClose?.call(); // âœ… Safety reset if dismissed by swipe
//     });
//   }
//
//   static void showSubmitNewTicket() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Submit New Ticket".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           Get.back();
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showAddReview(
//       {required TextEditingController controller, required String coupon_id}) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Add your Review".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           Get.back();
//                           AppBottomSheet.showEnterReview(
//                               controller: controller, coupon_id: coupon_id);
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showUpdatePassword() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Update Password".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           Get.back();
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showMakePayment() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Make Payment".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           Get.back();
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showReachedFreeCouponLimit() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "You've reached your\nFree Coupon limit".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "You already have 5 free coupons in your wallet. To get this coupon for free, please remove an existing one first."
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           text: "Go to My Stuff", onPressed: () {
//                           Get.back();
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showGetITFree({required String couponId}) {
//     RxBool isLoading = false.obs;
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Get it Free?".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "You will be able to redeem this\ncoupon within 48 hours."
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Obx(() {
//                           return CustomButton(text: "Yes",
//                             isLoading: isLoading.value,
//                             onPressed: () async {
//
//                               isLoading.value = true;
//                               bool isPurchaseSuccess = await ApiRepository
//                                   .buyCupon(couponId: couponId, type: "free");
//                               isLoading.value = false;
//
//                               if (isPurchaseSuccess) {
//                                 print("isPurchaseSuccess");
//                                 Get.back();
//
//                                 showCouponPurchesedSuccessfully();
//                               }
//                             },);
//                         }),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showSurePurchase({required String couponId,
//     required String couponExpiryDate,
//     required String couponTitle,
//     required String couponPrice,
//
//   }) {
//     RxBool isLoading = false.obs;
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     12.heightBox,
//                     "Are you sure you want\nto Purchase?".style.w620
//                         .lineHeight(1.3)
//                         .center
//                         .make()
//                         .kpLR(26.w),
//                     12.heightBox,
//                     "You will be able to redeem this coupon before the expiry date set by the business."
//                         .style.w312
//                         .color(Color.fromRGBO(35, 35, 35, 0.5))
//                         .lineHeight(1.3)
//                         .center
//                         .make()
//                         .kpLR(26.w),
//                     24.heightBox,
//                     RedeemInfoTable(row: [
//                       _buildRow("Coupon Title          ", "$couponTitle"),
//                       _buildRow("Expiry Date", "${couponExpiryDate}"),
//                     ],
//                     ).kpLR(8.w),
//                     24.heightBox,
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Obx(() {
//                             return CustomButton(
//                               text: "Yes",
//                               isLoading: isLoading.value,
//                               onPressed: () async {
//                                 isLoading.value = true;
//                                 bool isPurchaseSuccess = await ApiRepository
//                                     .buyCupon(couponId: couponId, type: "paid");
//                                 isLoading.value = false;
//                                 if (isPurchaseSuccess) {
//                                   Get.back();
//                                   showCouponPurchesedSuccessfully();
//                                 }
//                               },);
//                           }),
//                         ),
//                         12.widthBox,
//                         Expanded(
//                           child: CustomButton(text: "No", onPressed: () {
//                             Get.back();
//                           }, isOutlined: true,),
//                         ),
//                       ],
//                     ).kpLR(26.w),
//                     40.heightBox
//                   ],
//                 )
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showChooseCouponFreePurchase({
//     required RxInt selectedIndex,
//     required String couponId,
//     required String couponExpiryDate,
//     required String couponTitle,
//     required String couponPrice,
//   }) {
//     RxBool isLoading = false.obs;
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(
//               imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,
//             ),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Choose How You Want\nto Get This Coupon".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make()
//                       .kpLR(26.w),
//                   12.heightBox,
//                   "Free coupons expire in 48 hrs. Purchased coupons are valid till expiry date."
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make()
//                       .kpLR(26.w),
//                   24.heightBox,
//                   Obx(() {
//                     return AccessPlanCard(
//                       isSelected: selectedIndex.value == 0,
//                       title: 'Get it Free (48 hrs)',
//                       subtitle: 'Valid for 48 hrs â€“ auto-expires if unused.',
//                       onTap: () => selectedIndex.value = 0,
//                     );
//                   }),
//                   12.heightBox,
//                   Obx(() {
//                     return AccessPlanCard(
//                       isSelected: selectedIndex.value == 1,
//                       title: 'Purchase (Full Validity)',
//                       subtitle: '${couponExpiryDate}.',
//                       onTap: () => selectedIndex.value = 1,
//                     );
//                   }),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           if (selectedIndex.value == 0) {
//                             GlobalFunctions.kprint("yes");
//                             Get.back();
//                             showGetITFree(couponId: couponId);
//                           } else {
//                             Get.back();
//                             showSurePurchase(couponId: couponId
//                               , couponExpiryDate: couponExpiryDate,
//                               couponTitle: couponTitle,
//                               couponPrice: couponPrice,
//                             );
//                             // showGetITFree();
//                           }
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         },
//                           isOutlined: true,
//                         ),
//                       ),
//                     ],
//                   ).kpLR(26.w),
//                   40.heightBox
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   // static void showChooseCouponFreePurchase({required RxInt selectedIndex,
//   //   required String couponId,
//   //   required String couponExpiryDate,
//   //   required String couponTitle,
//   //   required String couponPrice,
//   //
//   // }) {
//   //   Get.bottomSheet(
//   //     Container(
//   //       decoration: BoxDecoration(
//   //         color: Colors.transparent,
//   //         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//   //       ),
//   //       child: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//   //             width: Get.width,),
//   //           Container(
//   //               color: Colors.white,
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.max,
//   //                 children: [
//   //                   12.heightBox,
//   //                   "Choose How You Want\nto Get This Coupon".style.w620
//   //                       .lineHeight(1.3)
//   //                       .center
//   //                       .make()
//   //                       .kpLR(26.w),
//   //                   12.heightBox,
//   //                   "Free coupons expire in 48 hrs. Purchased coupons are valid till expiry date."
//   //                       .style.w312
//   //                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//   //                       .lineHeight(1.3)
//   //                       .center
//   //                       .make()
//   //                       .kpLR(26.w),
//   //                   24.heightBox,
//   //                   Obx(() {
//   //                     return AccessPlanCard(
//   //                       isSelected: selectedIndex.value == 0,
//   //                       title: 'Get it Free (48 hrs)',
//   //                       subtitle: 'Valid for 48 hrs â€“ auto-expires if unused.',
//   //                       onTap: () => selectedIndex.value = 0,
//   //                     );
//   //                   }),
//   //                   12.heightBox,
//   //                   Obx(() {
//   //                     return AccessPlanCard(
//   //                       isSelected: selectedIndex.value == 1,
//   //                       title: 'Purchase (Full Validity)',
//   //                       subtitle: '${couponExpiryDate}.',
//   //                       onTap: () => selectedIndex.value = 1,
//   //                     );
//   //                   }),
//   //                   24.heightBox,
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: CustomButton(text: "Yes", onPressed: () {
//   //                           if (selectedIndex.value == 0) {
//   //                             GlobalFunctions.kprint("yes");
//   //                             Get.back();
//   //                             showGetITFree(couponId: couponId);
//   //                           } else {
//   //                             Get.back();
//   //                             showSurePurchase(couponId: couponId, couponExpiryDate: couponExpiryDate, couponTitle: couponTitle, couponPrice: couponPrice,);
//   //                             // showGetITFree();
//   //                           }
//   //                         },),
//   //                       ),
//   //                       12.widthBox,
//   //                       Expanded(
//   //                         child: CustomButton(text: "No", onPressed: () {
//   //                           Get.back();
//   //                         }, isOutlined: true,),
//   //                       ),
//   //                     ],
//   //                   ).kpLR(26.w),
//   //                   40.heightBox
//   //                 ],
//   //               )
//   //           ),
//   //
//   //         ],
//   //       ),
//   //     ),
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.transparent,
//   //   );
//   // }
//
//   static void showEnterReview({
//     required TextEditingController controller,
//     required String coupon_id,
//
//   }) {
//     double rating = 0.0;
//     controller.text = "";
//     RxBool isLoading = false.obs;
//
//
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   10.heightBox,
//                   "Enter your Review".style.w518
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   40.heightBox,
//                   // â­ Rating Bar
//                   RatingBar.builder(
//                     initialRating: rating,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: false,
//                     itemCount: 5,
//                     glowRadius: 2,
//                     itemSize: 32,
//                     //rgba(251, 162, 44, 1)
//                     unratedColor: Color.fromRGBO(251, 226, 191, 1),
//                     itemBuilder: (context, _) =>
//                         Icon(Icons.star, color: Colors.orange),
//                     onRatingUpdate: (value) {
//                       rating = value;
//                     },
//                   ),
//                   24.heightBox,
//                   CustomTextField(controller: controller,
//                     hintText: "Enter your Review",
//                     maxLines: 5,),
//                   24.heightBox,
//                   Obx(() {
//                     return CustomButton(text: "Submit",
//                       isLoading: isLoading.value,
//                       onPressed: () async {
//                         isLoading.value = true;
//                         bool isDone = await ApiRepository.addRatting(
//                             coupon_id: coupon_id,
//                             rating: rating.toString(),
//                             description: controller.text);
//                         isLoading.value = false;
//                         if (isDone) {
//                           controller.clear();
//                           rating = 0;
//                           Get.find<CouponDetailsController>().getCouponDetail();
//                           Get.back();
//                         }
//                         //
//                         // showAddReview(controller: controller);
//                       },);
//                   }),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showFilterByDate({required bool isTrnjection, required Rx<DateTime?> startDate , required Rx<DateTime?> endDate}) {
//     // final Rx<DateTime?> startDate = Rx<DateTime?>(null);
//     // final Rx<DateTime?> endDate = Rx<DateTime?>(null);
//
//     Future<void> pickDate({required bool isStart}) async {
//       final DateTime now = DateTime.now();
//       final DateTime? picked = await showDatePicker(
//         context: Get.context!,
//         initialDate: now,
//         firstDate: DateTime(2000),
//         lastDate: DateTime.now(),
//       );
//
//       if (picked != null) {
//         if (isStart) {
//           startDate.value = picked;
//         } else {
//           endDate.value = picked;
//         }
//       }
//     }
//
//     String formatDate(DateTime? date) {
//       if (date == null) return 'Select Date';
//       return DateFormat('dd MMM yyyy').format(date);
//     }
//
//
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(
//               imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,
//             ),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   10.heightBox,
//                   "Filter By Date".style.w518
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell( onTap: (){
//                         if(isTrnjection){
//                           Get.find<MyWalletController>().startDateTNX.value = null;
//                           Get.find<MyWalletController>().endDateTNX.value = null;
//                           Get.find<MyWalletController>().getTransactionsUserFun();
//                           Get.back();
//                         }else{
//                           Get.find<MyWalletController>().startDate.value = null;
//                           Get.find<MyWalletController>().endDate.value = null;
//                           Get.find<MyWalletController>().getStatisticsUserFun();
//                           Get.back();
//                         }
//                       },
//                           child: Text("Clear filter",style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w400,fontSize: 16.sp),)),
//                     ],
//                   ),
//                   24.heightBox,
//                   // Start Date Picker
//                   Obx(() =>
//                       InkWell(
//                         onTap: () => pickDate(isStart: true),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 14, horizontal: 16),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.calendar_today,
//                                   color: Colors.grey, size: 20),
//                               const SizedBox(width: 12),
//                               Text("Start: ${formatDate(startDate.value)}"),
//                             ],
//                           ),
//                         ),
//                       )),
//                   16.heightBox,
//
//                   // End Date Picker
//                   Obx(() =>
//                       InkWell(
//                         onTap: () => pickDate(isStart: false),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 14, horizontal: 16),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.calendar_today,
//                                   color: Colors.grey, size: 20),
//                               const SizedBox(width: 12),
//                               Text("End: ${formatDate(endDate.value)}"),
//                             ],
//                           ),
//                         ),
//                       )),
//                   24.heightBox,
//
//                   CustomButton(
//                     text: "Apply Filter",
//                     onPressed: () {
//
//                       // you can return the date range here or apply filter logic
//                       GlobalFunctions.kprint("Start Date: ${startDate.value}");
//                       GlobalFunctions.kprint("End Date: ${endDate.value}");
//
//                       if(startDate.value == null){
//                         AppDialog.showToast("Please select start date");
//                         return;
//                       }
//                       if(endDate.value == null){
//                         AppDialog.showToast("Please select end date");
//                         return;
//                       }
//                       String start = DateFormat('yyyy-MM-dd').format(startDate.value!);
//                       String end = DateFormat('yyyy-MM-dd').format(endDate.value!.add(const Duration(days: 1)),);
//                       if(isTrnjection){
//                         Get.find<MyWalletController>().getTransactionsUserFun(startDate: start,endDate: end);
//                         Get.back();
//                       }else{
//                         Get.find<MyWalletController>().getStatisticsUserFun(startDate: start,endDate: end);
//                         Get.back();
//                       }
//
//                     },
//                   ),
//                   40.heightBox,
//                 ],
//               ).kpLR(26.w),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showBuyAPoint({
//     required GetTaxModel taxModel
// }) {
//     RxBool isLoading = false.obs;
//     Widget pointCard({
//       required num point,
//       required num beforePoint,
//       required num amount,
//     }) {
//       return Expanded(
//         child: InkWell(
//           onTap: () async {
//
//             Get.back();
//             // show hone se phle amount dalna hy taxmodel aa raha hy usme
//             AppDialog.showPurchaseSummaryDialog(
//               context: Get.context!,
//               taxModel: GetTaxModel(
//                 data: Data(
//                   amount: amount,
//                   totalAmount: 0,
//                   country: taxModel.data?.country,
//                   province: taxModel.data?.province,
//                   gst: taxModel.data?.gst,
//                   pst: taxModel.data?.pst,
//                   hst: taxModel.data?.hst,
//                 )
//               ),
//               points: point,
//             );
//
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(.15),
//               borderRadius: BorderRadius.circular(16.r),
//               border: Border.all(
//                   color: Color.fromRGBO(165, 246, 131, 1), width: 1.5.r),
//             ),
//             child: Column(
//               children: [
//                 10.heightBox,
//                 CustomImageView(
//                   imagePath: Assets.homeCoin,
//                   height: 40.r,
//                 ),
//                 13.heightBox,
//                 "$point points".style.w615.make(),
//                 8.heightBox,
//                 Opacity(
//                   opacity: 0.60,
//                   child: Text(
//                     "$beforePoint points",
//                     style: TextStyle(
//                       color: const Color(0xFF232323) /* Color-2 */,
//                       fontSize: 10,
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400,
//                       decoration: TextDecoration.lineThrough,
//                       height: 0.80,
//                     ),
//                   ),
//                 ),
//                 12.heightBox,
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(23.r),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         const Color.fromRGBO(72, 210, 14, 1),
//                         const Color.fromRGBO(66, 179, 17, 1),
//                       ],
//                     ),
//                   ),
//                   padding: EdgeInsets.only(
//                       left: 14.w, right: 14.w, top: 8.h, bottom: 8.h),
//                   child:Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         "For".style.w508.color(Colors.white).make(),
//                         4.widthBox,
//                         "\$$amount".style.w712.color(Colors.white).make(),
//                       ]
//                   ),
//                 ),
//                 19.heightBox,
//               ],
//             ),
//
//           ),
//         ),
//       );
//     }
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     12.heightBox,
//                     "Buy a Points".style.w620
//                         .lineHeight(1.3)
//                         .center
//                         .make()
//                         .kpLR(26.w),
//                     12.heightBox,
//                     Stack(
//                         children: [
//                           CustomImageView(
//                             imagePath: "assets/home/boy_a_point_buttomsheet.png",
//                             radius: BorderRadius.circular(16),
//                           ).kpLR(26),
//                           Container(
//                             child: Column(
//                               children: [
//                                 22.heightBox,
//                                 Row(
//                                     children: [
//                                       18.widthBox,
//                                       CustomImageView(
//                                         imagePath: Assets.homeCoin,
//                                         height: 30.r,
//                                         radius: BorderRadius.circular(16),
//                                       ),
//                                       18.widthBox,
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           "1000 Point".style.w715.color(
//                                               Colors.white).make(),
//                                           6.heightBox,
//                                           Text("800 Points", style: TextStyle(
//                                             fontSize: 14.sp,
//                                             color: Color.fromRGBO(
//                                                 255, 255, 255, 0.6),
//                                             decoration: TextDecoration
//                                                 .lineThrough,
//                                             decorationColor: Colors.white,),)
//                                         ],
//                                       ),
//                                       Spacer(),
//                                       InkWell(onTap: () async {
//                                         print("object");
//
//                                         Get.back();
//                                         // show hone se phle amount dalna hy taxmodel aa raha hy usme
//                                         AppDialog.showPurchaseSummaryDialog(
//                                           context: Get.context!,
//                                           taxModel: GetTaxModel(
//                                               data: Data(
//                                                 amount: 35,
//                                                 totalAmount: 0,
//                                                 country: taxModel.data?.country,
//                                                 province: taxModel.data?.province,
//                                                 gst: taxModel.data?.gst,
//                                                 pst: taxModel.data?.pst,
//                                                 hst: taxModel.data?.hst,
//                                               )
//                                           ),
//                                           points: 1000,
//                                         );
//
//                                       },
//                                         child: Container(
//                                             height: 30.h,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius
//                                                   .circular(16),
//                                               color: Colors.white,
//                                             ),
//                                             child: Obx(() {
//                                               return isLoading.value
//                                                   ? Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 40.0.w,
//                                                     right: 40.0.w),
//                                                 child: Center(child: SizedBox(
//                                                     height: 20.h,
//                                                     width: 20.h,
//                                                     child: CircularProgressIndicator(
//                                                         color: AppColors
//                                                             .primaryColor,
//                                                         strokeWidth: .9)),),
//                                               )
//                                                   : Row(
//                                                 children: [
//                                                   Text(
//                                                     '       Only For   ',
//                                                     style: TextStyle(
//                                                       color: const Color(
//                                                           0xFF44C00F),
//                                                       fontSize: 9.sp,
//                                                       fontFamily: 'Poppins',
//                                                       fontWeight: FontWeight
//                                                           .w500,
//                                                       height: 1.11,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '\$35       ',
//                                                     style: TextStyle(
//                                                       color: const Color(
//                                                           0xFF44C00F),
//                                                       fontSize: 13.sp,
//                                                       fontFamily: 'Poppins',
//                                                       fontWeight: FontWeight
//                                                           .w700,
//                                                       height: 0.77,
//                                                     ),
//                                                   )
//                                                 ],
//                                               );
//                                             })
//                                         ),
//                                       ),
//                                       18.widthBox,
//                                     ]
//                                 ),
//                                 22.heightBox,
//
//                               ],
//                             ).kpLR(26),
//                           ),
//                         ]
//                     ),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         pointCard(
//                           point: 100,
//                           beforePoint: 80,
//                           amount: 10,
//                         ),
//                         14.widthBox,
//                         pointCard(
//                           point: 300,
//                           beforePoint: 200,
//                           amount: 15,
//                         ),
//                         14.widthBox,
//                         pointCard(
//                           point: 500,
//                           beforePoint: 400,
//                           amount: 25,
//                         ),
//                       ],
//                     ).kpLRDefault(),
//
//                     12.heightBox,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Recharge Instruction",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 10.sp,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         ...[
//                           "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on that so it has",
//                           "Lorem ipsum is simple till now text just people so we need to a that can your people kill to wrong on that so it has",
//                           "Lorem ipsum is simple dummy text that can goes under till",
//                           "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on that so it has",
//                           "Lorem ipsum is simple till just people so we need to that can",
//                         ].map((instruction) =>
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("â€¢ ",
//                                       style: TextStyle(
//                                           fontSize: 18, color: Colors.black)),
//                                   Expanded(
//                                     child: Text(
//                                       instruction,
//                                       style: TextStyle(
//                                         fontSize: 10.sp,
//                                         height: 1.5,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                       ],
//                     ).kpLR(26.w),
//
//                     // Row(
//                     //   children: [
//                     //     // Expanded(
//                     //     //   child: CustomButton(text: "Yes", onPressed: () {
//                     //     //     Get.back();
//                     //     //     showCouponPurchesedSuccessfully();
//                     //     //   },),
//                     //     // ),
//                     //     // 12.widthBox,
//                     //     // Expanded(
//                     //     //   child: CustomButton(text: "No", onPressed: () {
//                     //     //     Get.back();
//                     //     //   }, isOutlined: true,),
//                     //     // ),
//                     //   ],
//                     // ).kpLR(26.w),
//                     40.heightBox
//
//                   ],
//                 )
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showSelectCountryProvinceDialog({
//     required Function(String country, String province) onConfirm,
//     String? prefilledCountry, // optional â€“ locks the country dropdown
//   }) {
//     // Reactive values
//     final selectedCountry = (prefilledCountry ?? '').obs;
//     final selectedProvince = ''.obs;
//     final isConfirmEnabled = false.obs;
//
//     void updateConfirm() {
//       isConfirmEnabled.value =
//           selectedCountry.value.isNotEmpty && selectedProvince.value.isNotEmpty;
//     }
//
//     // If a country is pre-filled â†’ enable confirm button when province is selected
//     if (selectedCountry.value.isNotEmpty) updateConfirm();
//
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(
//               imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,
//             ),
//
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   12.heightBox,
//
//                   // Title
//                   "Select Country & Province"
//                       .tr
//                       .style
//                       .w620
//                       .fontWeight(FontWeight.w600)
//                       .center
//                       .make()
//                       .kpLR(26.w),
//
//                   20.heightBox,
//
//                   // ---------- Country ----------
//                   Text(
//                     "Country",
//                     style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//                   ),
//                   8.heightBox,
//                   Obx(() {
//                     final bool locked = prefilledCountry != null;
//
//                     return Container(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
//                       decoration: BoxDecoration(
//                         color: locked ? Colors.grey.shade100 : null,
//                         border: Border.all(
//                           color: locked
//                               ? Colors.grey.shade400
//                               : (selectedCountry.value.isEmpty
//                               ? Colors.red.shade300
//                               : Colors.grey.shade300),
//                         ),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           hint: Text(
//                             "Select Country",
//                             style: TextStyle(
//                                 color: Colors.grey.shade500, fontSize: 14.sp),
//                           ),
//                           value: selectedCountry.value.isEmpty
//                               ? null
//                               : selectedCountry.value,
//                           icon: locked
//                               ? Icon(Icons.lock,
//                               size: 20.r, color: Colors.grey.shade600)
//                               : Icon(Icons.keyboard_arrow_down, size: 20.r),
//                           items: supportedCountries
//                               .map((e) => DropdownMenuItem<String>(
//                             value: e,
//                             child: Text(e,
//                                 style: TextStyle(fontSize: 14.sp)),
//                           ))
//                               .toList(),
//                           onChanged: locked
//                               ? null
//                               : (String? v) {
//                             if (v != null) {
//                               selectedCountry.value = v;
//                               selectedProvince.value = '';
//                               updateConfirm();
//                             }
//                           },
//                         ),
//                       ),
//                     );
//                   }),
//
//                   16.heightBox,
//
//                   // ---------- Province ----------
//                   Text(
//                     "Province / State",
//                     style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//                   ),
//                   8.heightBox,
//                   Obx(() {
//                     final bool show = selectedCountry.value.isNotEmpty;
//                     final List<String> provinces = show
//                         ? taxRates[selectedCountry.value]!.keys.toList()
//                         : [];
//
//                     return Container(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: selectedProvince.value.isEmpty && show
//                               ? Colors.red.shade300
//                               : Colors.grey.shade300,
//                         ),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           hint: Text(
//                             show ? "Select Province" : "First select country",
//                             style: TextStyle(
//                                 color: Colors.grey.shade500, fontSize: 14.sp),
//                           ),
//                           value: selectedProvince.value.isEmpty
//                               ? null
//                               : selectedProvince.value,
//                           icon: Icon(Icons.keyboard_arrow_down, size: 20.r),
//                           items: provinces
//                               .map((p) => DropdownMenuItem<String>(
//                             value: p,
//                             child: Text(p,
//                                 style: TextStyle(fontSize: 14.sp)),
//                           ))
//                               .toList(),
//                           onChanged: show
//                               ? (String? v) {
//                             if (v != null) {
//                               selectedProvince.value = v;
//                               updateConfirm();
//                             }
//                           }
//                               : null,
//                         ),
//                       ),
//                     );
//                   }),
//
//                   24.heightBox,
//
//                   // ---------- Confirm ----------
//                   Obx(() => CustomButton(
//                     text: "Confirm",
//                     onPressed: isConfirmEnabled.value
//                         ? () {
//                       Get.back();
//                       onConfirm(
//                           selectedCountry.value, selectedProvince.value);
//                     }
//                         : null,
//                   ).kpLRDefault()),
//
//                   16.heightBox,
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//
//   static void showLogOut() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Logout".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsom is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Cancel", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "Logout", onPressed: () {
//                           Get.back();
//                           LocalStorageService().logout();
//                         },),
//                       ),
//                     ],
//                   ),
//                   60.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showUploadImageSheet(
//       {required Function() onCameraTap, required Function() onGalleryTap}) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     12.heightBox,
//                     Row(
//
//                     ),
//                     "Upload Image".style.w620
//                         .lineHeight(1.3)
//                         .center
//                         .make()
//                         .kpLR(26.w),
//                     30.heightBox,
//                     InkWell(onTap: onCameraTap,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.camera_alt_outlined,
//                               color: AppColors.primaryColor,),
//                             "Camera".style.w513
//                                 .lineHeight(1.3)
//                                 .center
//                                 .make()
//                                 .kpLeft(16.w),
//                           ]
//                       ).kpLR(26.w),
//                     ),
//                     5.heightBox,
//                     Divider(color: Colors.black26,),
//                     5.heightBox,
//                     InkWell(
//                       onTap: onGalleryTap,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.photo_camera_back_outlined,
//                               color: AppColors.primaryColor,),
//                             "Gallery".style.w513
//                                 .lineHeight(1.3)
//                                 .center
//                                 .make()
//                                 .kpLeft(16.w),
//                           ]
//                       ).kpLR(26.w),
//                     ),
//
//
//                     100.heightBox
//
//                   ],
//                 )
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void showFilterBy() {
//     final ScrollController _scrollController = ScrollController();
//
//     final List<String> filters = const [
//       'Nearest Coupon',
//       'Trending Coupon',
//       'Highest Discount',
//     ];
//     // Get.bottomSheet(
//     //   Container(
//     //     decoration: BoxDecoration(
//     //       color: Colors.transparent,
//     //       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//     //     ),
//     //     child: Column(
//     //       mainAxisSize: MainAxisSize.min,
//     //       children: [
//     //         CustomImageView(
//     //           imagePath: "assets/onb/white_curve_container.svg",
//     //           width: Get.width,
//     //         ),
//     //
//     //         // DraggableScrollableSheet
//     //         Expanded(
//     //           child: DraggableScrollableSheet(
//     //             initialChildSize: 0.85, // jitna by default khula rahe
//     //             minChildSize: 0.3,      // minimum height
//     //             maxChildSize: 0.95,     // maximum height
//     //             expand: false,
//     //             builder: (context, scrollController) {
//     //               return Container(
//     //                 decoration: BoxDecoration(
//     //                   color: Colors.white,
//     //                   borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//     //                 ),
//     //                 child: ListView(
//     //                   controller: scrollController, // important!
//     //                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//     //                   children: [
//     //                     SizedBox(width: Get.width),
//     //                     "Filter By".style.w620.lineHeight(1.3).center.make(),
//     //                     "Show coupon by".style.w512.make(),
//     //
//     //                     SizedBox(height: 10.h),
//     //                     Container(
//     //                       width: double.infinity,
//     //                       // color: Colors.red,
//     //                       child: Obx(() =>
//     //                           Wrap(
//     //                             spacing: 12.w,
//     //                             runSpacing: 12.h,
//     //                             children: List.generate(filters.length, (index) {
//     //                               final isSelected = Get.find<SearchController1>().selectedFilterIndex
//     //                                   .value == index;
//     //                               return GestureDetector(
//     //                                 onTap: () => Get.find<SearchController1>().selectFilter(index),
//     //                                 child: Container(
//     //                                   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//     //                                   decoration: BoxDecoration(
//     //                                     // color: isSelected ? Colors.green : Colors.white,
//     //                                     gradient: LinearGradient(
//     //                                       begin: Alignment.topCenter,
//     //                                       end: Alignment.bottomCenter,
//     //                                       colors:
//     //                                       !isSelected == true
//     //                                           ? [Colors.transparent, Colors.transparent]
//     //                                           : [
//     //                                         const Color.fromRGBO(72, 210, 14, 1),
//     //                                         const Color.fromRGBO(66, 179, 17, 1),
//     //                                       ],
//     //                                     ),
//     //                                     border: Border.all(
//     //                                         color: isSelected
//     //                                             ? Colors.transparent
//     //                                             : Color.fromRGBO(35, 35, 35, 0.1),
//     //                                         width: 1.4
//     //                                     ),
//     //                                     borderRadius: BorderRadius.circular(30.r),
//     //                                   ),
//     //
//     //                                   child: Text(
//     //                                     filters[index],
//     //                                     style: TextStyle(
//     //                                       fontSize: 12.sp,
//     //                                       color: isSelected
//     //                                           ? Colors.white
//     //                                           : Color.fromRGBO(35, 35, 35, .5),
//     //                                       fontWeight: FontWeight.w400,
//     //                                     ),
//     //                                   ),
//     //                                 ),
//     //                               );
//     //                             }),
//     //                           )),
//     //                     ),
//     //
//     //
//     //                     SizedBox(height: 30.h),
//     //
//     //                     // Distance Range
//     //                     Row(
//     //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                       children: [
//     //                         "Select Distance Range".style.w512.make(),
//     //                         "0-100 Miles".style.w412.color(AppColors.primaryColor).make(),
//     //
//     //                       ],
//     //                     ),
//     //                     SizedBox(height: 15.h),
//     //                     Obx(() =>
//     //                         Slider(
//     //                           value: Get.find<SearchController1>().distanceRange.value,
//     //                           min: 0,
//     //                           max: 100,
//     //                           padding: EdgeInsets.zero,
//     //                           activeColor: AppColors.primaryColor,
//     //                           inactiveColor: Colors.grey.shade300,
//     //                           onChanged: (value) {
//     //                             Get.find<SearchController1>().distanceRange.value = value;
//     //                           },
//     //                         ).kpRight(10.w)),
//     //                     Obx(() =>
//     //                         Align(
//     //                           alignment: Alignment.centerRight,
//     //                           child: Text(
//     //                             "${Get.find<SearchController1>().distanceRange.value.toInt()} Miles",
//     //                             style: TextStyle(
//     //                               fontSize: 14.sp,
//     //                               color: const Color.fromRGBO(72, 210, 14, 1),
//     //                               fontWeight: FontWeight.w600,
//     //                             ),
//     //                           ),
//     //                         )),
//     //
//     //                     SizedBox(height: 20.h),
//     //
//     //                     "By Review & Rating".style.w512.make(),
//     //                     SizedBox(height: 20.h),
//     //                     Obx(() =>
//     //                         Column(
//     //                           children: List.generate(5, (index) {
//     //                             final rating = 5 - index;
//     //                             final isSelected =
//     //                                 Get.find<SearchController1>().selectedRating.value == rating;
//     //
//     //                             return GestureDetector(
//     //                               onTap: () => Get.find<SearchController1>().selectedRating.value = rating,
//     //                               child: Padding(
//     //                                 padding: EdgeInsets.symmetric(vertical: 6.h),
//     //                                 child: Row(
//     //                                   children: [
//     //                                     Container(
//     //                                       width: 26.w,
//     //                                       height: 26.w,
//     //                                       decoration: BoxDecoration(
//     //                                           shape: BoxShape.circle,
//     //
//     //                                           color: isSelected
//     //                                               ? const Color.fromRGBO(72, 210, 14, 1)
//     //                                               : const Color.fromRGBO(
//     //                                               72, 210, 14, .3)
//     //                                       ),
//     //                                       child: isSelected
//     //                                           ? const Icon(Icons.check,
//     //                                           color: Colors.white, size: 14)
//     //                                           : null,
//     //                                     ),
//     //                                     SizedBox(width: 12.w),
//     //                                     Row(
//     //                                       children: List.generate(5, (i) {
//     //                                         return Icon(
//     //                                           i < rating
//     //                                               ? Icons.star
//     //                                               : Icons.star_border,
//     //                                           color: const Color.fromRGBO(
//     //                                               255, 168, 0, 1), // orange star
//     //                                           size: 20.sp,
//     //                                         );
//     //                                       }),
//     //                                     ),
//     //                                     SizedBox(width: 8.w),
//     //                                     "$rating Star Rating".style.w410.color(
//     //                                         Color.fromRGBO(30, 30, 30, 1)).make(),
//     //
//     //                                   ],
//     //                                 ),
//     //                               ),
//     //                             );
//     //                           }),
//     //                         )),
//     //
//     //                     SizedBox(height: 30.h),
//     //
//     //                     "By Discount Percentage".style.w512.make(),
//     //
//     //                     SizedBox(height: 10.h),
//     //
//     //                     // Dropdown (Placeholder style)
//     //                     InkWell(onTap: () {
//     //                       Get.find<SearchController1>().showDiscountOptions.value =
//     //                       !Get.find<SearchController1>().showDiscountOptions.value;
//     //                     },
//     //                       child: Container(
//     //                         padding: EdgeInsets.symmetric(
//     //                             horizontal: 16.w, vertical: 12.h),
//     //                         decoration: BoxDecoration(
//     //                           color: Colors.grey.shade100,
//     //                           borderRadius: BorderRadius.circular(30.r),
//     //                         ),
//     //                         child: Row(
//     //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                           children: [
//     //                             Text(
//     //                               "Discount",
//     //                               style: TextStyle(
//     //                                 fontSize: 14.sp,
//     //                                 color: Colors.grey,
//     //                               ),
//     //                             ),
//     //                             Icon(Icons.keyboard_arrow_down_rounded,
//     //                                 color: Colors.grey, size: 22.sp),
//     //                           ],
//     //                         ),
//     //                       ),
//     //                     ),
//     //                     Obx(() =>
//     //                     Get.find<SearchController1>().showDiscountOptions.value
//     //                         ? Column(
//     //                       crossAxisAlignment: CrossAxisAlignment.start,
//     //                       children: [
//     //                         SizedBox(height: 10.h),
//     //                         ...[50, 40, 30, 20, 10].map((val) {
//     //                           return Obx(() =>
//     //                               CheckboxListTile(
//     //                                 contentPadding: EdgeInsets.zero,
//     //                                 title: Text("$val% or more",
//     //                                     style: TextStyle(fontSize: 14.sp)),
//     //                                 value: Get.find<SearchController1>().selectedDiscounts.contains(val),
//     //                                 onChanged: (_) {
//     //                                   Get.find<SearchController1>().showDiscountOptions.value = !Get.find<SearchController1>().showDiscountOptions.value;
//     //                                   Get.find<SearchController1>().toggleDiscountOption(val);
//     //                                 },
//     //
//     //                                 activeColor: Colors.green,
//     //                                 controlAffinity: ListTileControlAffinity.leading,
//     //                               ));
//     //                         }).toList(),
//     //                       ],
//     //                     )
//     //                         : SizedBox.shrink()),
//     //                     SizedBox(height: 20.h),
//     //
//     //                     // Selected Discount Tags
//     //                     Obx(() {
//     //                       return Wrap(
//     //                         spacing: 10.w,
//     //                         runSpacing: 10.h,
//     //                         children: Get.find<SearchController1>().selectedDiscounts.map((discount) {
//     //                           return InkWell(onTap: () {
//     //                             Get.find<SearchController1>().removeDiscount(discount);
//     //                           },
//     //                             child: Container(
//     //                               padding:
//     //                               EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//     //                               decoration: BoxDecoration(
//     //                                 color: const Color.fromRGBO(72, 210, 14, 1),
//     //                                 borderRadius: BorderRadius.circular(20.r),
//     //                               ),
//     //                               child: Row(
//     //                                 mainAxisSize: MainAxisSize.min,
//     //                                 children: [
//     //                                   "$discount%".style.w413.color(Colors.white).make(),
//     //
//     //                                   SizedBox(width: 6.w),
//     //                                   Icon(
//     //                                     Icons.close,
//     //                                     size: 16.sp,
//     //                                     color: Colors.white,
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             ),
//     //                           );
//     //                         }).toList(),
//     //                       );
//     //                     }),
//     //
//     //                     SizedBox(height: 30.h),
//     //                     CustomButton(text: "Apply Filter", onPressed: () {
//     //                       Get.back();
//     //                     },),
//     //
//     //                     SizedBox(height: 40.h),
//     //
//     //                   ],
//     //                 ),
//     //               );
//     //             },
//     //           ),
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     //   isScrollControlled: true,
//     //   backgroundColor: Colors.transparent,
//     // );
//
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//
//
//             Container(
//               height: Get.height * .85,
//               color: Colors.white,
//               child: NotificationListener<ScrollNotification>(
//                 onNotification: (notification) {
//                   if (notification is OverscrollNotification) {
//                     // check if ListView top par hai
//                     if (notification.metrics.pixels <=
//                         notification.metrics.minScrollExtent) {
//                       // agar user neeche kheench raha hai
//                       if (notification.overscroll < -10) {
//                         // ðŸ‘‡ Ab sheet close hoga
//                         Get.back();
//                       }
//                     }
//                   }
//                   return false;
//                 },
//                 child: ListView(
//                   controller: _scrollController,
//                   // agar aap DraggableScrollableSheet use kar rahe ho
//                   children: [
//                     SizedBox(width: Get.width,),
//                     "Filter By".style.w620
//                         .lineHeight(1.3)
//                         .center
//                         .make(),
//                     "Show coupon by".style.w512.make(),
//                     SizedBox(height: 10.h),
//                     Container(
//                       width: double.infinity,
//                       // color: Colors.red,
//                       child: Obx(() =>
//                           Wrap(
//                             spacing: 12.w,
//                             runSpacing: 12.h,
//                             children: List.generate(filters.length, (index) {
//                               final isSelected = Get
//                                   .find<SearchController1>()
//                                   .selectedFilterIndex
//                                   .value == index;
//                               return GestureDetector(
//                                 onTap: () =>
//                                     Get.find<SearchController1>().selectFilter(
//                                         index),
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 15.w, vertical: 10.h),
//                                   decoration: BoxDecoration(
//                                     // color: isSelected ? Colors.green : Colors.white,
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors:
//                                       !isSelected == true
//                                           ? [
//                                         Colors.transparent,
//                                         Colors.transparent
//                                       ]
//                                           : [
//                                         const Color.fromRGBO(72, 210, 14, 1),
//                                         const Color.fromRGBO(66, 179, 17, 1),
//                                       ],
//                                     ),
//                                     border: Border.all(
//                                         color: isSelected
//                                             ? Colors.transparent
//                                             : Color.fromRGBO(35, 35, 35, 0.1),
//                                         width: 1.4
//                                     ),
//                                     borderRadius: BorderRadius.circular(30.r),
//                                   ),
//
//                                   child: Text(
//                                     filters[index],
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: isSelected
//                                           ? Colors.white
//                                           : Color.fromRGBO(35, 35, 35, .5),
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           )),
//                     ),
//
//
//                     SizedBox(height: 30.h),
//
//                     // Distance Range
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         "Select Distance Range".style.w512.make(),
//                         "0-100 Miles".style.w412
//                             .color(AppColors.primaryColor)
//                             .make(),
//
//                       ],
//                     ),
//                     SizedBox(height: 15.h),
//                     Obx(() =>
//                         Slider(
//                           value: Get
//                               .find<SearchController1>()
//                               .distanceRange
//                               .value,
//                           min: 0,
//                           max: 100,
//                           padding: EdgeInsets.zero,
//                           activeColor: AppColors.primaryColor,
//                           inactiveColor: Colors.grey.shade300,
//                           onChanged: (value) {
//                             Get
//                                 .find<SearchController1>()
//                                 .distanceRange
//                                 .value = value;
//                           },
//                         ).kpRight(10.w)),
//                     Obx(() =>
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Text(
//                             "${Get
//                                 .find<SearchController1>()
//                                 .distanceRange
//                                 .value
//                                 .toInt()} Miles",
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: const Color.fromRGBO(72, 210, 14, 1),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         )),
//
//                     SizedBox(height: 20.h),
//
//                     "By Review & Rating".style.w512.make(),
//                     SizedBox(height: 20.h),
//                     Obx(() =>
//                         Column(
//                           children: List.generate(5, (index) {
//                             final rating = 5 - index;
//                             final isSelected =
//                                 Get
//                                     .find<SearchController1>()
//                                     .selectedRating
//                                     .value == rating;
//
//                             return GestureDetector(
//                               onTap: () =>
//                               Get
//                                   .find<SearchController1>()
//                                   .selectedRating
//                                   .value = rating,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 6.h),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 26.w,
//                                       height: 26.w,
//                                       decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//
//                                           color: isSelected
//                                               ? const Color.fromRGBO(
//                                               72, 210, 14, 1)
//                                               : const Color.fromRGBO(
//                                               72, 210, 14, .3)
//                                       ),
//                                       child: isSelected
//                                           ? const Icon(Icons.check,
//                                           color: Colors.white, size: 14)
//                                           : null,
//                                     ),
//                                     SizedBox(width: 12.w),
//                                     Row(
//                                       children: List.generate(5, (i) {
//                                         return Icon(
//                                           i < rating
//                                               ? Icons.star
//                                               : Icons.star_border,
//                                           color: const Color.fromRGBO(
//                                               255, 168, 0, 1), // orange star
//                                           size: 20.sp,
//                                         );
//                                       }),
//                                     ),
//                                     SizedBox(width: 8.w),
//                                     "$rating Star Rating".style.w410.color(
//                                         Color.fromRGBO(30, 30, 30, 1)).make(),
//
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                         )),
//
//                     SizedBox(height: 30.h),
//
//                     "By Discount Percentage".style.w512.make(),
//
//                     SizedBox(height: 10.h),
//
//                     // Dropdown (Placeholder style)
//                     InkWell(onTap: () {
//                       Get
//                           .find<SearchController1>()
//                           .showDiscountOptions
//                           .value =
//                       !Get
//                           .find<SearchController1>()
//                           .showDiscountOptions
//                           .value;
//                     },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 16.w, vertical: 12.h),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Discount",
//                               style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             Icon(Icons.keyboard_arrow_down_rounded,
//                                 color: Colors.grey, size: 22.sp),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Obx(() =>
//                     Get
//                         .find<SearchController1>()
//                         .showDiscountOptions
//                         .value
//                         ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 10.h),
//                         ...[50, 40, 30, 20, 10].map((val) {
//                           return Obx(() =>
//                               CheckboxListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 title: Text("$val% or more",
//                                     style: TextStyle(fontSize: 14.sp)),
//                                 value: Get
//                                     .find<SearchController1>()
//                                     .selectedDiscounts
//                                     .contains(val),
//                                 onChanged: (_) {
//                                   Get
//                                       .find<SearchController1>()
//                                       .showDiscountOptions
//                                       .value = !Get
//                                       .find<SearchController1>()
//                                       .showDiscountOptions
//                                       .value;
//                                   Get
//                                       .find<SearchController1>()
//                                       .toggleDiscountOption(val);
//                                 },
//
//                                 activeColor: Colors.green,
//                                 controlAffinity: ListTileControlAffinity
//                                     .leading,
//                               ));
//                         }).toList(),
//                       ],
//                     )
//                         : SizedBox.shrink()),
//                     SizedBox(height: 20.h),
//
//                     // Selected Discount Tags
//                     Obx(() {
//                       return Wrap(
//                         spacing: 10.w,
//                         runSpacing: 10.h,
//                         children: Get
//                             .find<SearchController1>()
//                             .selectedDiscounts
//                             .map((discount) {
//                           return InkWell(onTap: () {
//                             Get.find<SearchController1>().removeDiscount(
//                                 discount);
//                           },
//                             child: Container(
//                               padding:
//                               EdgeInsets.symmetric(
//                                   horizontal: 14.w, vertical: 8.h),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(72, 210, 14, 1),
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   "$discount%".style.w413
//                                       .color(Colors.white)
//                                       .make(),
//
//                                   SizedBox(width: 6.w),
//                                   Icon(
//                                     Icons.close,
//                                     size: 16.sp,
//                                     color: Colors.white,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     }),
//
//                     SizedBox(height: 30.h),
//                     CustomButton(text: "Apply Filter", onPressed: () {
//                       Get.back();
//                     },),
//
//                     SizedBox(height: 40.h),
//
//
//                   ],
//                 ),
//               ).kpLR(20.w),
//             )
//
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
// // utils/ticket_utils.dart
//   static Future<bool?> createNewTicket() async {
//     TextEditingController titleController = TextEditingController();
//     TextEditingController descriptionController = TextEditingController();
//     final selectedPriority = "Low".obs;
//     final createTicketFormKey = GlobalKey<FormState>();
//     final isLoading = false.obs;
//
//     // Bottom sheet as Future
//     return await Get.bottomSheet<bool>(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(
//               imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,
//             ),
//             Container(
//               color: Colors.white,
//               child: Form(
//                 key: createTicketFormKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     10.heightBox,
//                     "Create New Ticket".style.w620
//                         .lineHeight(1.3)
//                         .center
//                         .make()
//                         .kpLR(26.w),
//                     20.heightBox,
//                     Row(
//                       children: ["Priority".style.w514
//                           .lineHeight(1.3)
//                           .center
//                           .make()
//                       ],
//                     ),
//                     10.heightBox,
//                     Obx(() {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: ["Low", "Medium", "High"].map((priority) {
//                           final isSelected = selectedPriority.value == priority;
//
//                           Color bgColor;
//                           Color textColor = Colors.white;
//                           switch (priority) {
//                             case "High":
//                               bgColor =
//                               isSelected ? Colors.red : Colors.red.shade100;
//                               textColor =
//                               isSelected ? Colors.white : Colors.red.shade800;
//                               break;
//                             case "Medium":
//                               bgColor =
//                               isSelected ? Colors.orange : Colors.orange
//                                   .shade100;
//                               textColor =
//                               isSelected ? Colors.white : Colors.orange
//                                   .shade800;
//                               break;
//                             default:
//                               bgColor =
//                               isSelected ? Colors.green : Colors.green.shade100;
//                               textColor =
//                               isSelected ? Colors.white : Colors.green.shade800;
//                           }
//
//                           return GestureDetector(
//                             onTap: () => selectedPriority.value = priority,
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 250),
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: bgColor,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: isSelected
//                                     ? [
//                                   BoxShadow(
//                                     color: bgColor.withOpacity(0.4),
//                                     offset: const Offset(0, 3),
//                                     blurRadius: 6,
//                                   )
//                                 ]
//                                     : [],
//                               ),
//                               child: Text(
//                                 priority,
//                                 style: TextStyle(
//                                   color: textColor,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ).paddingOnly(right: 10),
//                           );
//                         }).toList(),
//                       );
//                     }),
//                     40.heightBox,
//                     CustomTextField(
//                       controller: titleController, hintText: "Title here",
//                       formKey: createTicketFormKey,
//                       validator: Validator.validatTitle,
//                     ),
//                     24.heightBox,
//                     CustomTextField(
//                       controller: descriptionController,
//                       hintText: "Description",
//                       maxLines: 5,
//                       formKey: createTicketFormKey,
//                       validator: Validator.validatDescription,
//                     ),
//                     24.heightBox,
//                     Obx(() {
//                       return CustomButton(
//                         text: "Submit",
//                         isLoading: isLoading.value,
//                         onPressed: () async {
//                           if (createTicketFormKey.currentState!.validate()) {
//                             isLoading.value = true;
//                             bool isCreated = await ApiRepository.create_ticket(
//                               title: titleController.text,
//                               description: descriptionController.text,
//                               priority: selectedPriority.value,
//                             );
//                             isLoading.value = false;
//                             if (isCreated) {
//                               Get.back(result: true); // <-- pass result back
//                               AppDialog.showToast(
//                                   "Ticket created successfully");
//                             } else {
//                               AppDialog.showToast("Failed to create ticket");
//                             }
//                           }
//                         },
//                       );
//                     }),
//                     40.heightBox
//                   ],
//                 ).paddingSymmetric(horizontal: 26),
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void codeIsNotValid({
//     required TextEditingController referralOtpController,
//   }) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Code is not valid.\nPlease enter again.".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Re-enter", onPressed: () {
//                     referralOtpController.clear();
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//   static void earnedBonus({
//     required TextEditingController referralOtpController,
//   }) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Congratulations! You\nearned 50 bonus points".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Continue", onPressed: () {
//                     Get.back();
//                     Get.to(() => AccountCreatedView());
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: false, // ðŸ‘ˆ user outside tap se close nahi kar paayega
//       enableDrag: false,
//     );
//   }
//
//
//   static void showRedeemDialog() {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "Are you sure you want\nto Make Payment".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem ipsum is simple dummy text that can goes under till that can your people kill to wrong on people can gide so also till that so it has"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(text: "Yes", onPressed: () {
//                           Get.back();
//                         },),
//                       ),
//                       12.widthBox,
//                       Expanded(
//                         child: CustomButton(text: "No", onPressed: () {
//                           Get.back();
//                         }, isOutlined: true,),
//                       ),
//                     ],
//                   ),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//
//   static void showCustomMSG({required String title, required String msg}) {
//     Get.bottomSheet(
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomImageView(imagePath: "assets/onb/white_curve_container.svg",
//               width: Get.width,),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   12.heightBox,
//                   "${title}".style.w620
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   12.heightBox,
//                   "Lorem Ipsum is simply dummy text of the Ipsum is simply also that can on that dummy text"
//                       .style.w312
//                       .color(Color.fromRGBO(35, 35, 35, 0.5))
//                       .lineHeight(1.3)
//                       .center
//                       .make(),
//                   24.heightBox,
//                   CustomButton(text: "Continue", onPressed: () {
//                     Get.back();
//                   },),
//                   40.heightBox
//
//                 ],
//               ).kpLR(26.w),
//             ),
//
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
//
//
// }
//
// TableRow _buildRow(String label, String value) {
//   return TableRow(
//     children: [
//       label.style.w311.lineHeight(1.5).make().kpLeft(16.w).kpTB(10),
//       value.style.w511
//           .color(Color.fromRGBO(32, 97, 4, 1))
//           .lineHeight(1.5)
//           .make()
//           .kpLeft(16.w)
//           .kpTB(10),
//
//     ],
//   );
// }
//
// TableRow _buildRowBold(String label, String value) {
//   return TableRow(
//     children: [
//       label.style.w613.lineHeight(1.5).make().kpLeft(16.w).kpTB(10),
//       value.style.w613
//           .color(Color.fromRGBO(32, 97, 4, 1))
//           .lineHeight(1.5)
//           .make()
//           .kpLeft(16.w)
//           .kpTB(10),
//
//     ],
//   );
// }
//
//
// class AccessPlanCard extends StatelessWidget {
//   final bool isSelected;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//
//   const AccessPlanCard({
//     super.key,
//     required this.isSelected,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 58.h,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         decoration: isSelected
//             ? BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromRGBO(72, 210, 14, 1),
//               Color.fromRGBO(66, 179, 17, 1),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(10),
//         )
//             : ShapeDecoration(
//           color: const Color(0x1944C10F),
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(
//               width: 1.20,
//               strokeAlign: BorderSide.strokeAlignCenter,
//               color: Color(0x331F6104),
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(mainAxisSize: MainAxisSize.max, children: []),
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : const Color(0xFF232323),
//                 fontSize: 14.spMax,
//                 fontWeight: FontWeight.w500,
//                 height: 1.07,
//               ),
//             ),
//             5.heightBox,
//             Opacity(
//               opacity: isSelected ? 0.60 : 0.40,
//               child: Text(
//                 subtitle,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : const Color(0xFF232323),
//                   fontSize: 12.spMax,
//                   fontWeight: FontWeight.w400,
//                   height: 1.17,
//                 ),
//               ),
//             ),
//           ],
//         ).paddingOnly(left: 10),
//       ),
//     ).kpLR(26.w);
//   }
//
//
// }
//

