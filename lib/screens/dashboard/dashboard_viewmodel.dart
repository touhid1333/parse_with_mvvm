
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/dependencies/dependencies.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/screens/viewmodel.dart';
import 'package:parse_with_mvvm/services/dashboardServices/dashboard_service.dart';

class DashboardViewModel extends Viewmodel {
  DashboardService get _service => dependency();

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
    return await _service.checkUserSession();
  }

  //get current logged user
  Future<ParseUser> getCurrentUser() async {
    return await _service.getUser();
  }

  //logout
  Future<bool> userLogout() async {
    return _service.userLogout(currentUser!);
  }
}
