import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application_model.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createApplication(ApplicationModel application) async {
    // Save application to Firestore
    await _firestore
        .collection('applications')
        .doc(application.id)
        .set(application.toJson());

    // Update opportunity applicants count only if the document exists in Firestore
    final oppDocRef = _firestore.collection('opportunities').doc(application.opportunityId);
    final oppDoc = await oppDocRef.get();
    if (oppDoc.exists) {
      await oppDocRef.update({
        'applicantsCount': FieldValue.increment(1),
      });
    } else {
      debugPrint('Opportunity document ${application.opportunityId} does not exist in Firestore. Skipping count increment.');
    }
  }

  Future<void> updateApplicationStatus(String id, String status) async {
    await _firestore
        .collection('applications')
        .doc(id)
        .update({'status': status});
  }

  Future<void> updateApplicationNotes(String id, String notes) async {
    await _firestore
        .collection('applications')
        .doc(id)
        .update({'internalNotes': notes});
  }

  Future<void> deleteApplication(String id) async {
    await _firestore.collection('applications').doc(id).delete();
  }

  Stream<List<ApplicationModel>> streamStudentApplications(String studentId) {
    return _firestore
        .collection('applications')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<ApplicationModel>> streamOpportunityApplications(String opportunityId) {
    return _firestore
        .collection('applications')
        .where('opportunityId', isEqualTo: opportunityId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ApplicationModel.fromJson(doc.data()))
          .toList();
    });
  }
}

final applicationServiceProvider = Provider<ApplicationService>((ref) => ApplicationService());

final studentApplicationsProvider = StreamProvider.family<List<ApplicationModel>, String>((ref, studentId) {
  return ref.watch(applicationServiceProvider).streamStudentApplications(studentId);
});

final opportunityApplicationsProvider = StreamProvider.family<List<ApplicationModel>, String>((ref, opportunityId) {
  return ref.watch(applicationServiceProvider).streamOpportunityApplications(opportunityId);
});

final allApplicationsProvider = StreamProvider<List<ApplicationModel>>((ref) {
  return FirebaseFirestore.instance.collection('applications').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => ApplicationModel.fromJson(doc.data())).toList();
  });
});
