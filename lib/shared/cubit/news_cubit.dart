import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business_news/business_news.dart';
import 'package:news_app/modules/science_news.dart/science_news.dart';
import 'package:news_app/modules/setting_news/setting_news.dart';
import 'package:news_app/modules/sports_news/sports_news.dart';
import 'package:news_app/shared/cubit/news_states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitState());
  int currentIndex = 0;
  bool isDark = false;
  List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business_center),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports_volleyball_rounded),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science_rounded),
      label: 'Science',
    ),
  ];
  List<Widget> screens = [
    BusinessNews(),
    SportsNews(),
    ScienceNews(),
  ];
  static NewsCubit get(context) => BlocProvider.of(context);

  void changeAppMode({bool? fromMain}) {
    if (fromMain != null) {
      isDark = fromMain;
    } else {
      this.isDark = !isDark;
      CasheHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(NewsChangeAppModeState());
      });
      print('app mode is $isDark');
    }
  }

  void changeCurrentIndex({required int index}) {
    currentIndex = index;
    emit(NewsChangeCurrentIndexState());
    if (index == 1) {
      emit(NewsloadingGetSPortsState());

      if (sports!.length == 0) {
        DioHelper.getData(
          path: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'sports',
            'apiKey': '798c0cf294374d389942a0cf385aaa45',
          },
        ).then((value) {
          sports = value.data;
          emit(NewsGetSPortsState());
        }).catchError((onError) {
          print('the error in sports api is $onError');
          emit(NewsErrorSportsState());
        });
      } else {
        emit(NewsGetSPortsState());
      }
    } else if (index == 2) {
      emit(NewsloadingGetScienceState());
      if (science!.length == 0) {
        DioHelper.getData(
          path: 'v2/top-headlines',
          query: {
            'country': 'eg',
            'category': 'science',
            'apiKey': '798c0cf294374d389942a0cf385aaa45',
          },
        ).then((value) {
          science = value.data;
          emit(NewsGetScienceState());
        }).catchError((onError) {
          print('the error in sports api is $onError');
          emit(NewsErrorScienceState());
        });
      } else {
        emit(NewsGetScienceState());
      }
    }
  }

  Map<dynamic, dynamic>? business = {};
  Map<dynamic, dynamic>? sports = {};
  Map<dynamic, dynamic>? science = {};
  List search = [];

  void getBusiness() {
    emit(NewsloadingGetBusinessState());
    DioHelper.getData(
      path: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': '798c0cf294374d389942a0cf385aaa45',
      },
    ).then((value) {
      business = value.data;
      // print(business);
      emit(NewsGetBusinessState());
    }).catchError((onError) {
      print('Dio Error!!->$onError');
      emit(NewsErrorBusinessState());
    });
  }

  void getSearch({required String key}) {
    emit(NewsloadingGetSearchState());
    DioHelper.getData(
      path: 'v2/everything',
      query: {
        'q': '$key',
        'apiKey': '798c0cf294374d389942a0cf385aaa45',
      },
    ).then((value) {
      search = value.data['articles'];
      print('hellllllllllllllllo $search');
      emit(NewsGetSearchState());
    }).catchError((onError) {
      print('Dio Error!!->$onError');
      emit(NewsErrorSearchState());
    });
  }
}
