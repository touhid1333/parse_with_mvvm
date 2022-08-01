
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/services/filterServices/filter_service.dart';

class ParseFilterService extends FilterService{
  @override
  Future<List<FavGamesModel>> filterFavGameByDate(ParseUser currentUser, String startDate, String endDate) async{
    QueryBuilder<FavGamesModel> getFilteredList =
    QueryBuilder<FavGamesModel>(FavGamesModel());
    getFilteredList.whereEqualTo("user_pointer", currentUser.toPointer());
    getFilteredList.whereGreaterThan("updatedAt", DateTime.parse(startDate));
    getFilteredList.whereLessThanOrEqualTo("updatedAt", DateTime.parse(endDate));
    getFilteredList.setLimit(2);
    getFilteredList.setAmountToSkip(3);

    final List<FavGamesModel> responseList = await getFilteredList.find();
    return responseList;
  }

  @override
  Future<ParseUser> getUser() async{
    ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
    return currentUser;
  }
}