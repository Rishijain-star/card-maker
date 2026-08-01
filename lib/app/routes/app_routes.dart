part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const WELCOME = _Paths.WELCOME;
  static const DETAILS_FORM = _Paths.DETAILS_FORM;
  static const TEMPLATES = _Paths.TEMPLATES;
  static const TEMPLATE_PREVIEW = _Paths.TEMPLATE_PREVIEW;
  static const LIVE_CUSTOMIZE = _Paths.LIVE_CUSTOMIZE;
  static const LIVE_PREVIEW = _Paths.LIVE_PREVIEW;
  static const SAVE_DESIGN = _Paths.SAVE_DESIGN;
  static const SAVE_AUTH = _Paths.SAVE_AUTH;
  static const SAVE_SUCCESS = _Paths.SAVE_SUCCESS;
  static const MY_DESIGNS = _Paths.MY_DESIGNS;
  static const SUBSCRIPTION = _Paths.SUBSCRIPTION;
  static const PREMIUM_SUBSCRIBE = _Paths.PREMIUM_SUBSCRIBE;
  static const TERMS = _Paths.TERMS;
  static const PRIVACY = _Paths.PRIVACY;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const DETAILS_FORM = '/details-form';
  static const TEMPLATES = '/templates';
  static const TEMPLATE_PREVIEW = '/template-preview';
  static const LIVE_CUSTOMIZE = '/live-customize';
  static const LIVE_PREVIEW = '/live-preview';
  static const SAVE_DESIGN = '/save-design';
  static const SAVE_AUTH = '/save-auth';
  static const SAVE_SUCCESS = '/save-success';
  static const MY_DESIGNS = '/my-designs';
  static const SUBSCRIPTION = '/subscription';
  static const PREMIUM_SUBSCRIBE = '/premium-subscribe';
  static const TERMS = '/terms';
  static const PRIVACY = '/privacy';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
}
