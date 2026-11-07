import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/modules/layout/view/cubit/cubit.dart';

import '../../../../core/di/di.dart';
import '../cubit/states.dart';
import 'articles_screen.dart';
import 'category_screen.dart';
import 'article_search_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LayoutCubit>(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is GoToHomeState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = BlocProvider.of<LayoutCubit>(context);
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: AppBar(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              centerTitle: true,
              title: Text(cubit.selectedCategory?.name ?? "Home"),
              actions: [
                IconButton(
                  tooltip: "Search news",
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleSearchScreen(repo: cubit.repo),
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              backgroundColor: AppColors.black,
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: AppColors.white),
                    child: Center(
                      child: Text(
                        "News App",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.goToHome();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.home, color: AppColors.white, size: 34),
                          SizedBox(width: 16),
                          Text(
                            "GO To Home",
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            body: cubit.selectedCategory != null
                ? ArticlesScreen()
                : CategoryScreen(),
          );
        },
      ),
    );
  }
}
