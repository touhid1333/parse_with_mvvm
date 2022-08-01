import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_with_mvvm/models/fav_games_model.dart';
import 'package:parse_with_mvvm/screens/Filter/filter_viewmodel.dart';

class FilterViewBody extends StatelessWidget {
  final FilterViewModel viewModel;

  FilterViewBody({super.key, required this.viewModel});

  //controllers
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2024));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      _startDateController.text = formattedDate;
                    }
                  },
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.calendar_month,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      hintText: "Start Date",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    keyboardType: TextInputType.none,
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2024));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      _endDateController.text = formattedDate;
                    }
                  },
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.calendar_month,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      hintText: "End Date",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    keyboardType: TextInputType.none,
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if(_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty){
                    await viewModel.getFilteredList(
                        _startDateController.text, _endDateController.text);
                  }

                },
                child: const Text(
                  "Filter",
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.filteredList.length,
                itemBuilder: (context, index) {
                  FavGamesModel item = viewModel.filteredList[index];
                  return ListTile(
                    leading: Text(item.gameName),
                    trailing: Text(item.gameRating.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
