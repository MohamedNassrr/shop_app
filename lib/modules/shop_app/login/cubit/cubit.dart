import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/model/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/login/cubit/states.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  ShopLoginModel? loginModel;

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
}) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email':email,
        'password':password,
      },
    ).then((value) {

      print(value.data);
     loginModel = ShopLoginModel.fromJson(value.data);

       print(loginModel?.status);
       // print(loginModel?.message);
       // print(loginModel?.data?.token);


      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error){

      emit(ShopLoginErrorState(error.toString()));
      print(error.toString());
    });
  }

    IconData suffix =  Icons.visibility_outlined;
    bool isPassword = true;

  void ChangePasswordVisibilty() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibilityState());
  }
}
