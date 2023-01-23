import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/entry_model.dart';
import '../../../view_models/feeds_viewmodel.dart';

class EntryInfos extends StatefulWidget {
  const EntryInfos({super.key});

  @override
  State<EntryInfos> createState() => EntryInfosState();
}

class EntryInfosState extends State<EntryInfos> {
  @override
  Widget build(BuildContext context) {
    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    EntryModel? listeningEntryModel = feedsViewModel.getCurrentListeningEntryModel();

    if (listeningEntryModel == null) {
      debugPrint("EntryModel for EntryInfos could not be get from feedsViewModel.getCurrentListeningEntryModel, model is null");
      return const SizedBox(width: 0, height: 0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.arrow_upward_rounded, size: 24),
            Text("${listeningEntryModel.upVote}", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            Icon(Icons.arrow_downward_rounded, size: 24),
            Text("${listeningEntryModel.downVote}", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            Icon(Icons.mic, size: 24),
            Text("${listeningEntryModel.totalAnswers}", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: const [
            Icon(Icons.star, size: 24, color: Colors.amberAccent),
            // TODO: create score in entryModel
            Text("8", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: const [
            Icon(Icons.add, size: 24, color: Colors.green),
            // TODO: create supporterAnswerCount in entryModel
            Text("8", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: const [
            Icon(Icons.support_rounded, size: 24, color: Colors.grey),
            // TODO: create neutralAnswerCount in entryModel
            Text("8", style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: const [
            Icon(Icons.dangerous_outlined, size: 24, color: Colors.red),
            // TODO: create opponentAnswerCount in entryModel
            Text("8", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}