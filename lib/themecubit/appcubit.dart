import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/themecubit/states.dart';

import 'package:shopapp/shared/network/local/cache_helper.dart';

class themeCubit extends Cubit<ThemeStates> {
  themeCubit() : super(AppInitialState());

  static themeCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeAppMode({bool? fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}