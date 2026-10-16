import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/controllers/sequence_player.dart';
import 'package:energetic_selfcare/layout/phone_scale.dart';
import 'package:energetic_selfcare/models/chakra.dart';
import 'package:energetic_selfcare/models/sequence.dart';
import 'package:energetic_selfcare/widgets/body_figure.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, required this.sequence});

  final PracticeSequence sequence;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  late final SequencePlayer _player;
  late final AnimationController _pulse;
  late final AnimationController _sweep;
  late final AnimationController _shield;
  int _renderedIndex = -1;

  @override
  void initState() {
    super.initState();
    _player = SequencePlayer(widget.sequence);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );
    _shield = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _player.addListener(_syncAnimations);
    _player.start();
  }

  void _syncAnimations() {
    if (_player.paused) {
      _pulse.stop();
      _sweep.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }

    if (_player.sweeping) {
      if (!_player.paused) {
        if (_renderedIndex != _player.index) {
          _sweep.duration = _player.beat.duration;
          _sweep.forward(from: 0);
        } else if (!_sweep.isAnimating && _sweep.value < 1) {
          _sweep.forward();
        }
      }
    } else if (_player.auraFull) {
      _sweep.value = 1;
    } else {
      _sweep.value = 0;
    }

    if (!_player.shieldOn) {
      _shield.value = 0;
    } else if (_shield.status != AnimationStatus.completed &&
        !_shield.isAnimating) {
      _shield.forward();
    }

    _renderedIndex = _player.index;
  }

  @override
  void dispose() {
    _player.removeListener(_syncAnimations);
    _player.dispose();
    _pulse.dispose();
    _sweep.dispose();
    _shield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_player, _pulse, _sweep, _shield]),
      builder: (context, _) {
        final beat = _player.beat;
        final text = Theme.of(context).textTheme;
        final scale = PhoneScale(context);
        return Scaffold(
          appBar: AppBar(title: Text(widget.sequence.title)),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    key: const Key('practice-stage'),
                    behavior: HitTestBehavior.opaque,
                    onTap: _player.isComplete ? null : _player.advance,
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: scale.promptMaxHeight(),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(
                              scale.gap(22),
                              4,
                              scale.gap(22),
                              8,
                            ),
                            child: _Prompt(beat: beat, text: text),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: scale.gap(8),
                            ),
                            child: BodyFigure(
                              visible: widget.sequence.visible,
                              lit: _player.lit,
                              pulsing: _player.pulsing,
                              pulse: _pulse.value,
                              aura: _auraLevel(),
                              shield: _shield.value,
                              sweep: _sweep.value,
                              sweeping: _player.sweeping,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _Controls(player: _player),
              ],
            ),
          ),
        );
      },
    );
  }

  double _auraLevel() {
    if (_player.auraFull) {
      return 1;
    }
    if (_player.sweeping) {
      return _sweep.value;
    }
    return 0;
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.beat, required this.text});

  final SequenceBeat beat;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final caption = beat.caption;
    final colour = _colourFor(beat.focus);
    return Column(
      children: [
        Text(
          beat.prompt,
          textAlign: TextAlign.center,
          style: beat.isFinish
              ? text.headlineSmall?.copyWith(
                  color: Editable.shieldGold,
                  height: 1.3,
                )
              : text.bodyLarge?.copyWith(
                  fontSize: beat.mantra == null ? 18 : 15,
                ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 8),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(
              color: colour,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _colourFor(String? focus) {
    if (focus == null) {
      return Editable.parchment;
    }
    for (final id in ChakraId.values) {
      if (id.label == focus) {
        return Editable.colourOf(id);
      }
    }
    return Editable.parchment;
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.player});

  final SequencePlayer player;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final finished = player.isComplete;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 12, 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: LinearProgressIndicator(
              value: player.stepNumber / player.stepCount,
              minHeight: 2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${player.stepNumber} of ${player.stepCount}',
                style: text.bodyMedium,
              ),
              const Spacer(),
              if (!finished)
                TextButton.icon(
                  onPressed: player.togglePause,
                  icon: Icon(player.paused ? Icons.play_arrow : Icons.pause),
                  label: Text(player.paused ? 'Resume' : 'Pause'),
                ),
            ],
          ),
          if (finished)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: player.replay,
                  icon: const Icon(Icons.replay),
                  label: const Text('Replay'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Home'),
                ),
              ],
            )
          else
            Text(
              player.paused
                  ? 'Paused. Tap the figure when you are ready.'
                  : 'Tap the figure to continue.',
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
          if (finished)
            Text(
              'The practice is complete.',
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
        ],
      ),
    );
  }
}
