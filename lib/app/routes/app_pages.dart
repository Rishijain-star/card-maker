import 'package:get/get.dart';

import '../modules/auth_screens/bindings/welcome_binding.dart';
import '../modules/auth_screens/views/welcome_view.dart';
import '../modules/create_flow/views/details_form_view.dart';
import '../modules/create_flow/views/live_customization_view.dart';
import '../modules/create_flow/views/live_preview_view.dart';
import '../modules/create_flow/views/my_designs_view.dart';
import '../modules/create_flow/views/save_design_view.dart';
import '../modules/create_flow/views/save_success_view.dart';
import '../modules/create_flow/views/premium_subscription_view.dart';
import '../modules/create_flow/views/subscription_view.dart';
import '../modules/create_flow/views/template_picker_view.dart';
import '../modules/id_templates/screens/template_preview_screen.dart';
import '../modules/legal/views/privacy_policy_screen.dart';
import '../modules/legal/views/terms_screen.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.WELCOME;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(name: _Paths.DETAILS_FORM, page: () => const DetailsFormView()),
    GetPage(name: _Paths.TEMPLATES, page: () => const TemplatePickerView()),
    GetPage(name: _Paths.TEMPLATE_PREVIEW, page: () => const TemplatePreviewScreen()),
    GetPage(name: _Paths.LIVE_CUSTOMIZE, page: () => const LiveCustomizationView()),
    GetPage(name: _Paths.LIVE_PREVIEW, page: () => const LivePreviewView()),
    GetPage(name: _Paths.SAVE_DESIGN, page: () => const SaveDesignView()),
    GetPage(name: _Paths.SAVE_SUCCESS, page: () => const SaveSuccessView()),
    GetPage(name: _Paths.MY_DESIGNS, page: () => const MyDesignsView()),
    GetPage(name: _Paths.SUBSCRIPTION, page: () => const SubscriptionView()),
    GetPage(name: _Paths.PREMIUM_SUBSCRIBE, page: () => const PremiumSubscriptionView()),
    GetPage(name: _Paths.TERMS, page: () => const TermsScreen()),
    GetPage(name: _Paths.PRIVACY, page: () => const PrivacyPolicyScreen()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SAVE_AUTH,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
