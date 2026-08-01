import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Top banner — drops from top, auto slides right after 2s (or ✕ tap).
class TopSlideNotice {
  TopSlideNotice._();

  static OverlayEntry? _entry;

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    Duration autoDismiss = const Duration(seconds: 2),
  }) {
    dismiss();
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _TopSlideNoticeBanner(
        title: title,
        message: message,
        autoDismiss: autoDismiss,
        onRemoved: () {
          entry.remove();
          if (_entry == entry) _entry = null;
        },
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _TopSlideNoticeBanner extends StatefulWidget {
  const _TopSlideNoticeBanner({
    required this.title,
    required this.message,
    required this.autoDismiss,
    required this.onRemoved,
  });

  final String title;
  final String message;
  final Duration autoDismiss;
  final VoidCallback onRemoved;

  @override
  State<_TopSlideNoticeBanner> createState() => _TopSlideNoticeBannerState();
}

class _TopSlideNoticeBannerState extends State<_TopSlideNoticeBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _slide;
  Timer? _autoTimer;
  bool _exiting = false;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    _autoTimer = Timer(widget.autoDismiss, _exitToRight);
  }

  Future<void> _exitToRight() async {
    if (_exiting || _removed || !mounted) return;
    _exiting = true;
    _autoTimer?.cancel();

    setState(() {
      _slide = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.35, 0),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
    });

    _controller.reset();
    await _controller.forward();
    _remove();
  }

  void _remove() {
    if (_removed) return;
    _removed = true;
    widget.onRemoved();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 8;

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.message,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _exitToRight,
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
