import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/model/shop_app/login_model.dart';
import 'package:shopapp/modules/shop_app/register/cubit/states.dart';
import 'package:shopapp/shared/network/end_point.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  ShopLoginModel? loginModel;

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
}) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'email':email,
        'name':name,
        'password':password,
        'phone':phone,
      },
    ).then((value) {

      print(value.data);
     loginModel = ShopLoginModel.fromJson(value.data);

       print(loginModel?.status);
       // print(loginModel?.message);
       // print(loginModel?.data?.token);


      emit(ShopRegisterSuccessState(loginModel!));
    }).catchError((error){

      emit(ShopRegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

    IconData suffix =  Icons.visibility_outlined;
    bool isPassword = true;

  void ChangePasswordVisibilty() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
