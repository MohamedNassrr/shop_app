import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/bloc_observer.dart';
import 'package:shopapp/layout/shop_layout/cubit/cubit.dart';
import 'package:shopapp/layout/shop_layout/shop_layout.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/themecubit/appcubit.dart';
import 'package:shopapp/themecubit/states.dart';
import 'package:shopapp/modules/shop_app/login/shop_login_screen.dart';
import 'package:shopapp/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shopapp/shared/network/local/cache_helper.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';
import 'package:shopapp/shared/styles/themes.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();


  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();

      bool? isDark = CacheHelper.getData(key: "isDark");

      Widget widget;

      bool? onBoarding = CacheHelper.getData(key: "onBoarding");
      token = CacheHelper.getData(key: "token");
      print(token);

      if (onBoarding != null) {
        if (token != null) {
          widget = ShopLayout();
        } else {
          widget = ShopLoginScreen();
        }
      } else {
        widget = onBoardingScreen();
      }

      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget? startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategories()
              ..getFavorites()
              ..getUserData()),
        BlocProvider(
          create: (BuildContext context) =>
              themeCubit()..changeAppMode(fromShared: isDark),
        ),
      ],
      child: BlocConsumer<themeCubit, ThemeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                // TODO: Change first ThemeMode TO dark
                themeCubit.get(context).isDark
                    ? ThemeMode.light
                    : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
