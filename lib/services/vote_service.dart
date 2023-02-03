import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dertly/models/vote_model.dart';
import 'package:flutter/material.dart';

class VoteService{
  Future giveVote(VoteModel voteModel) async{
    final HttpsCallable callable = FirebaseFunctions.instanceFor(region: "europe-west1").httpsCallable('vote-giveVote8');
    try{
      final data = voteModel.toJson();
      await callable.call(data);
    }catch(e){
      Future.error(Exception(e));
    }
  }
}