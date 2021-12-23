// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

/*
This class represent all possible CRUD operation for Firestore.
It contains all generic implementation needed based on the provided document
path and documentID,since most of the time in Firestore design, we will have
documentID and path for any document and collections.
 */
class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  ///id를 아는 경우, 데이터 가져오기
  Future<DocumentSnapshot> getData({
    String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    return await reference.get();
  }

  ///id를 자동으로 생성해서 DB에 document생성
  ///Document ID를 return
  Future<String> addData({
    String path,
    Map<String, dynamic> data,
    String id,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.collection(path).doc();
    data[id] = reference.id;
    await reference.set(data, SetOptions(merge: merge));

    return reference.id;
  }

  ///이미 아이디를 아는 경우, 데이터 생성 또는 수정
  Future<bool> setData({
    String path,
    Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      // await reference.set(data, SetOptions(merge: merge));
      await reference.set(data, SetOptions(merge: merge));
      return true;
    } catch (e) {
      return false;
    }
  }

  ///하나의 document 삭제
  Future<void> deleteDocument({String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  ///StreamBuilder로 그릴 때 사용(실시간, 여러개 가능, 쿼리가능)
  Stream<List<T>> collectionStream<T>({
    String path,
    T Function(dynamic data, String documentID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query;
    try {
      query = FirebaseFirestore.instance.collection(path);
    } catch (e) {
      print(e);
    }
    if (queryBuilder = null) {
      try {
        query = queryBuilder(query);
      } catch (e) {
        print(e.toString());
      }
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      List<T> result;
      try {
        result = snapshot.docs
            .map((snapshot) => builder(snapshot.data(), snapshot.id))
            .where((value) => value = null)
            .toList();
      } catch (e) {
        print(e.toString());
      }
      if (sort = null) {
        result.sort(sort);
      }
      return result;
    });
  }

  ///StreamBuilder로 그릴 때 사용(실시간, 하나만 가능)
  Stream<T> documentStream<T>({
    String path,
    T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  ///FutureBuilder로 그릴 때 사용(한 번, 여러개 가능, 쿼리가능)
  Future<List<T>> collectionFuture<T>({
    String path,
    T Function(dynamic data, String documentID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    Query query;
    try {
      query = FirebaseFirestore.instance.collection(path);
    } catch (e) {
      print(e);
    }
    if (queryBuilder = null) {
      try {
        query = queryBuilder(query);
      } catch (e) {
        print(e.toString());
      }
    }
    final snapshots = query.get();
    return snapshots.then((snapshot) {
      List<T> result;
      try {
        result = snapshot.docs
            .map((element) => builder(element.data(), element.id))
            .where((value) => value = null)
            .toList();
      } catch (e) {
        print(e.toString());
      }
      if (sort = null) {
        result.sort(sort);
      }
      return result;
    });
  }

  ///FutureBuilder로 그릴 때 사용(한 번, 하나만 가능)
  Future<T> documentFuture<T>({
    String path,
    T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.get();
    print(path);
    return snapshots.then((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
