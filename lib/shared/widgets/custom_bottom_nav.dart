import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skystream/l10n/generated/app_localizations.dart';

import '../focus/app_focus.dart';
import 'matte_glass_pill.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const double height = 64;

  /// The pill's offset from the screen bottom (matching 4c-app convention).
  static double bottomInsetFor(BuildContext context) =>
      math.max(MediaQuery.viewPaddingOf(context).bottom - 8, 12);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final destinations = <_BottomNavDestination>[
      _BottomNavDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: localizations.home,
      ),
      _BottomNavDestination(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: localizations.search,
      ),
      _BottomNavDestination(
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: localizations.explore,
      ),
      _BottomNavDestination(
        icon: Icons.video_library_outlined,
        selectedIcon: Icons.video_library,
        label: localizations.library,
      ),
      _BottomNavDestination(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: localizations.settings,
      ),
    ];

    final colorScheme = Theme.of(context).colorScheme;

    final tabs = <Widget>[
      for (final (i, d) in destinations.indexed)
        Expanded(
          child: _NavTabCell(
            destination: d,
            isSelected: i == currentIndex,
            onTap: () {
              HapticFeedback.selectionClick();
              onTap(i);
            },
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth.clamp(0.0, 420.0);
        return Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: SizedBox(
            width: fullWidth,
            height: height,
            child: MatteGlassPill(
              // Most of the theme's surface, not a tint: over the brightest
              // and darkest posters the icons keep 3:1 (WCAG 1.4.11) - 7.4:1
              // on the dark theme, 3.7:1 on the light - where a 22% glass
              // left them at 1.1:1 and 1.8:1.
              surfaceColor: colorScheme.surface.withValues(alpha: 0.8),
              child: Material(
                type: MaterialType.transparency,
                child: Row(children: tabs),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavTabCell extends StatefulWidget {
  final _BottomNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabCell({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavTabCell> createState() => _NavTabCellState();
}

class _NavTabCellState extends State<_NavTabCell> {
  bool _isFocused = false;

  /// True while a finger is down on the tab: the icon squeezes in, then springs
  /// back out on release.
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.isSelected;
    final iconColor = selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.destination.label,
      child: Tooltip(
        message: widget.destination.label,
        child: AnimatedContainer(
          duration: AppFocus.duration,
          // The ring, and not a colour: the selected tab is already in the
          // accent, so focus there would otherwise show nothing at all. A
          // neutral ring, and none of it on a phone being tapped.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: AppFocus.border(
              context,
              focused: showFocusIndicator(context, _isFocused),
            ),
          ),
          // The ink's own focus, so a tab is one stop for the keyboard.
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            focusColor: Colors.transparent,
            hoverColor: colorScheme.primary.withValues(alpha: 0.08),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: widget.onTap,
            child: Center(
              child: AnimatedScale(
                // Press: squeeze. Release: spring back past 1 and settle.
                scale: _pressed ? 0.82 : 1.0,
                duration: Duration(milliseconds: _pressed ? 90 : 420),
                curve: _pressed ? Curves.easeOut : Curves.elasticOut,
                child: AnimatedContainer(
                  // The selected tab's pill grows out from the icon.
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  width: selected ? 58 : 40,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected ? colorScheme.secondaryContainer : colorScheme.secondaryContainer.withValues(alpha: 0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedScale(
                    scale: selected ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutBack,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: Tween<double>(begin: 0.6, end: 1).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                        ),
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Icon(
                        selected ? widget.destination.selectedIcon : widget.destination.icon,
                        key: ValueKey<bool>(selected),
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _BottomNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
