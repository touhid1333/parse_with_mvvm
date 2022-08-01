import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';

abstract class DashboardService{
  //abstract classes
  Future<List<FavGamesModel>> favGames(ParseUser user);
  Future<ParseFileBase?> saveFileToServer(XFile pickedFile);
  Future<bool> addNewFavGame(String gameName, int gameRating, ParseFileBase parseFile,ParseUser user);
  removeFavGame(List<String> selectedItems);
  Future<bool> checkUserSession();
  Future<ParseUser> getUser();
  Future<bool> userLogout(ParseUser currentUser);
}