

import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/services/dashboardServices/dashboard_service.dart';

class ParseDashboardServices implements DashboardService {
  @override
  Future<List<FavGamesModel>> favGames(ParseUser user) async {
    QueryBuilder<FavGamesModel> getFavGamesQuery =
        QueryBuilder<FavGamesModel>(FavGamesModel());
    getFavGamesQuery.whereEqualTo('user_pointer', user.toPointer());
    return await getFavGamesQuery.find();
  }

  @override
  addNewFavGame(String gameName, int gameRating, ParseFileBase parseFile,
      ParseUser user) async {
    FavGamesModel model = FavGamesModel();
    model.gameName = gameName;
    model.gameRating = gameRating;
    model.gameImage = parseFile;
    model.userPointer = user.toPointer();
    var saveResponse = await model.save();
    if (saveResponse.success) {
      return true;
    } else {
      return false;
    }
  }

  @override
  removeFavGame(List<String> selectedItems) async {
    for (String objectId in selectedItems) {
      FavGamesModel model = FavGamesModel();
      model.objectId = objectId;
      await model.delete();
    }
  }

  @override
  Future<bool> checkUserSession() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }

    //check sessionToken
    final ParseResponse? sessionResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (sessionResponse == null || !sessionResponse.success) {
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<ParseUser> getUser() async {
    ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
    return currentUser;
  }

  @override
  Future<bool> userLogout(ParseUser currentUser) async {
    final ParseResponse response = await currentUser.logout();
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<ParseFileBase?> saveFileToServer(img.XFile pickedFile) async {
    ParseFileBase parseFile = ParseFile(File(pickedFile.path));
    final response = await parseFile.save();
    if (response.success) {
      return parseFile;
    } else {
      return null;
    }
  }
}
