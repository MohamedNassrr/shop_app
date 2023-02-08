import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layout/shop_layout/cubit/states.dart';
import 'package:shopapp/model/shop_app/categories_model.dart';
import 'package:shopapp/model/shop_app/change_favorites.dart';
import 'package:shopapp/model/shop_app/favorites_model.dart';
import 'package:shopapp/model/shop_app/home_model.dart';
import 'package:shopapp/model/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/categories/categories_screen.dart';
import 'package:shopapp/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shopapp/modules/shop_app/products/products_screen.dart';
import 'package:shopapp/modules/shop_app/settings/settings_screen.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStats());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomsScreen = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index){

    currentIndex = index;
    emit(ShopChangeBottomNavStats());
  }

  HomeModel? homeModel;

  Map<int?, bool?> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataStats());

    DioHelper.getData(
        url: HOME,
        token: token,
    ).then((value) {

      homeModel = HomeModel.fromJson(value.data);

        // printFullText(homeModel!.data!.banners[0].image);
        // print(homeModel?.status);

        homeModel!.data!.products.forEach((element) {
          favorites.addAll({
            element.id: element.inFavorites,
          });
        });
        // print(favorites.toString());

      emit(ShopSuccessHomeDataStats());

    }).catchError((error) {

      print(error.toString());
      emit(ShopErrorHomeDataStats());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {

      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesStats());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesStats());
    });
  }

    ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {

    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesStats());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    )
      .then((value) {
        changeFavoritesModel= ChangeFavoritesModel.fromJson(value.data!);
        // print(value.data);

        if(!changeFavoritesModel!.status!){
          favorites[productId] = !favorites[productId]!;
        }else{
          getFavorites();
        }

        emit(ShopSuccessChangeFavoritesStats(changeFavoritesModel));
    })
      .catchError((error) {
        favorites[productId] = !favorites[productId]!;
        emit(ShopErrorChangeFavoritesStats());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesStats());
    DioHelper.getData(
      url: FAVORITES,
      token: token,

    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      // printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesStats());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesStats());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataStats());
    DioHelper.getData(
      url: PROFILE,
      token: token,

    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name);

      emit(ShopSuccessUserDataStats(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataStats());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
}) {
    emit(ShopLoadingUpdateUserStats());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
          'name': name,
          'email': email,
          'phone': phone,
      }
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name);

      emit(ShopSuccessUpdateUserStats(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserStats());
    });
  }
}