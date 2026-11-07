import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/modules/layout/view/cubit/cubit.dart';
import 'package:news/modules/layout/view/cubit/states.dart';
import 'package:provider/provider.dart';

import '../../../../core/categorise/app_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../manager/layout_provider.dart';
import '../widegts/category_widget.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit , LayoutState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<LayoutCubit>(context);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Good Morning\nHere is Some News For You",
                style: TextStyle(fontSize: 24, color: AppColors.white),
              ),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: AppCategory.categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        cubit.onChanceCategory(

                          AppCategory.categories[index],
                        );
                      },
                      child: CategoryWidget(
                        category: AppCategory.categories[index],
                        isLeft: index % 2 == 0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
