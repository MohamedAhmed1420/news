import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/modules/layout/data/models/news_response.dart';
import 'package:news/modules/layout/view/cubit/cubit.dart';
import 'package:news/modules/layout/view/cubit/states.dart';

import '../../../../core/theme/app_colors.dart';
import 'article_details_screen.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<LayoutCubit, LayoutState>(
          buildWhen: (_, current) =>
              current is GetSourceErrorState ||
              current is GetSourceLoadingState ||
              current is GetSourceSuccessState,
          builder: (context, state) {
            final cubit = context.read<LayoutCubit>();
            if (state is GetSourceSuccessState && cubit.sources.isNotEmpty) {
              return DefaultTabController(
                length: cubit.sources.length,
                child: TabBar(
                  onTap: (index) => cubit.onChangeSource(cubit.sources[index]),
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.white,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white,
                  tabs: cubit.sources
                      .map((source) => Tab(text: source.name ?? ""))
                      .toList(),
                ),
              );
            }
            if (state is GetSourceLoadingState) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetSourceErrorState) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        BlocBuilder<LayoutCubit, LayoutState>(
          buildWhen: (_, current) =>
              current is GetNewsSuccessState ||
              current is GetNewsLoadingState ||
              current is GetNewsErrorState,
          builder: (context, state) {
            final cubit = context.read<LayoutCubit>();
            if (state is GetNewsSuccessState) {
              if (cubit.articles.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "No articles found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cubit.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) =>
                      _ArticleCard(article: cubit.articles[index]),
                ),
              );
            }
            if (state is GetNewsLoadingState) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is GetNewsErrorState) {
              return Expanded(
                child: Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            return const Expanded(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Articles article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ArticlePreview(article: article),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(
                  height: 190,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const SizedBox(
                  height: 190,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "By: ${article.author ?? article.source?.name ?? "Unknown"}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Text(
                  _date(article.publishedAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticlePreview extends StatelessWidget {
  final Articles article;
  const _ArticlePreview({required this.article});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? "",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const SizedBox(
                  height: 180,
                  child: Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.title ?? "",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              (article.description ?? article.content ?? "").replaceAll(
                RegExp(r'\s*\[\+\d+ chars\]'),
                "",
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailsScreen(article: article),
                    ),
                  );
                },
                child: const Text("View Full Article"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _date(String? value) =>
    value != null && value.length >= 10 ? value.substring(0, 10) : "";
