import 'package:shared_preferences/shared_preferences.dart';
import '../secure_token_service/secure_token_service.dart';

class LocalStorageService {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // ===================== AUTH & USER =====================
  Future<void> setAuthToken(String token) =>
      sharedPreferences!.setString('authToken', token);
  String getAuthToken() => sharedPreferences!.getString('authToken') ?? '';

  Future<void> setUserId(String id) =>
      sharedPreferences!.setString('userId', id);
  String getUserId() => sharedPreferences!.getString('userId') ?? '';

  Future<void> setUserName(String name) =>
      sharedPreferences!.setString('userName', name);
  String getUserName() => sharedPreferences!.getString('userName') ?? '';
  Future<void> setFirstName(String firstName) =>
      sharedPreferences!.setString('firstName', firstName);
  String getFirstName() => sharedPreferences!.getString('firstName') ?? '';
  Future<void> setLastName(String lastName) =>
      sharedPreferences!.setString('lastName', lastName);
  String getLastName() => sharedPreferences!.getString('lastName') ?? '';

  Future<void> setEmailId(String email) =>
      sharedPreferences!.setString('userEmail', email);
  String getEmailId() => sharedPreferences!.getString('userEmail') ?? '';

  Future<void> setIsOnboardingCompleted(bool value) =>
      sharedPreferences!.setBool('isOnboardingCompleted', value);
  bool getIsOnboardingCompleted() =>
      sharedPreferences!.getBool('isOnboardingCompleted') ?? false;
  Future<void> setHasSeenSplash(bool value) =>
      sharedPreferences!.setBool('hasSeenSplash', value);
  bool getHasSeenSplash() =>
      sharedPreferences!.getBool('hasSeenSplash') ?? false;

  // ===================== LOCATION =====================
  Future<void> setLatitude(String lat) =>
      sharedPreferences!.setString('latitude', lat);
  String? getLatitude() => sharedPreferences!.getString('latitude');

  Future<void> setLongitude(String lng) =>
      sharedPreferences!.setString('longitude', lng);
  String? getLongitude() => sharedPreferences!.getString('longitude');

  Future<void> setAddress(String address) =>
      sharedPreferences!.setString('address', address);
  String? getAddress() => sharedPreferences!.getString('address');

  Future<void> setCountry(String country) =>
      sharedPreferences!.setString('country', country);
  String getCountry() => sharedPreferences!.getString('country') ?? '';
  Future<void> clearCountry() async {
    await sharedPreferences!.remove('country');
  }

  Future<void> setCity(String country) =>
      sharedPreferences!.setString('setCity', country);
  String getCity() => sharedPreferences!.getString('setCity') ?? '';

  Future<void> setPostalCode(String code) =>
      sharedPreferences!.setString('postalCode', code);
  String getPostalCode() => sharedPreferences!.getString('postalCode') ?? '';

  Future<void> setState(String setState) =>
      sharedPreferences!.setString('setState', setState);
  String getState() => sharedPreferences!.getString('setState') ?? '';

  // ===================== LOGIN STATUS =====================
  bool isLoggedIn() => getAuthToken().isNotEmpty;

  /// `driver` | `passenger` — empty means treat as passenger for legacy sessions.
  Future<void> setUserRole(String role) =>
      sharedPreferences!.setString('userRole', role);
  String getUserRole() => sharedPreferences!.getString('userRole') ?? '';

  /// Shown on driver home (e.g. "Toyota Innova (White)").
  Future<void> setDriverVehicleSummary(String value) =>
      sharedPreferences!.setString('driverVehicleSummary', value);
  String getDriverVehicleSummary() =>
      sharedPreferences!.getString('driverVehicleSummary') ??
      'Toyota Innova (White)';

  Future<void> setDriverSeatDisplay(String value) =>
      sharedPreferences!.setString('driverSeatDisplay', value.trim());
  String getDriverSeatDisplay() =>
      sharedPreferences!.getString('driverSeatDisplay') ?? '6';

  // ===================== THEME & LANGUAGE =====================
  Future<void> setThemeMode(String mode) =>
      sharedPreferences!.setString('themeMode', mode);
  String getThemeMode() =>
      sharedPreferences!.getString('themeMode') ?? 'system';
  Future<void> setLanguageCode(String code) =>
      sharedPreferences!.setString('languageCode', code);
  String getLanguageCode() =>
      sharedPreferences!.getString('languageCode') ?? 'en';

  // ===================== LOGOUT =====================
  Future<void> logout() async {
    await sharedPreferences!.clear();
    await SecureTokenService().clearToken();
  }

  // ===================== TRUST & COMPLIANCE (demo-persisted) =====================
  Future<void> setLegalGateAccepted(bool value) =>
      sharedPreferences!.setBool('legalGateAccepted', value);
  bool getLegalGateAccepted() =>
      sharedPreferences!.getBool('legalGateAccepted') ?? false;

  Future<void> setVehicleRegistrationPlate(String plate) =>
      sharedPreferences!.setString('vehicleRegistrationPlate', plate.trim());
  String getVehicleRegistrationPlate() =>
      sharedPreferences!.getString('vehicleRegistrationPlate') ?? '';

  Future<void> setProfilePhotoPath(String path) =>
      sharedPreferences!.setString('profilePhotoPath', path);
  String getProfilePhotoPath() =>
      sharedPreferences!.getString('profilePhotoPath') ?? '';

  Future<void> setSelfieVerificationPaths(String pathsCsv) =>
      sharedPreferences!.setString('selfieVerificationPaths', pathsCsv);
  String getSelfieVerificationPaths() =>
      sharedPreferences!.getString('selfieVerificationPaths') ?? '';

  Future<void> setSelfieVerified(bool value) =>
      sharedPreferences!.setBool('selfieVerified', value);
  bool getSelfieVerified() => sharedPreferences!.getBool('selfieVerified') ?? false;

  Future<void> setBillingCountryCode(String code) =>
      sharedPreferences!.setString('billingCountryCode', code.toUpperCase());
  String getBillingCountryCode() =>
      sharedPreferences!.getString('billingCountryCode') ?? 'SE';

  Future<void> setAppUnlockPaid(bool value) =>
      sharedPreferences!.setBool('appUnlockPaid', value);
  bool getAppUnlockPaid() => sharedPreferences!.getBool('appUnlockPaid') ?? false;

  Future<void> setDriverAnnouncementCredits(int n) =>
      sharedPreferences!.setInt('driverAnnouncementCredits', n);
  int getDriverAnnouncementCredits() =>
      sharedPreferences!.getInt('driverAnnouncementCredits') ?? 0;

  // ===================== PAYOUT (demo-persisted) =====================
  Future<void> setPayoutSaved(bool value) =>
      sharedPreferences!.setBool('payoutSaved', value);
  bool getPayoutSaved() => sharedPreferences!.getBool('payoutSaved') ?? false;

  Future<void> setPayoutHolder(String v) =>
      sharedPreferences!.setString('payoutHolder', v.trim());
  String getPayoutHolder() => sharedPreferences!.getString('payoutHolder') ?? '';

  Future<void> setPayoutBankName(String v) =>
      sharedPreferences!.setString('payoutBankName', v.trim());
  String getPayoutBankName() => sharedPreferences!.getString('payoutBankName') ?? '';

  Future<void> setPayoutIban(String v) =>
      sharedPreferences!.setString('payoutIban', v.trim());
  String getPayoutIban() => sharedPreferences!.getString('payoutIban') ?? '';

  Future<void> setPayoutSwift(String v) =>
      sharedPreferences!.setString('payoutSwift', v.trim());
  String getPayoutSwift() => sharedPreferences!.getString('payoutSwift') ?? '';

  Future<void> setPayoutPaypalEmail(String v) =>
      sharedPreferences!.setString('payoutPaypalEmail', v.trim());
  String getPayoutPaypalEmail() => sharedPreferences!.getString('payoutPaypalEmail') ?? '';

  /// `bank` | `paypal`
  Future<void> setPayoutMethod(String v) =>
      sharedPreferences!.setString('payoutMethod', v.trim().toLowerCase());
  String getPayoutMethod() => sharedPreferences!.getString('payoutMethod') ?? 'bank';

  // ===================== SAVED DESIGNS =====================
  Future<void> setSavedDesignsJson(String json) =>
      sharedPreferences!.setString('savedDesignsJson', json);

  String getSavedDesignsJson() =>
      sharedPreferences!.getString('savedDesignsJson') ?? '';

  /// Legacy text-only saves (migrated away).
  Future<void> setSavedDesigns(List<String> designs) =>
      sharedPreferences!.setStringList('savedDesigns', designs);

  List<String> getSavedDesigns() =>
      sharedPreferences!.getStringList('savedDesigns') ?? <String>[];

  Future<void> setLifetimeSaveCount(int count) =>
      sharedPreferences!.setInt('lifetimeSaveCount', count);

  int getLifetimeSaveCount() =>
      sharedPreferences!.getInt('lifetimeSaveCount') ?? 0;

  Future<void> setIsPremium(bool value) =>
      sharedPreferences!.setBool('isPremium', value);

  bool getIsPremium() => sharedPreferences!.getBool('isPremium') ?? false;

  Future<void> setPremiumPlan(String plan) =>
      sharedPreferences!.setString('premiumPlan', plan);

  String getPremiumPlan() =>
      sharedPreferences!.getString('premiumPlan') ?? '';

  Future<void> setPremiumExpiresAt(String isoDate) =>
      sharedPreferences!.setString('premiumExpiresAt', isoDate);

  String getPremiumExpiresAt() =>
      sharedPreferences!.getString('premiumExpiresAt') ?? '';

  Future<void> setAccountSaveLimit(int limit) =>
      sharedPreferences!.setInt('accountSaveLimit', limit);

  int getAccountSaveLimit() =>
      sharedPreferences!.getInt('accountSaveLimit') ?? 5;

  Future<void> setAccountSavedCardsCount(int count) =>
      sharedPreferences!.setInt('accountSavedCardsCount', count);

  int getAccountSavedCardsCount() =>
      sharedPreferences!.getInt('accountSavedCardsCount') ?? 0;

  Future<void> setAccountRemainingCapacity(int remaining) =>
      sharedPreferences!.setInt('accountRemainingCapacity', remaining);

  int getAccountRemainingCapacity() =>
      sharedPreferences!.getInt('accountRemainingCapacity') ?? 5;

  // ===================== DRIVER PROFILE (demo-persisted) =====================
  Future<void> setUserPhone(String v) =>
      sharedPreferences!.setString('userPhone', v.trim());
  String getUserPhone() =>
      sharedPreferences!.getString('userPhone') ?? '+46 70 000 0000';

  Future<void> setDriverLicenseNumber(String v) =>
      sharedPreferences!.setString('driverLicenseNumber', v.trim());
  String getDriverLicenseNumber() =>
      sharedPreferences!.getString('driverLicenseNumber') ?? 'DL-SE-4829103';

  Future<void> setDriverLicenseExpiry(String isoDate) =>
      sharedPreferences!.setString('driverLicenseExpiry', isoDate.trim());
  String getDriverLicenseExpiry() =>
      sharedPreferences!.getString('driverLicenseExpiry') ?? '2031-04-18';

  Future<void> setVehicleColorDisplay(String v) =>
      sharedPreferences!.setString('vehicleColorDisplay', v.trim());
  String getVehicleColorDisplay() =>
      sharedPreferences!.getString('vehicleColorDisplay') ?? 'Black';

  Future<void> setVehiclePhotoPath(String v) =>
      sharedPreferences!.setString('vehiclePhotoPath', v.trim());
  String getVehiclePhotoPath() => sharedPreferences!.getString('vehiclePhotoPath') ?? '';
}

