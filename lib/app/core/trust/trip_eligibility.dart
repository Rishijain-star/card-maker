import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_pages.dart';
import '../../services/local_storage_services/local_storage_services.dart';

/// Host-side rules: vehicle registration required for trip flows.
class TripEligibility {
  TripEligibility._();

  static bool get hasRegisteredVehicle {
    final p = LocalStorageService().getVehicleRegistrationPlate().trim();
    return p.length >= 4;
  }

  static Future<void> showVehicleRequiredSheet({required bool forDriver}) async {
    await Get.bottomSheet<void>(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                forDriver ? 'Register your vehicle' : 'Vehicle registration required',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF163A5F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                forDriver
                    ? 'For safety and traceability, add your license plate in My garage before publishing a trip.'
                    : 'To join rides as a verified traveler, add your vehicle registration in My garage first.',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  height: 1.45,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back<void>();
                    Get.toNamed<void>(Routes.MY_GARAGE);
                  },
                  child: const Text('Open My garage'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
