import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_profile_model.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createStudentProfile(StudentProfileModel profile, String studentName) async {
    final docId = studentName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    await _firestore
        .collection('student_profiles')
        .doc(docId)
        .set(profile.toJson());
  }

  Future<void> updateStudentProfile(StudentProfileModel profile, String studentName) async {
    final docId = studentName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    await _firestore
        .collection('student_profiles')
        .doc(docId)
        .update(profile.toJson());
  }

  Future<StudentProfileModel?> getStudentProfile(String uid) async {
    final snapshot = await _firestore
        .collection('student_profiles')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return StudentProfileModel.fromJson(snapshot.docs.first.data());
    }
    return null;
  }

  Stream<StudentProfileModel?> streamStudentProfile(String uid) {
    return _firestore
        .collection('student_profiles')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return StudentProfileModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    });
  }
}

final studentServiceProvider = Provider<StudentService>((ref) => StudentService());

final studentProfileStreamProvider = StreamProvider.family<StudentProfileModel?, String>((ref, uid) {
  return ref.watch(studentServiceProvider).streamStudentProfile(uid);
});
