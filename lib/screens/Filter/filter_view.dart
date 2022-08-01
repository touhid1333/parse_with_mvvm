import 'package:flutter/material.dart';
import 'package:parse_with_mvvm/common/widgets/custom_appbar.dart';
import 'package:parse_with_mvvm/screens/Filter/filter_viewmodel.dart';
import 'package:parse_with_mvvm/screens/Filter/widgets/filter_view_body.dart';
import 'package:parse_with_mvvm/screens/view.dart';

class FilterView extends StatelessWidget {
  const FilterView({Key? key}) : super(key: key);

  //route name
  static const routeName = "/filterView";

  @override
  Widget build(BuildContext context) {
    return View(
      builder: (_, viewModel, __) {
        return Scaffold(
          appBar: const CustomAppbar(
            automaticallyImplyLeading: true,
          ),
          body: FilterViewBody(viewModel: viewModel),
        );
      },
      viewmodel: FilterViewModel(),
    );
  }
}
