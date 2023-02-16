import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslistitem.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../models/entry_model.dart';

class EntriesList extends StatefulWidget{
  const EntriesList({Key? key, required this.entryCategory}) : super(key: key);

  final EntryCategory entryCategory;

  @override
  State<EntriesList> createState() => EntriesListState();
}

class EntriesListState extends State<EntriesList> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  late FeedsViewModel feedsViewModel;
  final PagingController<int, EntryModel> pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    pagingController.addPageRequestListener((pageKey) async{
      await feedsViewModel.fetchSomeEntriesForCategory(widget.entryCategory, pageKey, pagingController);
    });

    super.initState();
  }

  @override
  void dispose() {
    debugPrint("Disposing EntriesList for category: ${widget.entryCategory}");
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("Building EntriesList for category: ${widget.entryCategory}");

    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, EntryModel>(
        physics: const AlwaysScrollableScrollPhysics(),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<EntryModel>(
          itemBuilder: (context, item, index) => EntriesListItem(entryID: item.entryID, displayedEntryCategory: widget.entryCategory),
          firstPageErrorIndicatorBuilder: (context) {
            pagingController.refresh();
            return const Center(
              child: Text("Error loading entries"),
            );
          },
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Text("No entries found"),
          ),
        ),
      )
    );
  }
}