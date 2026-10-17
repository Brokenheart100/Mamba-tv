import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

class TvFocus extends StatefulWidget {
  const TvFocus({
    super.key,
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.selected = false,
    this.label,
    this.padding = EdgeInsets.zero,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final bool autofocus;
  final bool selected;
  final String? label;
  final EdgeInsets padding;
  @override
  State<TvFocus> createState() => _TvFocusState();
}

class _TvFocusState extends State<TvFocus> {
  bool _focused = false;
  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    enabled: widget.onPressed != null,
    autofocus: widget.autofocus,
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
    },
    actions: {
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) {
          widget.onPressed?.call();
          return null;
        },
      ),
    },
    onFocusChange: (focused) {
      setState(() => _focused = focused);
      if (focused) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && Scrollable.maybeOf(context) != null) {
            context.findRenderObject()?.showOnScreen(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
            );
          }
        });
      }
    },
    child: Semantics(
      button: true,
      enabled: widget.onPressed != null,
      focused: _focused,
      label: widget.label,
      child: MouseRegion(
        cursor: widget.onPressed == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: widget.selected
                  ? accent.withValues(alpha: .14)
                  : Colors.transparent,
              border: Border.all(
                width: 2,
                color: _focused ? accent : Colors.transparent,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: .18),
                        blurRadius: 18,
                      ),
                    ]
                  : [],
            ),
            child: widget.child,
          ),
        ),
      ),
    ),
  );
}

class TvButton extends StatelessWidget {
  const TvButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
    this.autofocus = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;
  final bool autofocus;
  @override
  Widget build(BuildContext context) => TvFocus(
    label: label,
    onPressed: onPressed,
    autofocus: autofocus,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
      decoration: BoxDecoration(
        color: primary ? accent : const Color(0xFF282A39),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: primary ? canvas : Colors.white),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: onPressed == null
                    ? muted
                    : primary
                    ? canvas
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
