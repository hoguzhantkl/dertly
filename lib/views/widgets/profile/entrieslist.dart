import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslistitem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../models/entry_model.dart';

class ProfileEntriesList extends StatefulWidget{
  const ProfileEntriesList({Key? key, this.userID = ""}) : super(key: key);

  final String userID;
  final EntryCategory entryCategory = EntryCategory.profile;

  @override
  State<ProfileEntriesList> createState() => ProfileEntriesListState();
}

class ProfileEntriesListState extends State<ProfileEntriesList> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  late UserViewModel userViewModel;
  final PagingController<int, EntryModel> pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

    pagingController.addPageRequestListener((pageKey) async{
      await userViewModel.fetchSomeUserEntries(pageKey, pagingController);
      // TODO: set the returned userModel if the userID is the same as the current user (for my profile)
    });

    super.initState();
  }

  @override
  void dispose() {
    debugPrint("Disposing ProfileEntriesList for userID: ${widget.userID}");
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("Building ProfileEntriesList for userID: ${widget.userID}");

    return RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, EntryModel>(
          physics: const AlwaysScrollableScrollPhysics(),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<EntryModel>(
            itemBuilder: (context, item, index) => EntriesListItem(entryModel: item, entryID: item.entryID, displayedEntryCategory: widget.entryCategory),
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