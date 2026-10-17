import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'error_message.dart';
import 'tv_focus.dart';

Future<bool?> showMediaDialog(
  BuildContext context, {
  required Future<void> Function(String) onSave,
  String initial = '',
  String title = '设置本集视频地址',
  String submitLabel = '保存并播放',
}) => showDialog<bool>(
  context: context,
  builder: (_) => _MediaDialog(
    onSave: onSave,
    initial: initial,
    title: title,
    submitLabel: submitLabel,
  ),
);

class _MediaDialog extends StatefulWidget {
  const _MediaDialog({
    required this.onSave,
    required this.initial,
    required this.title,
    required this.submitLabel,
  });
  final Future<void> Function(String) onSave;
  final String initial;
  final String title;
  final String submitLabel;
  @override
  State<_MediaDialog> createState() => _MediaDialogState();
}

class _MediaDialogState extends State<_MediaDialog> {
  late final TextEditingController _controller;
  String? _error;
  bool _saving = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(_controller.text);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorMessage(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 580,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '输入可直接播放的 HTTPS 地址。这里只保存到本机，不会上传视频地址。',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.url,
              maxLength: 8192,
              decoration: InputDecoration(
                hintText: 'https://…/video.mp4',
                errorText: _error,
                counterText: '',
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TvButton(
        label: '取消',
        icon: Icons.close,
        onPressed: _saving ? null : () => Navigator.of(context).pop(false),
      ),
      TvButton(
        label: _saving ? '正在保存…' : widget.submitLabel,
        icon: Icons.play_arrow,
        primary: true,
        onPressed: _saving ? null : _save,
      ),
    ],
  );
}
