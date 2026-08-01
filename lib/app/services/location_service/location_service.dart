// import 'package:my_app/app/core/const/app_colors.dart';
// import 'package:my_app/app/core/const/export.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// Future<Position?> getUserLocation(BuildContext context) async {
//   LocationPermission permission;
//
//
//
//   // âœ… Check permission
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     print("Location permission permanently denied._line_23");
//     return null;
//   }
//
//   // âœ… Get current position (once)
//   return await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );
// }
//
// void showPermissionDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (ctx) => AlertDialog(
//       title: const Text("Permission Required"),
//       content: const Text(
//           "Location permission is permanently denied.\n\nPlease enable it in Settings to continue."),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(ctx).pop(),
//           child: const Text("Cancel"),
//         ),
//         InkWell(onTap: () async {
//               Navigator.of(ctx).pop();
//               await openAppSettings();
//         },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5.r),
//               color: AppColors.primaryColor,
//             ),
//             child: Padding(
//               padding:  EdgeInsets.symmetric(horizontal: 10.r,vertical: 8.r),
//               child: Text("Open Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
//

