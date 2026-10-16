import 'package:energetic_selfcare/models/chakra.dart';
import 'package:energetic_selfcare/models/sequence.dart';

const _standard = Duration(milliseconds: 4500);
const _longText = Duration(milliseconds: 12000);
const _cleanse = Duration(milliseconds: 7000);
const _point = Duration(milliseconds: 3000);
const _mantra = Duration(milliseconds: 4000);

const _grounding = 'I ask for grounding';
const _protection = 'I ask for Protection';
const _shieldIntention =
    'I ask only that which is for my highest good enter my Shield and that which is not for my highest good bounces off and return to the Universe with love.';
const _clear = 'I ask to clear my energy';
const _release = 'Old energy and emotions are released';
const _balance = 'I ask to balance and cleanse my chakras';
const _open = 'I ask to open and cleanse my chakras';
const _energise = 'I ask to energise and activate my chakras';

/// The three guided practices.
class Sequences {
  const Sequences._();

  static final protection = PracticeSequence(
    id: 'protection',
    title: 'Energetic Protection',
    summary: 'Ground the feet, raise the shield, and clear the field.',
    visible: const {
      ChakraId.crown,
      ChakraId.leftFoot,
      ChakraId.rightFoot,
      ChakraId.earthStar,
    },
    beats: [
      ..._opening(),
      const SequenceBeat(
        prompt: 'I am Protected',
        phase: SequencePhase.finish,
        isFinish: true,
        duration: Duration.zero,
      ),
    ],
  );

  static final selfcare = PracticeSequence(
    id: 'selfcare',
    title: 'Energetic Selfcare',
    summary: 'Balance every chakra, then energise each one with its mantra.',
    visible: const {
      ChakraId.soulStar,
      ChakraId.causal,
      ChakraId.crown,
      ChakraId.thirdEye,
      ChakraId.throat,
      ChakraId.heart,
      ChakraId.solarPlexus,
      ChakraId.naval,
      ChakraId.sacral,
      ChakraId.root,
      ChakraId.leftFoot,
      ChakraId.rightFoot,
      ChakraId.earthStar,
    },
    beats: [
      ..._opening(),
      ..._topToBottom(
        prompt: _balance,
        phase: SequencePhase.balance,
        points: _selfcareColumn,
      ),
      ..._bottomToTop(
        points: _selfcareColumn.reversed.toList(growable: false),
        mantras: _selfcareMantras.reversed.toList(growable: false),
      ),
      const SequenceBeat(
        prompt: 'I trust and believe in myself',
        phase: SequencePhase.finish,
        isFinish: true,
        duration: Duration.zero,
      ),
    ],
  );

  static final transition = PracticeSequence(
    id: 'transition',
    title: 'Energetic Transition',
    summary: 'Open the gateways above and below, then call each point awake.',
    visible: const {
      ChakraId.divineGateway,
      ChakraId.galactic,
      ChakraId.universal,
      ChakraId.soulStar,
      ChakraId.causal,
      ChakraId.crown,
      ChakraId.thirdEye,
      ChakraId.throat,
      ChakraId.heart,
      ChakraId.solarPlexus,
      ChakraId.naval,
      ChakraId.sacral,
      ChakraId.root,
      ChakraId.leftHand,
      ChakraId.rightHand,
      ChakraId.leftFoot,
      ChakraId.rightFoot,
      ChakraId.earthStar,
      ChakraId.magnetic,
      ChakraId.gaiaGateway,
    },
    beats: [
      ..._opening(lightHandsOnCleanse: true),
      ..._topToBottom(
        prompt: _open,
        phase: SequencePhase.open,
        points: _transitionColumn,
      ),
      ..._bottomToTop(
        points: _transitionColumn.reversed.toList(growable: false),
        mantras: _transitionMantras.reversed.toList(growable: false),
      ),
      const SequenceBeat(
        prompt: 'I am Infinite',
        phase: SequencePhase.finish,
        isFinish: true,
        duration: Duration.zero,
      ),
    ],
  );

  static List<PracticeSequence> get all => [protection, selfcare, transition];
}

/// Ordered column for selfcare, top to bottom. Feet are one step.
const List<_Point> _selfcareColumn = [
  _Point('Soul Star', [ChakraId.soulStar]),
  _Point('Causal', [ChakraId.causal]),
  _Point('Crown', [ChakraId.crown]),
  _Point('Third Eye', [ChakraId.thirdEye]),
  _Point('Throat', [ChakraId.throat]),
  _Point('Heart', [ChakraId.heart]),
  _Point('Solar Plexus', [ChakraId.solarPlexus]),
  _Point('Naval', [ChakraId.naval]),
  _Point('Sacral', [ChakraId.sacral]),
  _Point('Root', [ChakraId.root]),
  _Point('Feet', bothFeet),
  _Point('Earth Star', [ChakraId.earthStar]),
];

/// Mantras follow assets/data/level_one.json and level_two.json.
const List<String> _selfcareMantras = [
  'My Purpose',
  'I Am',
  'I Know',
  'I See',
  'I Speak',
  'I Love',
  'I Express',
  'I Shine',
  'I Create',
  'I Thrive',
  'I Link',
  'My Grounding',
];

/// Transition column, top to bottom. Hands are not in this list.
const List<_Point> _transitionColumn = [
  _Point('Divine Stellar Gateway', [ChakraId.divineGateway]),
  _Point('Galactic', [ChakraId.galactic]),
  _Point('Universal', [ChakraId.universal]),
  _Point('Soul Star', [ChakraId.soulStar]),
  _Point('Causal', [ChakraId.causal]),
  _Point('Crown', [ChakraId.crown]),
  _Point('Third Eye', [ChakraId.thirdEye]),
  _Point('Throat', [ChakraId.throat]),
  _Point('Heart', [ChakraId.heart]),
  _Point('Solar Plexus', [ChakraId.solarPlexus]),
  _Point('Naval', [ChakraId.naval]),
  _Point('Sacral', [ChakraId.sacral]),
  _Point('Root', [ChakraId.root]),
  _Point('Feet', bothFeet),
  _Point('Earth Star', [ChakraId.earthStar]),
  _Point('Magnetic', [ChakraId.magnetic]),
  _Point('Gaia Gateway', [ChakraId.gaiaGateway]),
];

const List<String> _transitionMantras = [
  'My Abundance',
  'My Team',
  'My Energy',
  'My Purpose',
  'I Am',
  'I Know',
  'I See',
  'I Speak',
  'I Love',
  'I Express',
  'I Shine',
  'I Create',
  'I Thrive',
  'I Link',
  'My Grounding',
  'My Awareness',
  'My Connection',
];

class _Point {
  const _Point(this.focus, this.light);

  final String focus;
  final List<ChakraId> light;
}

List<SequenceBeat> _opening({bool lightHandsOnCleanse = false}) {
  return [
    const SequenceBeat(
      prompt: _grounding,
      phase: SequencePhase.grounding,
      focus: 'Feet',
      light: bothFeet,
      duration: _standard,
    ),
    const SequenceBeat(
      prompt: _grounding,
      phase: SequencePhase.grounding,
      focus: 'Earth Star',
      light: [ChakraId.earthStar],
      duration: _standard,
    ),
    const SequenceBeat(
      prompt: _protection,
      phase: SequencePhase.protection,
      shield: true,
      duration: _standard,
    ),
    const SequenceBeat(
      prompt: _shieldIntention,
      phase: SequencePhase.shieldIntention,
      duration: _longText,
    ),
    const SequenceBeat(
      prompt: _clear,
      phase: SequencePhase.clearEnergy,
      focus: 'Crown',
      light: [ChakraId.crown],
      duration: _standard,
    ),
    SequenceBeat(
      prompt: _release,
      phase: SequencePhase.auraCleanse,
      auraCleanse: true,
      light: lightHandsOnCleanse ? bothHands : const [],
      duration: _cleanse,
    ),
  ];
}

List<SequenceBeat> _topToBottom({
  required String prompt,
  required SequencePhase phase,
  required List<_Point> points,
}) {
  return [
    for (final point in points)
      SequenceBeat(
        prompt: prompt,
        phase: phase,
        focus: point.focus,
        light: point.light,
        duration: _point,
      ),
  ];
}

List<SequenceBeat> _bottomToTop({
  required List<_Point> points,
  required List<String> mantras,
}) {
  assert(
    points.length == mantras.length,
    'Each energise point needs one mantra.',
  );
  return [
    for (var i = 0; i < points.length; i++)
      SequenceBeat(
        prompt: _energise,
        phase: SequencePhase.energise,
        focus: points[i].focus,
        mantra: mantras[i],
        light: points[i].light,
        duration: _mantra,
      ),
  ];
}
