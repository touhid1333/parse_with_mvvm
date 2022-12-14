import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:parse_with_mvvm/common/services/custom_methods.dart';
import 'package:parse_with_mvvm/common/widgets/custom_progress.dart';
import 'package:parse_with_mvvm/common/widgets/show_dialog.dart';
import 'package:parse_with_mvvm/models/fav_game_cloud_model.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/screens/Filter/filter_view.dart';
import 'package:parse_with_mvvm/screens/dashboard/dashboard_viewmodel.dart';

final TextEditingController gameNameController = TextEditingController();
final TextEditingController gameRatingController = TextEditingController();

class DashboardBody extends StatefulWidget {
  final DashboardViewModel viewmodel;

  const DashboardBody({super.key, required this.viewmodel});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  await widget.viewmodel.pickImageFromGallery();
                },
                child: Container(
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: widget.viewmodel.pickedGameImage != null
                      ? Image.file(
                          File(widget.viewmodel.pickedGameImage!.path),
                          fit: BoxFit.fill,
                        )
                      : const Center(
                          child: Text(
                          "Pick Game Image",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: gameNameController,
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Game Name",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: gameRatingController,
                autocorrect: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Game Rating",
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                  onPressed: () async {
                    //---------Code for PARSE-------------
                    /*if (gameNameController.text.isNotEmpty &&
                        gameRatingController.text.isNotEmpty) {
                      if (widget.viewmodel.pickedGameImage != null) {
                        bool reponse = await widget.viewmodel.saveNewFavGame(
                            gameNameController.text,
                            int.parse(gameRatingController.text));
                        if (reponse) {
                          gameNameController.clear();
                          gameRatingController.clear();
                          widget.viewmodel.pickedGameImage = null;
                          widget.viewmodel.turnIdle();
                          Future.delayed(const Duration(seconds: 5))
                              .then((_) async => await createNotification());
                        }
                      }
                    }*/

                    //Code for -------------------Cloud---------------
                    if (gameNameController.text.isNotEmpty &&
                        gameRatingController.text.isNotEmpty) {
                      if (widget.viewmodel.pickedGameImage != null) {
                        await widget.viewmodel.saveGameToCloud(
                            gameNameController.text, gameRatingController.text);
                        gameNameController.clear();
                        gameRatingController.clear();
                        widget.viewmodel.pickedGameImage = null;
                        widget.viewmodel.turnIdle();
                        Future.delayed(const Duration(seconds: 1))
                            .then((_) async => await createNotification());
                      }
                    }
                  },
                  child: const Center(
                    child: Text("Submit"),
                  )),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FilterView.routeName);
                    },
                    child: const Text(
                      "Filter",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      CustomProgress progress = CustomProgress(context);
                      progress.buildProgress();
                      await progress.startProgress();
                      await widget.viewmodel.removeFavGameFromServer();
                      await progress.stopProgress();
                    },
                    child: const Text(
                      "Remove Marked",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              //future builder for parse
              /*Expanded(
                  child: FutureBuilder<List<FavGamesModel>>(
                future: widget.viewmodel.getAllFav(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()));
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var allGames = snapshot.data![index];
                              bool selected = false;
                              selected = widget.viewmodel
                                  .checkSelectedItem(allGames.objectId!);
                              return ListTile(
                                onTap: () {
                                  if (!selected) {
                                    widget.viewmodel
                                        .addSelectedItem(allGames.objectId!);
                                  } else {
                                    widget.viewmodel
                                        .removeSelectedItem(allGames.objectId!);
                                  }
                                },
                                leading: allGames.gameImage != null
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Image.network(
                                          allGames.gameImage.url,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : null,
                                title: Text(allGames.gameName),
                                //allGames.get<String>('game_name').toString()
                                trailing: Checkbox(
                                  value: selected,
                                  onChanged: (value) {},
                                ),
                              );
                            });
                      }
                  }
                },
              )),*/
              //stream builder for cloud
              Expanded(
                  child: FutureBuilder<List<FavGameCloudModel>>(
                      future: widget.viewmodel.getFutureGames(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              FavGameCloudModel item = snapshot.data[index];
                              return ListTile(
                                leading: item.imageUrl != null
                                    ? SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Image.network(
                                          item.imageUrl!,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : null,
                                title: Text(item.gameName!),
                              );
                            });
                      })),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUID(),
          channelKey: 'default_notifications',
          title: 'Favorite Game Creation',
          body: 'New game added to your account. Happy Gaming.',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: "https://www.dw.com/image/49519617_303.jpg"),
    );
  }
}
