# Engine-start effect on splash (archived)

Reference for a cold-start audio + synced haptic vibration triggered by the
splash "Continue" button. Rolled back from the live codebase; restore from
this note if we want to bring it back.

## Concept

When the user taps the continue button on the splash page, play a real
engine-start audio clip (`assets/sounds/cold-start.mp3`) and fire a haptic
pattern on top of it that matches the audio envelope. The guest-identifier
API call runs in parallel; navigation is held until the audio finishes so
a fast API response doesn't cut the effect short.

## Dependencies

```yaml
dependencies:
  audioplayers: ^6.1.0
  vibration: ^3.1.3
```

And in `flutter.assets`:

```yaml
flutter:
  assets:
    - assets/sounds/
```

## Audio analysis (reference — from our cold-start.mp3)

RMS envelope of `assets/sounds/cold-start.mp3` (3.76s, 44.1kHz mono,
analyzed with `afconvert` → raw WAV → Python `wave` module, 20ms windows):

| Time        | Audio                                 |
| ----------- | ------------------------------------- |
| 0.00–0.08s  | Initial key-click / starter relay     |
| 0.08–0.60s  | Quiet starter crank rumble (15–25%)   |
| 0.60–0.80s  | Ramp-up as ignition catches (30→80%)  |
| 0.80–2.00s  | Heavy sustained roar (80–100%)        |
| 2.00–2.70s  | Still-loud rumble (60–90%)            |
| 2.70–3.00s  | Decay                                 |
| 3.00–3.76s  | Tail fade to silence                  |

## Full SplashCubit with audio + vibration

```dart
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';

import 'package:carfy/common/error/failure.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GenerateGuestIdentifierUseCase _generateGuestIdentifierUseCase;
  final AppRouter _appRouter;

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _warmup = AudioPlayer();
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<void>? _completeSub;
  Completer<void>? _audioCompleter;
  bool _vibrationArmed = false;
  bool _engineRunning = false;

  static const String _engineSoundAsset = 'sounds/cold-start.mp3';
  static const Duration _audioTimeout = Duration(seconds: 5);

  SplashCubit({AppRouter? appRouter, GenerateGuestIdentifierUseCase? generateGuestIdentifierUseCase})
    : _appRouter = appRouter ?? getIt<AppRouter>(),
      _generateGuestIdentifierUseCase = generateGuestIdentifierUseCase ?? getIt<GenerateGuestIdentifierUseCase>(),
      super(SplashState.initial());

  void init() {
    _checkFirstEnter();
    _preloadEngineSound();
  }

  Future<void> _preloadEngineSound() async {
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setSourceAsset(_engineSoundAsset);
      await _warmup.setVolume(0);
      await _warmup.setSourceAsset(_engineSoundAsset);

      _stateSub = _player.onPlayerStateChanged.listen((s) {
        if (s == PlayerState.playing && _vibrationArmed) {
          _vibrationArmed = false;
          _fireVibration();
        }
      });
      _completeSub = _player.onPlayerComplete.listen((_) {
        if (_audioCompleter != null && !_audioCompleter!.isCompleted) {
          _audioCompleter!.complete();
        }
      });
    } catch (_) {
      // Audio init failures must not break the splash flow.
    }
  }

  Future<void> _checkFirstEnter() async {
    final bool firstEnter = PrefUtil.getBool(AppPreferenceKeys.firstEnter) ?? true;
    emit(state.copyWith(firstEnter: firstEnter));
    PrefUtil.setBool(AppPreferenceKeys.firstEnter, false);
    await Future.delayed(const Duration(milliseconds: 300));

    if (!firstEnter) {
      final hasAuth = PrefUtil.getString(AppPreferenceKeys.authToken) != null;
      final hasIdentifier = PrefUtil.getString(AppPreferenceKeys.guestIdentifier) != null;
      if (!hasAuth && !hasIdentifier) {
        _generateIdentifierAndNavigate();
      } else {
        _appRouter.replaceAll([const MainRoute()]);
      }
    }
  }

  /// Silent flow — returning user, no effects.
  Future<void> _generateIdentifierAndNavigate() async {
    emit(state.copyWith(guestIdentifierState: StateStatus.loading()));
    final apiResult = await _generateGuestIdentifierUseCase();
    _handleApiResult(apiResult);
  }

  /// First-enter button flow. Fires audio + vibration, runs API in parallel,
  /// holds splash until the sound ends.
  Future<void> startEngine() async {
    if (_engineRunning) return;
    _engineRunning = true;

    _audioCompleter = Completer<void>();
    Vibration.cancel();
    _vibrationArmed = true;

    try {
      await _player.stop();
      await _player.play(AssetSource(_engineSoundAsset));
    } catch (_) {
      if (!_audioCompleter!.isCompleted) _audioCompleter!.complete();
    }

    emit(state.copyWith(guestIdentifierState: StateStatus.loading()));
    final apiResult = await _generateGuestIdentifierUseCase();

    try {
      await _audioCompleter!.future.timeout(_audioTimeout);
    } on TimeoutException {
      // swallow
    }

    _engineRunning = false;
    _handleApiResult(apiResult);
  }

  void _handleApiResult(Either<Failure, GuestIdentifierResponse> apiResult) {
    apiResult.fold(
      (failure) {
        if (failure is ConnectionFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.networkFailure()));
        } else if (failure is ServerFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.serverFailure()));
        } else if (failure is UserFailure) {
          emit(state.copyWith(guestIdentifierState: StateStatus.failure(failure.message)));
        }
      },
      (success) {
        PrefUtil.setString(AppPreferenceKeys.guestIdentifier, success.identifier);
        _appRouter.replaceAll([const MainRoute()]);
      },
    );
  }

  Future<void> _fireVibration() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) {
      HapticFeedback.heavyImpact();
      return;
    }
    final data = _buildEnginePattern();
    final hasAmplitude = await Vibration.hasAmplitudeControl();
    if (hasAmplitude) {
      Vibration.vibrate(pattern: data.pattern, intensities: data.intensities);
    } else {
      Vibration.vibrate(pattern: data.pattern);
    }
  }

  // Vibration pattern matched to the RMS envelope of cold-start.mp3 (3.76s).
  ({List<int> pattern, List<int> intensities}) _buildEnginePattern() {
    final pattern = <int>[0];
    final intensities = <int>[0];

    void chug(int onMs, int offMs, int amp) {
      pattern.add(onMs);
      pattern.add(offMs);
      intensities.add(amp);
      intensities.add(0);
    }

    // 0.00–0.08s  Key click / starter relay.
    chug(45, 30, 150);

    // 0.08–0.60s  Quiet starter crank (14 chugs, amp 70–125).
    const crankOn  = [25, 28, 24, 27, 26, 29, 25, 28, 24, 27, 26, 28, 25, 27];
    const crankOff = [12, 10, 13, 11, 12, 10, 13, 11, 12, 10, 13, 11, 12, 10];
    const crankAmp = [70, 85, 95, 100, 105, 110, 105, 115, 110, 118, 112, 120, 115, 125];
    for (int i = 0; i < crankOn.length; i++) {
      chug(crankOn[i], crankOff[i], crankAmp[i]);
    }

    // 0.60–0.80s  Ramp-up, ignition catches (5 chugs, amp 140→230).
    const rampOn  = [24, 26, 25, 28, 26];
    const rampOff = [12, 10, 11, 9,  11];
    const rampAmp = [140, 170, 195, 215, 230];
    for (int i = 0; i < rampOn.length; i++) {
      chug(rampOn[i], rampOff[i], rampAmp[i]);
    }

    // 0.80–2.00s  Heavy sustained roar (32 chugs, amp 240–255).
    const roarJitter = [250, 255, 248, 255, 252, 255, 245, 255, 250, 255,
                        253, 248, 255, 250, 255, 252, 255, 246, 255, 250,
                        255, 252, 255, 245, 255, 250, 255, 248, 255, 253, 255, 250];
    for (int i = 0; i < roarJitter.length; i++) {
      chug(27, 10, roarJitter[i]);
    }

    // 2.00–2.70s  Still-loud cruise (18 chugs, amp 180–220).
    const cruiseAmp = [220, 200, 185, 200, 215, 195, 180, 205, 220,
                       200, 185, 195, 210, 220, 200, 185, 195, 180];
    for (int i = 0; i < cruiseAmp.length; i++) {
      chug(27, 12, cruiseAmp[i]);
    }

    // 2.70–3.00s  Decay (8 chugs, 170→130).
    for (int i = 0; i < 8; i++) {
      chug(25, 12, 170 - i * 5);
    }

    // 3.00–3.76s  Tail fade (20 chugs, 115→25).
    for (int i = 0; i < 20; i++) {
      chug(22, 15, (115 - i * 4.5).round().clamp(25, 115));
    }

    return (pattern: pattern, intensities: intensities);
  }

  @override
  Future<void> close() {
    _stateSub?.cancel();
    _completeSub?.cancel();
    _player.dispose();
    _warmup.dispose();
    Vibration.cancel();
    return super.close();
  }
}
```

## Splash page wiring

```dart
CustomButton(
  onPressed: () => context.read<SplashCubit>().startEngine(),
  text: context.localization.continueBtn,
  loading: state.guestIdentifierState is StateStatusLoading,
  width: 268,
),
```

## Notes / gotchas

- `onPlayerStateChanged` → `PlayerState.playing` is the trigger for vibration;
  fires right when audio actually starts, eliminating codec-startup offset.
- `_warmup` player primes the audio engine so the first real `play()` has
  minimal latency. On Android this is the biggest consistency win.
- Pattern was tuned to the envelope of *this specific* cold-start.mp3. If
  the audio asset is swapped, re-derive boundaries with the Python/afconvert
  analysis used here and re-tune each phase.
- Vibration amplitude control only works on Android 8+ with suitable
  hardware. Older Android + iOS fall back to the same timing pattern without
  intensity modulation.
