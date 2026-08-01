import 'package:audioplayers/audioplayers.dart';

/// Short UI feedback. Paths are **relative to the `assets/` folder** — the
/// default [AudioPlayer] cache uses prefix `assets/`, so do **not** prefix with
/// `assets/` again (that would break [rootBundle.load] on device).
abstract final class UiSounds {
  /// Matches [pubspec.yaml]: `assets/sounds/...` → cache key `sounds/...`.
  static const String _driverVerifiedAsset =
      'sounds/soundshelfstudio-ui-success-chime-513565.mp3';

  static final AudioPlayer _player = AudioPlayer();

  static AudioContext _verifiedContext() {
    return AudioContext(
      android: const AudioContextAndroid(
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
    );
  }

  /// Generic success chime (payments, bookings, ride published, etc.).
  static Future<void> playSuccessChime() => playDriverAccountVerified();

  /// Success chime when the driver account is verified / approved.
  static Future<void> playDriverAccountVerified() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource(_driverVerifiedAsset),
        volume: 0.92,
        ctx: _verifiedContext(),
      );
    } catch (_) {
      // Missing asset, focus denied, etc.
    }
  }
}
