import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart';
import 'package:parse_with_mvvm/models/fav_game_cloud_model.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/screens/viewmodel.dart';
import 'package:parse_with_mvvm/services/dashboardServices/cloud_dashboard_service.dart';
import 'package:parse_with_mvvm/services/dashboardServices/dashboard_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class DashboardViewModel extends Viewmodel {
  //DashboardService get _service => dependency();

  var _service;

  CloudDashboardService get _cloudService => dependency();

  List<String> selectedListItems = [];

  ParseUser? currentUser;

  XFile? pickedGameImage;

  pickImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      turnBusy();
      pickedGameImage = image;
      turnIdle();
    }
  }

  bool checkSelectedItem(String objectId) {
    bool selected = false;
    for (var element in selectedListItems) {
      if (element == objectId) {
        selected = true;
      }
    }
    return selected;
  }

  addSelectedItem(String objectId) {
    turnBusy();
    selectedListItems.add(objectId);
    turnIdle();
  }

  removeSelectedItem(String objectId) {
    turnBusy();
    selectedListItems.remove(objectId);
    turnIdle();
  }

  //save game to server
  Future<bool> saveNewFavGame(String gameName, int gameRating) async {
    var parseFile = await _service.saveFileToServer(pickedGameImage!);
    if (parseFile != null) {
      turnBusy();
      var response = await _service.addNewFavGame(
        gameName,
        gameRating,
        parseFile,
        currentUser!,
      );
      return response;
    } else {
      return false;
    }
  }

  //get all game
  Future<List<FavGamesModel>> getAllFav() async {
    if (currentUser != null) {
      return await _service.favGames(currentUser!);
    } else {
      currentUser = await getCurrentUser();
      return await _service.favGames(currentUser!);
    }
  }

  //remove game
  removeFavGameFromServer() async {
    if (selectedListItems.isNotEmpty) {
      turnBusy();
      await _service.removeFavGame(selectedListItems);
      turnIdle();
    }
  }

  //check session
  Future<bool> checkUserSession() async {
    //return await _service.checkUserSession();
    return await _cloudService.checkUserSession();
  }

  //get current logged user
  Future<ParseUser> getCurrentUser() async {
    //return await _service.getUser();
    return await _cloudService.getUser();
  }

  //logout
  Future<bool> userLogout() async {
    //return _service.userLogout(currentUser!);
    return _cloudService.userLogout(currentUser!);
  }

  //cloud game save
  saveGameToCloud(String gameName, String gameRating) async {
    if (await saveFileToStorage()) {
      turnBusy();
      FavGameCloudModel item = FavGameCloudModel(
          gameName: gameName,
          gameRating: int.parse(gameRating),
          imageUrl: path.basename(pickedGameImage!.path));
      await _cloudService.addGameToCloud(item, "lTHWMNIA2D");
    }
  }

  //get games from cloud
  Future<List<FavGameCloudModel>> getFutureGames() async {
    turnBusy();
    List<FavGameCloudModel> newAllGames = [];
    if (currentUser != null) {
      List<FavGameCloudModel> allGames =
          await _cloudService.getFutureGames(currentUser!);

      for (FavGameCloudModel item in allGames) {
        String downURl = await getFileURL(item.imageUrl!);
        FavGameCloudModel model = FavGameCloudModel(
            gameName: item.gameName,
            gameRating: item.gameRating,
            imageUrl: downURl);
        newAllGames.add(model);
      }
    } else {
      currentUser = await getCurrentUser();
      List<FavGameCloudModel> allGames =
          await _cloudService.getFutureGames(currentUser!);

      for (FavGameCloudModel item in allGames) {
        String downURl = await getFileURL(item.imageUrl!);
        FavGameCloudModel model = FavGameCloudModel(
            gameName: item.gameName,
            gameRating: item.gameRating,
            imageUrl: downURl);
        newAllGames.add(model);
      }
    }

    return newAllGames;
  }

  //save files to storage
  Future<bool> saveFileToStorage() async {
    return await _cloudService.saveFile(pickedGameImage!);
  }

  //get file download link
  Future<String> getFileURL(String endPath) async {
    return await _cloudService.getFileURL(endPath);
  }
}
