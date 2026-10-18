import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/material.dart';

import '../../../domain/danmaku.dart';
import '../../../domain/models.dart';

class DanmakuOverlay extends StatefulWidget {
  const DanmakuOverlay({
    super.key,
    required this.comments,
    required this.snapshot,
    required this.options,
    required this.rate,
    required this.seekRevision,
    this.onControllerCreated,
  });
  final List<DanmakuComment> comments;
  final PlaybackSnapshot snapshot;
  final DanmakuOptions options;
  final double rate;
  final int seekRevision;
  final ValueChanged<DanmakuController<DanmakuComment>>? onControllerCreated;
  @override
  State<DanmakuOverlay> createState() => _DanmakuOverlayState();
}

class _DanmakuOverlayState extends State<DanmakuOverlay> {
  DanmakuController<DanmakuComment>? _controller;
  DanmakuTimeline? _timeline;
  List<DanmakuComment>? _comments;
  DanmakuOptions? _options;
  double? _rate;
  int? _seekRevision;
  int? _lastPosition;
  bool _wasActive = false;
  bool _scheduled = false;

  @override
  void didUpdateWidget(covariant DanmakuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleSync();
  }

  void _scheduleSync() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (mounted) _sync();
    });
  }

  void _sync() {
    final controller = _controller;
    if (controller == null) return;
    final position =
        widget.snapshot.position.inMilliseconds - widget.options.offsetMs;
    final replaced = !identical(_comments, widget.comments);
    final discontinuity =
        _lastPosition != null &&
        (position < _lastPosition! || position - _lastPosition! > 2000);
    final rateChanged = _rate != widget.rate;
    final styleChanged = _options != widget.options;
    if (replaced) {
      _comments = widget.comments;
      _timeline = DanmakuTimeline(widget.comments);
    }
    if (replaced ||
        discontinuity ||
        rateChanged ||
        _seekRevision != widget.seekRevision ||
        _options?.offsetMs != widget.options.offsetMs) {
      controller.clear();
      _timeline?.reset(position);
    }
    if (styleChanged || rateChanged) {
      controller.updateOption(
        DanmakuOption(
          fontSize: widget.options.fontSize,
          opacity: widget.options.opacity,
          area: widget.options.area,
          duration: 8 / widget.rate,
          staticDuration: 4 / widget.rate,
          massiveMode: false,
          safeArea: true,
        ),
      );
    }
    _options = widget.options;
    _rate = widget.rate;
    _seekRevision = widget.seekRevision;
    _lastPosition = position;
    final active =
        widget.options.enabled &&
        widget.snapshot.playing &&
        !widget.snapshot.buffering &&
        widget.snapshot.error == null;
    if (!active) {
      if (controller.running) controller.pause();
      _wasActive = false;
      return;
    }
    final due = _timeline?.advance(position) ?? const <DanmakuComment>[];
    if (!_wasActive || (due.isNotEmpty && !controller.running)) {
      controller.resume();
    }
    _wasActive = true;
    for (final comment in due) {
      controller.addDanmaku(
        DanmakuContentItem<DanmakuComment>(
          comment.text,
          color: Color(0xff000000 | comment.color),
          extra: comment,
          type: switch (comment.mode) {
            DanmakuMode.scroll => DanmakuItemType.scroll,
            DanmakuMode.top => DanmakuItemType.top,
            DanmakuMode.bottom => DanmakuItemType.bottom,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ExcludeSemantics(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!widget.options.enabled ||
                constraints.maxHeight < 64 ||
                constraints.maxWidth <= 0) {
              _controller = null;
              _timeline = null;
              _comments = null;
              return const SizedBox.expand();
            }
            return DanmakuScreen<DanmakuComment>(
              option: DanmakuOption(
                fontSize: widget.options.fontSize,
                opacity: widget.options.opacity,
                area: widget.options.area,
                duration: 8 / widget.rate,
                staticDuration: 4 / widget.rate,
              ),
              createdController: (controller) {
                _controller = controller;
                _comments = null;
                _timeline = null;
                _wasActive = false;
                widget.onControllerCreated?.call(controller);
                _scheduleSync();
              },
            );
          },
        ),
      ),
    ),
  );
}
