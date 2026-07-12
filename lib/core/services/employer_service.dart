import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employer_profile_model.dart';

class EmployerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEmployerProfile(EmployerProfileModel profile) async {
    await _firestore
        .collection('employer_profiles')
        .doc(profile.orgName)
        .set(profile.toJson());
  }

  Future<void> updateEmployerProfile(EmployerProfileModel profile) async {
    await _firestore
        .collection('employer_profiles')
        .doc(profile.orgName)
        .update(profile.toJson());
  }

  Future<EmployerProfileModel?> getEmployerProfile(String uid) async {
    final snapshot = await _firestore
        .collection('employer_profiles')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return EmployerProfileModel.fromJson(snapshot.docs.first.data());
    }

    // Fallback for older documents stored with document ID = uid
    final doc = await _firestore.collection('employer_profiles').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data['uid'] == null) {
        await _firestore.collection('employer_profiles').doc(uid).update({'uid': uid});
        data['uid'] = uid;
      }
      return EmployerProfileModel.fromJson(data);
    }
    return null;
  }

  Stream<EmployerProfileModel?> streamEmployerProfile(String uid) {
    return _firestore
        .collection('employer_profiles')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        return EmployerProfileModel.fromJson(snapshot.docs.first.data());
      }

      // Fallback for older documents stored with document ID = uid
      final doc = await _firestore.collection('employer_profiles').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['uid'] == null) {
          await _firestore.collection('employer_profiles').doc(uid).update({'uid': uid});
          data['uid'] = uid;
        }
        return EmployerProfileModel.fromJson(data);
      }
      return null;
    });
  }
}

final employerServiceProvider = Provider<EmployerService>((ref) => EmployerService());

final employerProfileStreamProvider = StreamProvider.family<EmployerProfileModel?, String>((ref, uid) {
  return ref.watch(employerServiceProvider).streamEmployerProfile(uid);
});
