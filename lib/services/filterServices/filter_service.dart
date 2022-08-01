
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';

abstract class FilterService{
  //filter fav game by date
  Future<List<FavGamesModel>> filterFavGameByDate(ParseUser currentUser,String startDate, String endDate);
  Future<ParseUser> getUser();
}