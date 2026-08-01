// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
// abstract class LocationServices {
//   static Position? userLastCurrentPositionUpdateOnUpdateOnDb;
//   static ValueNotifier<Position?> userLastPosition = ValueNotifier<Position?>(null);
//
//   static Future<Position?> getCurrentPosition({bool forceRefresh = false}) async {
//     try {
//       try {
//         if (LocationServices.userLastCurrentPositionUpdateOnUpdateOnDb != null && forceRefresh == false) {
//           return LocationServices.userLastCurrentPositionUpdateOnUpdateOnDb;
//         }
//       } catch (e, s) {
//         print("line_20$e , $s");
//       }
//       Position? position;
//
//       position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       if (isSignificantChangeOnPosition(lat: position.latitude, lng: position.longitude)) {
//         _updateLastKnownPosition(position);
//       }
//       return position;
//     } catch (e, s) {
//       print("line_20$e , $s");
//     }
//     return null;
//   }
//
//   static double? calculateDistanceBetweenTwoPositionAndReturnDataKm(
//       {required num startLat, required num startLng, required num endLat, required num endLng}) {
//     try {
//       double toRadians(double degrees) => degrees * pi / 180;
//       num haversin(double radians) => pow(sin(radians / 2), 2);
//       const r = 6372.8; // Earth radius in kilometers
//
//       final dLat = toRadians(endLat.toDouble() - startLat.toDouble());
//       final dLon = toRadians(endLng.toDouble() - startLng.toDouble());
//
//       final lat1Radians = toRadians(startLat.toDouble());
//       final lat2Radians = toRadians(endLat.toDouble());
//
//       final a = haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * haversin(dLon);
//       final c = 2 * asin(sqrt(a));
//       return r * c;
//     } catch (e, s) {
//       print("line_20$e , $s");
//     }
//     return null;
//   }
//
//   static Future<String?> getCityNameFromLatLng({required double latitude, required double longitude}) async {
//     try {
//       List<Placemark> placeMarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );
//       return placeMarks.first.locality!;
//     } catch (e, s) {
//       print("line_20$e , $s");    }
//     return null;
//   }
//
//   static Future<StreamSubscription<Position>> deviceLiveLocation({required ValueNotifier<Position?> currentPositionNotifier}) async {
//     try {
//       userLastCurrentPositionUpdateOnUpdateOnDb = null;
//       const LocationSettings locationSettings = LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//
//       // Start listening to location updates
//       StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
//         try {
//           if (position != null) {
//             userLastPosition.value = position;
//             // Update location only if it has changed significantly
//             if (isSignificantChangeOnPosition(lat: position.latitude, lng: position.longitude)) {
//               currentPositionNotifier.value = position;
//               _updateLastKnownPosition(position);
//             }
//             // Update the last known position
//           }
//         } catch (e, s) {
//           // Log any errors that occur during processing
//           print("line_20$e , $s");        }
//       });
//
//       return positionStream;
//     } catch (e, s) {
//       // Log and rethrow any errors that occur during execution
//       print("line_20$e , $s");      rethrow;
//     }
//   }
//
// // Check if the new position indicates a significant change
//   static bool isSignificantChangeOnPosition({required num lat, required num lng, double thresholdDistanceKm = 0.1}) {
//     if (userLastCurrentPositionUpdateOnUpdateOnDb == null) {
//       return true;
//     }
//
//     double distance = calculateDistanceBetweenTwoPositionAndReturnDataKm(
//         startLat: userLastCurrentPositionUpdateOnUpdateOnDb!.latitude,
//         startLng: userLastCurrentPositionUpdateOnUpdateOnDb!.longitude,
//         endLat: lat,
//         endLng: lng) ??
//         1;
//
//     return distance > thresholdDistanceKm;
//   }
//
// // Update the last known position
//   static void _updateLastKnownPosition(Position newPosition) {
//     userLastCurrentPositionUpdateOnUpdateOnDb = newPosition;
//   }
// }
