// import 'package:my_app/app/core/const/export.dart';
// import 'package:my_app/app/services/location_service/update_location_controller.dart';
// import 'package:my_app/main.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../widgets/custom_image_view.dart';
// import 'location_service.dart';
//
// class LocaionAccepteView extends GetView<UpdateLocation> {
//   LocaionAccepteView({super.key});
//
//   UpdateLocation controller = Get.put(UpdateLocation());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             width: Get.width,
//             height: Get.height,
//             child: CustomImageView(
//               fit: BoxFit.cover,
//               imagePath: 'assets/splash.png',
//             ),
//           ),
//           Container(
//             height: Get.height,
//             width: Get.width,
//             child: Padding(
//               padding:  EdgeInsets.all(22.0.r),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//
//                   Text(
//                     "Please let us know\nWhere you are",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 32.r,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 16.h,),
//                   Text(
//                     "We use your current location to show nearby offers, and services around you. "
//                         "Your location helps us calculate the exact distance and display the most relevant coupons. "
//                         "Without location access, this feature will not work properly.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     "Tap on â€œI Acceptâ€ to give permission for accessing your location while using the app.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                       color: Colors.white,
//                     ),
//                   ),
//
//                   SizedBox(height: 16.h,),
//                   CustomImageView(
//                     height: 20.h,
//                     onTap: () {
//                     Get.toNamed(Routes.PRIVACY_STATEMENT);
//                     },
//                     imagePath: "assets/PRIVANCY_POCLIY.svg",
//                   ),
//                   SizedBox(height: 16.h,),
//
//                   InkWell(
//                     onTap: () async {
//                       isAccept.value = true;
//                       LocationPermission permission;
//
//                       // Pehle check karo
//                       permission = await Geolocator.checkPermission();
//                       isAccept.value = false;
//
//                       if (permission == LocationPermission.denied) {
//                         // Request karo
//                         permission = await Geolocator.requestPermission();
//
//                         if (permission == LocationPermission.denied) {
//                           print("User denied again");
//                           return;
//                         } else if (permission == LocationPermission.deniedForever) {
//                           print("User selected 'Don't ask again'");
//                           showPermissionDialog(Get.context!);
//                           return;
//                         } else {
//                           // ðŸ‘ˆ Yaha user ne abhi allow kar diya
//                           print("Permission granted after request");
//                           Position position = await Geolocator.getCurrentPosition();
//                           positionMainApp = position;
//                           await GlobalFunctions.getUserLoactionAndUpdate();
//                           Get.offAllNamed(Routes.LOGIN);
//                           return;
//                         }
//                       } else if (permission == LocationPermission.deniedForever) {
//                         print("Already deniedForever");
//                         showPermissionDialog(Get.context!);
//                         return;
//                       } else {
//                         // ðŸ‘ˆ Yaha pehle se hi allow tha
//                         print("Permission already granted");
//                         Position position = await Geolocator.getCurrentPosition();
//                         positionMainApp = position;
//                         await GlobalFunctions.getUserLoactionAndUpdate();
//                         Get.offAllNamed(Routes.LOGIN);
//                         return;
//                       }
//                     },
//
//                     // onTap: ()async {
//                     //   isAccept.value = true;
//                     //   LocationPermission permission;
//                     //   Position ?  position;
//                     //   permission = await Geolocator.checkPermission();
//                     //   isAccept.value = false;
//                     //   if (permission == LocationPermission.denied) {
//                     //     permission = await Geolocator.requestPermission();
//                     //
//                     //     if (permission == LocationPermission.denied) {
//                     //       print("User denied again");
//                     //     } else if (permission == LocationPermission.deniedForever) {
//                     //       print("User selected 'Don't ask again'");
//                     //       showPermissionDialog(Get.context!);
//                     //     }
//                     //   } else if (permission == LocationPermission.deniedForever) {
//                     //     print("Already deniedForever");
//                     //     showPermissionDialog(Get.context!);
//                     //   }else{
//                     //     print("getCurrentPosition");
//                     //     position =   await Geolocator.getCurrentPosition();
//                     //     positionMainApp = position;
//                     //     await  GlobalFunctions.getUserLoactionAndUpdate();
//                     //     Get.offAllNamed(Routes.LOGIN);
//                     //   }
//                     // },
//                     child: Container(height: 46.h,
//                       width: 318.w,
//                       decoration: BoxDecoration(
//                           color:AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       child: Obx(()=> Center(child: isAccept.value ? CircularProgressIndicator(color: Colors.white,) : Text("I Accept",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16.r),),),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16.h,),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   RxBool isAccept = false.obs;
// }
//
//
// class LocaionAccepteController extends GetxController {
//   //TODO: Implement LocaionAccepteController
//
//   final count = 0.obs;
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   void increment() => count.value++;
// }
