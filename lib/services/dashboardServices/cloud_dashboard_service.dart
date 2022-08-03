import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_game_cloud_model.dart';

abstract class CloudDashboardService {
  Future<void> addGameToCloud(FavGameCloudModel item, String currentUser);

  Stream<QuerySnapshot<FavGameCloudModel>> getAllGames(ParseUser currentUser);

  Future<List<FavGameCloudModel>> getFutureGames(ParseUser currentuser);

  Future<bool> checkUserSession();

  Future<ParseUser> getUser();

  Future<bool> userLogout(ParseUser currentUser);

  Future<bool> saveFile(XFile pickedImage);

  Future<String> getFileURL(String endPath);
}
