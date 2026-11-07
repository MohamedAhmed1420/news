import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/layout/data/models/news_response.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Articles article;
  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final body =
        (article.content ??
                article.description ??
                "No additional article details are available.")
            .replaceAll(RegExp(r'\s*\[\+\d+ chars\]'), "");
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        title: Text(article.source?.name ?? "Article"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "By ${article.author ?? "Unknown"}  •  ${article.publishedAt?.split("T").first ?? ""}",
              style: const TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 18),
            if ((article.urlToImage ?? "").isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 18),
            if ((article.description ?? "").isNotEmpty)
              Text(
                article.description!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 14),
            Text(
              body,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            if ((article.url ?? "").isNotEmpty) ...[
              const SizedBox(height: 20),
              SelectableText(
                "Original article: ${article.url}",
                style: const TextStyle(color: Colors.lightBlueAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
