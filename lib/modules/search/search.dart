import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/news_cubit.dart';
import 'package:news_app/shared/cubit/news_states.dart';

class Search extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List? list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: commonTextFormField(
                  controller: searchController,
                  validator: (String? value) {
                    if (value!.isEmpty) return 'type to search';
                  },
                  labelText: 'Search',
                  preFixIcon: Icons.search,
                  onChanged: (String value) {
                    NewsCubit.get(context).getSearch(
                      key: value,
                    );
                  },
                ),
              ),
              Expanded(
                  child: getArticles(
                list: list,
                state: state,
                isSearch: true,
              )),
            ],
          ),
        );
      },
    );
  }
}
