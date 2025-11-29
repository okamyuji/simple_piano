import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../domain/entities/note.dart';

/// ピアノキーウィジェット
class PianoKey extends StatefulWidget {
  final Note note;
  final bool isPressed;
  final bool isHighlighted;
  final VoidCallback onPressed;
  final VoidCallback onReleased;
  final double width;
  final double height;

  const PianoKey({
    super.key,
    required this.note,
    required this.isPressed,
    this.isHighlighted = false,
    required this.onPressed,
    required this.onReleased,
    this.width = 60,
    this.height = 200,
  });

  @override
  State<PianoKey> createState() => _PianoKeyState();
}

class _PianoKeyState extends State<PianoKey>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(PianoKey oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPressed && !oldWidget.isPressed) {
      _animationController.forward();
    } else if (!widget.isPressed && oldWidget.isPressed) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWhiteKey = widget.note.isWhiteKey;

    return GestureDetector(
      onTapDown: (_) => widget.onPressed(),
      onTapUp: (_) => widget.onReleased(),
      onTapCancel: () => widget.onReleased(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: _getKeyColor(
                  isWhiteKey,
                  widget.isPressed,
                  widget.isHighlighted,
                ),
                border: Border.all(
                  color: widget.isHighlighted ? Colors.green : Colors.black,
                  width: widget.isHighlighted ? 3 : (isWhiteKey ? 1 : 0),
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  if (!widget.isPressed)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.note.noteName,
                  style: TextStyle(
                    color: isWhiteKey ? Colors.black54 : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getKeyColor(bool isWhiteKey, bool isPressed, bool isHighlighted) {
    if (isHighlighted) {
      return Colors.green.withValues(alpha: isWhiteKey ? 0.3 : 0.5);
    }
    if (isWhiteKey) {
      return isPressed ? AppTheme.whiteKeyPressedColor : AppTheme.whiteKeyColor;
    } else {
      return isPressed ? AppTheme.blackKeyPressedColor : AppTheme.blackKeyColor;
    }
  }
}
