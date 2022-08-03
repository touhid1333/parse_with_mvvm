import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_with_mvvm/models/fav_game_cloud_model.dart';
import 'package:parse_with_mvvm/services/dashboardServices/cloud_dashboard_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class CloudDashboardServiceIMPL extends CloudDashboardService {
  final cloudDB = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  @override
  Future<void> addGameToCloud(
      FavGameCloudModel item, ParseUser currentUser) async {
    final docRef = cloudDB
        .collection("FavGames")
        .doc(currentUser.objectId)
        .collection("allGames")
        .withConverter(
            fromFirestore: FavGameCloudModel.fromFirestore,
            toFirestore: (FavGameCloudModel model, options) =>
                model.toFirestore())
        .doc();
    await docRef.set(item);
  }

  @override
  Stream<QuerySnapshot<FavGameCloudModel>> getAllGames(ParseUser currentUser) {
    final docRef = cloudDB
        .collection("FavGames")
        .doc(currentUser.objectId)
        .collection("allGames")
        .withConverter(
            fromFirestore: FavGameCloudModel.fromFirestore,
            toFirestore: (FavGameCloudModel model, _) => model.toFirestore());
    return docRef.snapshots();
  }

  @override
  Future<List<FavGameCloudModel>> getFutureGames(ParseUser currentuser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await cloudDB
        .collection("FavGames")
        .doc(currentuser.objectId)
        .collection("allGames")
        .get();
    return snapshot.docs
        .map((docSnapshot) => FavGameCloudModel.fromDocumentSnapshot(docSnapshot))
        .toList();
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
  Future<bool> saveFile(ip.XFile pickedImage ) async{
    String filePathString = path.basename(pickedImage.path);
    File fileToSave = File(pickedImage.path);
    try{
      await storage.ref(filePathString).putFile(fileToSave);
      return true;
    } on FirebaseException catch(e){
      debugPrint(e.message);
      return false;
    }
  }

  @override
  Future<String> getFileURL(String endPath ) async{
    final storageRef = storage.ref();
    String downUrl = await storageRef.child(endPath).getDownloadURL();
    debugPrint("------------------$downUrl------------------");
    return downUrl;
  }
}
