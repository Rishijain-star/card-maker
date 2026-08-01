// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
//
// import '../../../main.dart';
// import '../../global_functions/global_functions.dart';
// import '../utils/pref_utils.dart';
//
//
// class   GlobalFunctions{
//
//   static bool shouldShowBackButton(BuildContext context) {
//     return Navigator.canPop(context);
//   }
//
//   Future<bool> isInternetAvailable() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } on SocketException catch (_) {
//       return false;
//     }
//     return false;
//   }
//
//   String formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }
//
//   String durationToString(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";  // eg: "00:10:00"
//   }
//
//   String? timeOfDayToString(TimeOfDay ? time) {
//     if (time == null) return null;
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';  // eg: "15:30"
//   }
//
//
//   int getDurationInSeconds(Duration duration) {
//     return duration.inSeconds;
//   }
//
//   String formatTimeTo12Hour(String time24) {
//     // Parse string to DateTime
//     DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);
//
//     // Format to 12-hour time
//     return DateFormat.jm().format(dateTime); // output: 2:47 PM
//   }
//
//   String convertSeconds(int totalSeconds) {
//     Duration duration = Duration(seconds: totalSeconds);
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//
//     if (hours > 0 && minutes > 0) return '$hours HR $minutes MIN';
//     if (hours > 0) return '$hours HR';
//     return '$minutes MIN';
//   }
//   String formatToDateOnly(DateTime date) {
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }
//   static List<DateTime> getWeekDates(DateTime currentDate) {
//     int currentWeekday = currentDate.weekday; // Monday = 1, Sunday = 7
//     DateTime sunday = currentDate.subtract(Duration(days: currentWeekday % 7));
//     return List.generate(7, (index) => sunday.add(Duration(days: index)));
//   }
//
//   static Future<void> getUserLoactionAndUpdate() async {
//     try {
//       positionMainApp = await Geolocator.getCurrentPosition();
//       if(positionMainApp != null){
//         PrefUtils().setLatitude(positionMainApp?.latitude.toString() ?? "");
//         PrefUtils().setLongitude(positionMainApp?.longitude.toString() ?? "");
//         PrefUtils().setAddress(await getAddressFromLatLng(positionMainApp!));
//       }else{
//         print("line_61_positionMainApp postion_not_found_line_58");
//       }
//     }catch(e){
//       print("line_65_loaction_permisson_not_alllowed");
//     }
//
//   }
//   static Future<String> getAddressFromLatLng(Position position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         final placemark = placemarks.first;
//         return "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
//       } else {
//         return "No address found";
//       }
//     } catch (e) {
//       return "Error: $e";
//     }
//   }
//
// }
