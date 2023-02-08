import 'package:shopapp/model/shop_app/change_favorites.dart';
import 'package:shopapp/model/shop_app/login_model.dart';

abstract class ShopStates{}

class ShopInitialStats extends ShopStates{}

class ShopChangeBottomNavStats extends ShopStates{}

class ShopLoadingHomeDataStats extends ShopStates{}

class ShopSuccessHomeDataStats extends ShopStates{}

class ShopErrorHomeDataStats extends ShopStates{}

class ShopSuccessCategoriesStats extends ShopStates{}

class ShopErrorCategoriesStats extends ShopStates{}

class ShopSuccessChangeFavoritesStats extends ShopStates{
  final ChangeFavoritesModel? model;

  ShopSuccessChangeFavoritesStats(this.model);
}

class ShopChangeFavoritesStats extends ShopStates{}

class ShopErrorChangeFavoritesStats extends ShopStates{}

class ShopSuccessGetFavoritesStats extends ShopStates{}

class ShopErrorGetFavoritesStats extends ShopStates{}

class ShopLoadingGetFavoritesStats extends ShopStates{}

class ShopSuccessUserDataStats extends ShopStates{
  final ShopLoginModel? loginModel;

  ShopSuccessUserDataStats(this.loginModel);
}

class ShopErrorUserDataStats extends ShopStates{}

class ShopLoadingUserDataStats extends ShopStates{}

class ShopSuccessUpdateUserStats extends ShopStates{
  final ShopLoginModel? loginModel;

  ShopSuccessUpdateUserStats(this.loginModel);
}

class ShopErrorUpdateUserStats extends ShopStates{}

class ShopLoadingUpdateUserStats extends ShopStates{}
