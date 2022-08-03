import 'package:cloud_firestore/cloud_firestore.dart';

class FavGameCloudModel {
  final String? objectId;
  final String? gameName;
  final int? gameRating;
  final String? imageUrl;

  FavGameCloudModel(
      {this.objectId, this.gameName, this.gameRating, this.imageUrl});

  factory FavGameCloudModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return FavGameCloudModel(
        objectId: data?['objectId'],
        gameName: data?['gameName'],
        gameRating: data?['gameRating'],
        imageUrl: data?['imageUrl']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (objectId != null) "objectId": objectId,
      if (gameName != null) "gameName": gameName,
      if (gameRating != null) "gameRating": gameRating,
      if (imageUrl != null) "imageUrl": imageUrl
    };
  }

  FavGameCloudModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> docSnap)
      : objectId = docSnap.data()!["objectId"],
        gameName = docSnap.data()!["gameName"],
        gameRating = docSnap.data()!["gameRating"],
        imageUrl = docSnap.data()!["imageUrl"];
}
