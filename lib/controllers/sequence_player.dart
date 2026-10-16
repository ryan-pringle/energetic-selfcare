import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:energetic_selfcare/models/chakra.dart';
import 'package:energetic_selfcare/models/sequence.dart';

/// Plays a practice: timed advance, pause, and tap-to-continue.
///
/// Points that have lit on earlier beats stay lit. [pulsing] is the point
/// or points of the current beat.
class SequencePlayer extends ChangeNotifier {
  SequencePlayer(this.sequence);

  final PracticeSequence sequence;

  int index = 0;
  bool paused = false;

  Timer? _timer;
  Duration? _remaining;
  DateTime? _deadline;

  SequenceBeat get beat => sequence.beats[index];

  bool get isComplete => beat.isFinish;

  int get stepNumber => index + 1;

  int get stepCount => sequence.beats.length;

  bool get shieldOn =>
      sequence.beats.take(index + 1).any((beat) => beat.shield);

  bool get sweeping => beat.auraCleanse;

  /// True once the cleanse beat has finished and the white field should stay.
  bool get auraFull {
    final cleanseIndex = sequence.beats.indexWhere((beat) => beat.auraCleanse);
    if (cleanseIndex < 0) {
      return false;
    }
    return index > cleanseIndex;
  }

  Set<ChakraId> get lit {
    final points = <ChakraId>{};
    for (var i = 0; i <= index; i++) {
      points.addAll(sequence.beats[i].light);
    }
    return points;
  }

  Set<ChakraId> get pulsing => beat.light.toSet();

  void start() {
    paused = false;
    _remaining = null;
    _arm();
    notifyListeners();
  }

  void togglePause() {
    if (isComplete) {
      return;
    }
    if (paused) {
      paused = false;
      _arm();
    } else {
      paused = true;
      final deadline = _deadline;
      _remaining = deadline == null
          ? beat.duration
          : deadline.difference(DateTime.now());
      if (_remaining!.isNegative) {
        _remaining = Duration.zero;
      }
      _timer?.cancel();
      _deadline = null;
    }
    notifyListeners();
  }

  /// Tap to continue. Stays paused if the practice was already paused.
  void advance() {
    if (isComplete) {
      return;
    }
    index += 1;
    _remaining = null;
    _arm();
    notifyListeners();
  }

  void replay() {
    index = 0;
    paused = false;
    _remaining = null;
    _arm();
    notifyListeners();
  }

  void _arm() {
    _timer?.cancel();
    _deadline = null;
    if (paused || isComplete) {
      return;
    }
    final duration = _remaining ?? beat.duration;
    _remaining = null;
    if (duration <= Duration.zero) {
      return;
    }
    _deadline = DateTime.now().add(duration);
    _timer = Timer(duration, advance);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
