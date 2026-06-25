import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRemote {
  static final FirebaseRemote _instance = FirebaseRemote._internal();

  factory FirebaseRemote() {
    return _instance;
  }

  final FirebaseFirestore _firestore;

  FirebaseRemote._internal({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Create (Thêm một document mới với ID tự động)
  Future<String> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  // Create/Update (Ghi đè hoặc tạo mới document với một ID cụ thể)
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data, SetOptions(merge: merge));
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  // Read (Lấy một document cụ thể theo ID)
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      final docSnapshot = await _firestore.collection(collection).doc(docId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          data['id'] = docSnapshot.id;
        }
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Read (Lấy danh sách tất cả các document trong một collection)
  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    
  }) async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; 
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get collection: $e');
    }
  }

  // Read (Lấy danh sách các document thỏa mãn 1 điều kiện)
  Future<List<Map<String, dynamic>>> getCollectionWithCondition({
    required String collection,
    required String field,
    required dynamic value,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get collection with condition: $e');
    }
  }

  // Update (Cập nhật một số trường của document)
  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Delete (Xóa một document)
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }
}
