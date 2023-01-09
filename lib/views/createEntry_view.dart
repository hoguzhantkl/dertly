import 'package:dertly/view_models/createEntry_viewmodel.dart';
import 'package:flutter/material.dart';

class CreateEntryScreen extends StatelessWidget {
  const CreateEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateEntryViewModel createEntryViewModel = CreateEntryViewModel();
    
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
              'Create a auto generated test entry',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: (){
                  createEntryViewModel.createTestEntry()
                      .then((value) => {
                        print("Entry Created ${value.entryID}")
                      })
                      .catchError((error) => {
                        print("Entry Creation Failed ${error.toString()}")
                      });
                },
                child: const Text("Create Entry")
            )
          ],
        ),
      ),
    );
  }
}