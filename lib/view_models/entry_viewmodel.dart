import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/services/entry_service.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../models/entry_model.dart';

class EntryViewModel extends ChangeNotifier{
  EntryViewModel({required this.entryRepository});

  final EntryRepository entryRepository;

  EntryModel? model; // currentListeningEntryModel

  // Services
  EntryService entryService = locator<EntryService>();

  void setEntryModel(EntryModel? entryModel){
    model = entryModel;
  }
}