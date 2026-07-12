import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/opportunity_model.dart';

class OpportunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOpportunity(OpportunityModel opportunity) async {
    await _firestore
        .collection('opportunities')
        .doc(opportunity.id)
        .set(opportunity.toJson());
  }

  Future<void> updateOpportunity(OpportunityModel opportunity) async {
    await _firestore
        .collection('opportunities')
        .doc(opportunity.id)
        .update(opportunity.toJson());
  }

  Future<void> deleteOpportunity(String id) async {
    await _firestore.collection('opportunities').doc(id).delete();
  }

  Stream<List<OpportunityModel>> streamAllOpportunities() {
    return _firestore
        .collection('opportunities')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OpportunityModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<OpportunityModel>> streamEmployerOpportunities(String employerId) {
    return _firestore
        .collection('opportunities')
        .where('employerId', isEqualTo: employerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OpportunityModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<OpportunityModel?> getOpportunity(String id) async {
    final doc = await _firestore.collection('opportunities').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return OpportunityModel.fromJson(doc.data()!);
    }
    return null;
  }
}

final opportunityServiceProvider = Provider<OpportunityService>((ref) => OpportunityService());

final activeOpportunitiesProvider = StreamProvider<List<OpportunityModel>>((ref) {
  return ref.watch(opportunityServiceProvider).streamAllOpportunities();
});

final employerOpportunitiesProvider = StreamProvider.family<List<OpportunityModel>, String>((ref, employerId) {
  return ref.watch(opportunityServiceProvider).streamEmployerOpportunities(employerId);
});

final opportunityDetailsProvider = FutureProvider.family<OpportunityModel?, String>((ref, id) {
  return ref.watch(opportunityServiceProvider).getOpportunity(id);
});
