import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/model/shop_app/search_model.dart';
import 'package:shopapp/modules/shop_app/search/cubit/states.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(ShopSearchLoadingState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {
      emit(ShopSearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
          'text':text,
      },
    ).then((value) {
        model = SearchModel.fromJson(value.data);

        emit(ShopSearchSuccessState());
    }).catchError((error){

        print(error.toString());
        emit(ShopSearchErrorState());
    });
  }
}
