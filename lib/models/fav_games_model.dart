
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class FavGamesModel extends ParseObject implements ParseCloneable{

  FavGamesModel() : super("FavGames");
  FavGamesModel.clone() : this();

  @override
  dynamic clone(Map<String, dynamic> map) {
    return FavGamesModel.clone()..fromJson(map);
  }

  String get gameName => get('game_name');
  set gameName(String gameName) => set('game_name', gameName);

  int get gameRating => get('game_rating');
  set gameRating(int gameRating) => set('game_rating', gameRating);

  get gameImage => get('game_image');
  set gameImage(gameImage) => set('game_image', gameImage);

  get userPointer => get('user_pointer');
  set userPointer(userPointer) => set('user_pointer', userPointer);
}