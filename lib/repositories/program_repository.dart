import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/service/logger.dart';
import '../data/models/program_model.dart';

class ProgramRepository {
  static final ProgramRepository _instance = ProgramRepository._internal();
  final _db = FirebaseFirestore.instance;

  factory ProgramRepository() {
    return _instance;
  }

  ProgramRepository._internal();

  getPrograms() async {
    try {
      final ref = _db.collection("programs").withConverter(
            fromFirestore: Program.fromFirestore,
            toFirestore: (Program program, _) => program.toSnapshot(),
          );
      List<Program> programs = [];
      var querySnapshot = await ref.get();
      for (var docSnapshot in querySnapshot.docs) {
        final program = docSnapshot.data();
        programs.add(program);
      }
      return programs;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }

  getProgram(String id) async {
    try {
      final ref = _db.collection("programs").doc(id).withConverter(
            fromFirestore: Program.fromFirestore,
            toFirestore: (Program program, _) => program.toSnapshot(),
          );
      var querySnapshot = await ref.get();
      final program = querySnapshot.data();
      return program;
    } on Exception catch (e) {
      logger.e(e);
      return null;
    }
  }
}
