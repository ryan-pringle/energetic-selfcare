import 'package:flutter/material.dart';

import 'package:energetic_selfcare/config/assets.dart';
import 'package:energetic_selfcare/config/editable.dart';
import 'package:energetic_selfcare/data/guidance_catalog.dart';
import 'package:energetic_selfcare/layout/phone_scale.dart';
import 'package:energetic_selfcare/state/app_state.dart';
import 'package:energetic_selfcare/widgets/body_figure.dart';

class GuidanceScreen extends StatelessWidget {
  const GuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guidance = AppScope.of(context).guidance;
    final scale = PhoneScale(context);
    final text = Theme.of(context).textTheme;
    final complete = guidance.isComplete;

    return Scaffold(
      appBar: AppBar(title: const Text('Spiritual Guidance Team')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 4, 8, scale.gap(12)),
          child: Column(
            children: [
              if (complete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'You are supported and guided',
                    textAlign: TextAlign.center,
                    style: text.titleMedium?.copyWith(
                      color: Editable.shieldGold,
                    ),
                  ),
                ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _Corner(
                            role: 'Animal totem',
                            chosen: guidance.animal,
                            image: AppAssets.iconSpiritAnimal,
                            onTap: () => _chooseFromCatalog(
                              context,
                              title: 'Animal totem',
                              kind: _CatalogKind.animals,
                              current: guidance.animal,
                              save: AppScope.of(context).setAnimal,
                            ),
                          ),
                          const Spacer(),
                          _Corner(
                            role: 'Ascended master',
                            chosen: guidance.master,
                            image: AppAssets.iconAscendedMaster,
                            onTap: () => _chooseFromCatalog(
                              context,
                              title: 'Ascended master',
                              kind: _CatalogKind.masters,
                              current: guidance.master,
                              save: AppScope.of(context).setMaster,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: BodyFigure(
                        visible: const {},
                        lit: const {},
                        pulsing: const {},
                        aura: 0.22,
                        shield: complete ? 1 : 0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _Corner(
                            role: 'Archangel',
                            chosen: guidance.archangel,
                            image: AppAssets.iconArchangel,
                            onTap: () => _chooseFromCatalog(
                              context,
                              title: 'Archangel',
                              kind: _CatalogKind.archangels,
                              current: guidance.archangel,
                              save: AppScope.of(context).setArchangel,
                            ),
                          ),
                          const Spacer(),
                          _Corner(
                            role: 'Guide',
                            chosen: guidance.guide,
                            image: AppAssets.iconGuide,
                            onTap: () => _chooseGuide(context, guidance.guide),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text(
                  complete
                      ? 'Tap a corner if someone in your team changes.'
                      : guidance.chosenCount == 0
                      ? 'No one is named yet. Tap a corner and choose who supports you.'
                      : 'Tap a corner to choose or change.',
                  textAlign: TextAlign.center,
                  style: text.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _chooseFromCatalog(
    BuildContext context, {
    required String title,
    required _CatalogKind kind,
    required String? current,
    required Future<void> Function(String? name) save,
  }) async {
    final catalog = await GuidanceCatalog.load();
    if (!context.mounted) {
      return;
    }
    final options = switch (kind) {
      _CatalogKind.animals => catalog.animals,
      _CatalogKind.archangels => catalog.archangels,
      _CatalogKind.masters => catalog.masters,
    };
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final height = MediaQuery.sizeOf(sheetContext).height * 0.72;
        return SafeArea(
          child: SizedBox(
            height: height,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                  child: Text(
                    title,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final entry in options)
                        ListTile(
                          title: Text(entry.name),
                          subtitle: Text(
                            [
                              if (entry.description.isNotEmpty)
                                entry.description,
                              if (entry.action.isNotEmpty) entry.action,
                            ].join('\n'),
                          ),
                          isThreeLine: entry.description.isNotEmpty &&
                              entry.action.isNotEmpty,
                          trailing: entry.name == current
                              ? const Icon(
                                  Icons.check,
                                  color: Editable.shieldGold,
                                )
                              : null,
                          onTap: () =>
                              Navigator.of(sheetContext).pop(entry.name),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && context.mounted) {
      await save(selected);
    }
  }

  Future<void> _chooseGuide(BuildContext context, String? current) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _GuideDialog(initial: current ?? ''),
    );
    if (result != null && context.mounted) {
      await AppScope.of(context).setGuide(result);
    }
  }
}

enum _CatalogKind { animals, archangels, masters }

class _Corner extends StatelessWidget {
  const _Corner({
    required this.role,
    required this.chosen,
    required this.image,
    required this.onTap,
  });

  final String role;
  final String? chosen;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final named = chosen != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
            const SizedBox(height: 4),
            Text(
              role,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              named ? chosen! : 'Choose',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.titleMedium?.copyWith(
                fontSize: 14,
                color: named ? Editable.parchment : Editable.mist,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideDialog extends StatefulWidget {
  const _GuideDialog({required this.initial});

  final String initial;

  @override
  State<_GuideDialog> createState() => _GuideDialogState();
}

class _GuideDialogState extends State<_GuideDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your guide'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        maxLength: 40,
        decoration: const InputDecoration(hintText: 'Write their name'),
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        if (widget.initial.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
