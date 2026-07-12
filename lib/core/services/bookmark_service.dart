import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleBookmark(String studentId, String opportunityId) async {
    final docId = '${studentId}_$opportunityId';
    final docRef = _firestore.collection('bookmarks').doc(docId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'studentId': studentId,
        'opportunityId': opportunityId,
        'bookmarkedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isBookmarked(String studentId, String opportunityId) async {
    final docId = '${studentId}_$opportunityId';
    final doc = await _firestore.collection('bookmarks').doc(docId).get();
    return doc.exists;
  }

  Stream<List<String>> streamBookmarkedOpportunityIds(String studentId) {
    return _firestore
        .collection('bookmarks')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()['opportunityId'] as String).toList();
    });
  }

  Stream<bool> streamIsBookmarked(String studentId, String opportunityId) {
    final docId = '${studentId}_$opportunityId';
    return _firestore
        .collection('bookmarks')
        .doc(docId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}

final bookmarkServiceProvider = Provider<BookmarkService>((ref) => BookmarkService());

final studentBookmarkedIdsProvider = StreamProvider.family<List<String>, String>((ref, studentId) {
  return ref.watch(bookmarkServiceProvider).streamBookmarkedOpportunityIds(studentId);
});

final isBookmarkedStreamProvider = StreamProvider.family<bool, ({String studentId, String opportunityId})>((ref, args) {
  return ref.watch(bookmarkServiceProvider).streamIsBookmarked(args.studentId, args.opportunityId);
});
