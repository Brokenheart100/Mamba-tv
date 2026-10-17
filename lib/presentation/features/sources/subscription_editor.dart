import 'package:flutter/material.dart';

import '../../core/error_message.dart';
import '../../core/tv_focus.dart';

class SubscriptionEditor extends StatefulWidget {
  const SubscriptionEditor({super.key, required this.onSave});
  final Future<void> Function(String) onSave;
  @override
  State<SubscriptionEditor> createState() => _SubscriptionEditorState();
}

class _SubscriptionEditorState extends State<SubscriptionEditor> {
  final _url = TextEditingController();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSave(_url.text.trim());
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorMessage(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('添加 Animeko 在线订阅'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '粘贴 Animeko 在线数据源订阅的 HTTPS JSON 地址。支持 web-selector 与 json-api；BT / RSS 暂未接入下载引擎。',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _url,
              autofocus: true,
              enabled: !_busy,
              decoration: InputDecoration(labelText: '订阅地址', errorText: _error),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TvButton(
        label: '取消',
        icon: Icons.close,
        onPressed: _busy ? null : () => Navigator.pop(context),
      ),
      TvButton(
        label: _busy ? '导入中…' : '导入订阅',
        icon: Icons.download,
        onPressed: _busy ? null : _save,
      ),
    ],
  );
}
