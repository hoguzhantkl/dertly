import 'dart:collection';

import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../models/answer_model.dart';
import '../../../view_models/answer_viewmodel.dart';
import 'answerlistitem.dart';

class MainAnswersList extends StatefulWidget{
  const MainAnswersList({super.key});

  @override
  State<MainAnswersList> createState() => MainAnswersListState();
}

class MainAnswersListState extends State<MainAnswersList> {
  final PagingController<int, AnswerModel> pagingController = PagingController(firstPageKey: 0);

  late EntryViewModel entryViewModel;

  @override
  void initState() {
    entryViewModel = Provider.of<EntryViewModel>(context, listen: false);

    pagingController.addPageRequestListener((pageKey) async{
      await entryViewModel.fetchSomeEntryAnswers(pageKey, pagingController);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, AnswerModel>(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<AnswerModel>(
            itemBuilder: (context, item, index) {
              return AnswerListItem(answerViewModel: AnswerViewModel(model: item));
            },
            firstPageProgressIndicatorBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            firstPageErrorIndicatorBuilder: (context) {
              pagingController.refresh();
              return const Center(
                child: Text("Error loading answers"),
              );
            },
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text("No answers found"),
            ),
          ),
        )
    );
  }

}