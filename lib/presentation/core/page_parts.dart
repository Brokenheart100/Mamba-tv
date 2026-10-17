import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'tv_focus.dart';

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key, this.trailing});
  final String title;
  final String subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: muted)),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.loading = false,
  });
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final bool loading;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const CircularProgressIndicator()
          else
            const Icon(Icons.auto_awesome_outlined, color: accent, size: 42),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (message != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted),
              ),
            ),
          if (onRetry != null)
            TvButton(
              label: '重试',
              icon: Icons.refresh,
              onPressed: onRetry,
              autofocus: true,
            ),
        ],
      ),
    ),
  );
}

String formatTime(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}

String episodeLabel(double sort) => sort == sort.roundToDouble()
    ? sort.toInt().toString().padLeft(2, '0')
    : sort.toString();
