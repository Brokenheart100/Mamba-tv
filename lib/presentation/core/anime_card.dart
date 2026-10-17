import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/models.dart';
import 'tv_focus.dart';

class AnimeImage extends StatelessWidget {
  const AnimeImage({super.key, required this.anime, this.fit = BoxFit.cover});
  final Anime anime;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF30304D + anime.id % 4 * 0x080200),
            const Color(0xFF181928),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.movie_filter_outlined, color: muted, size: 44),
      ),
    );
    if (anime.image.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: anime.image,
      fit: fit,
      memCacheWidth: 700,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    super.key,
    required this.anime,
    required this.onPressed,
    this.autofocus = false,
    this.subtitle,
  });
  final Anime anime;
  final VoidCallback onPressed;
  final bool autofocus;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => TvFocus(
    label: anime.title,
    autofocus: autofocus,
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimeImage(anime: anime),
                  if (anime.score > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: canvas.withValues(alpha: .85),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '★ ${anime.score.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Color(0xFFF4D28D),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            anime.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Text(
            subtitle ?? (anime.date.isEmpty ? '番剧资料 · Bangumi' : anime.date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    ),
  );
}
