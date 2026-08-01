// import 'package:my_app/app/core/const/export.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import '../../data/api_repository.dart';
//
// class UpdateLocation extends GetxController {
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//   }
//
//
//     // Position ? position1  ;
//     //  Future<void> updateLocation({required Position position}) async {
//     //    position1 = position;
//     //    var address = await getAddressFromLatLong(position.latitude, position.longitude);
//     //    // await ApiRepository.updateLatLong(latitude:position.latitude.toString(), longitude:position.longitude.toString(),address:address );
//     //
//     //  }
//
//   // Future<String> getAddressFromLatLong(double latitude, double longitude) async {
//   //   try {
//   //     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//   //     if (placemarks.isNotEmpty) {
//   //       Placemark place = placemarks.first;
//   //       print("latitude==>${position1?.latitude}");
//   //       print("latitude==>${position1?.longitude}");
//   //       print("place==>${place.country}");
//   //       PrefUtils().setCountry("${place.country}");
//   //       String address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//   //       return address;
//   //     } else {
//   //       return "Address not found";
//   //     }
//   //   } catch (e) {
//   //     return "Error: $e";
//   //   }
//   // }
//
// }
