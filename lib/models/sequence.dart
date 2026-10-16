import 'package:energetic_selfcare/models/chakra.dart';

/// Where a beat sits inside a practice.
enum SequencePhase {
  grounding,
  protection,
  shieldIntention,
  clearEnergy,
  auraCleanse,
  balance,
  open,
  energise,
  finish,
}

/// One timed step in a practice.
///
/// [prompt] is the sentence on screen. [focus] names the point this step
/// lights, when there is one. [mantra] is the activation phrase, present only
/// on energise steps. [light] is added to the points that stay lit.
class SequenceBeat {
  const SequenceBeat({
    required this.prompt,
    required this.phase,
    this.focus,
    this.mantra,
    this.light = const [],
    this.shield = false,
    this.auraCleanse = false,
    this.isFinish = false,
    this.duration = const Duration(milliseconds: 4500),
  });

  final String prompt;
  final SequencePhase phase;
  final String? focus;
  final String? mantra;
  final List<ChakraId> light;
  final bool shield;
  final bool auraCleanse;
  final bool isFinish;
  final Duration duration;

  /// Line shown under the prompt, such as "Earth Star – My Grounding".
  String? get caption {
    if (isFinish) {
      return null;
    }
    if (focus != null && mantra != null) {
      return '$focus – $mantra';
    }
    return focus;
  }
}

/// A full guided practice and the points drawn on its figure.
class PracticeSequence {
  const PracticeSequence({
    required this.id,
    required this.title,
    required this.summary,
    required this.visible,
    required this.beats,
  });

  final String id;
  final String title;
  final String summary;
  final Set<ChakraId> visible;
  final List<SequenceBeat> beats;

  /// Labels of steps that light a named point, in order.
  List<String> get lightingOrder => [
    for (final beat in beats)
      if (beat.focus != null) beat.focus!,
  ];
}
