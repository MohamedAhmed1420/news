import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/layout/data/models/news_response.dart';
import 'package:news/modules/layout/data/repo/repo.dart';

import '../../../../core/theme/app_colors.dart';
import 'article_details_screen.dart';

class ArticleSearchScreen extends StatefulWidget {
  final Repo repo;
  const ArticleSearchScreen({super.key, required this.repo});

  @override
  State<ArticleSearchScreen> createState() => _ArticleSearchScreenState();
}

class _ArticleSearchScreenState extends State<ArticleSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Articles> _results = [];
  bool _loading = false;
  String? _error;

  void _search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
        _error = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      setState(() {
        _loading = true;
        _error = null;
      });
      try {
        final results = await widget.repo.searchNews(query.trim());
        if (!mounted || _controller.text.trim() != query.trim()) return;
        setState(() {
          _results = results;
          _loading = false;
        });
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = error.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.white),
          decoration: const InputDecoration(
            hintText: "Search news",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.white)),
            )
          : _controller.text.trim().isEmpty
          ? const Center(
              child: Text(
                "Search by topic, person, or keyword",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : _results.isEmpty
          ? const Center(
              child: Text(
                "No articles found",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _SearchResult(article: _results[index]),
            ),
    );
  }
}

class _SearchResult extends StatelessWidget {
  final Articles article;
  const _SearchResult({required this.article});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailsScreen(article: article)),
    ),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.urlToImage ?? "",
              width: 105,
              height: 90,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const SizedBox(
                width: 105,
                height: 90,
                child: Icon(Icons.image_not_supported, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.source?.name ?? article.author ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
