import 'package:dertly/view_models/createEntry_viewmodel.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEntryScreen extends StatelessWidget {
  const CreateEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateEntryViewModel createEntryViewModel = CreateEntryViewModel();
    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Create an auto generated test entry',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: (){
                  createEntryViewModel.createTestEntry()
                      .then((value) => {
                        debugPrint("Entry Created ${value.entryID}")
                      })
                      .catchError((error) => {
                        debugPrint("Entry Creation Failed ${error.toString()}")
                      });
                },
                child: const Text("Create Entry")
            ),
            ElevatedButton(
                onPressed: (){
                  feedsViewModel.fetchSomeRecentEntries(0, 2)
                      .catchError((error) => {
                        debugPrint("Recent Entry Fetching Failed ${error.toString()}")
                      });
                },
                child: const Text("Fetch and List Recent Entries")
            ),
            ElevatedButton(
                onPressed: (){
                  feedsViewModel.fetchAllTrendEntries()
                      .catchError((error) {
                        debugPrint("Trend Entry Fetching Failed ${error.toString()}");
                      });
                },
                child: const Text("Fetch and List Trending Entries")
            )
          ],
        ),
      ),
    );
  }
}