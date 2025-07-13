import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication methods
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Firestore methods
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Future<DocumentSnapshot> getDocument(String collection, String documentId) {
    return _firestore.collection(collection).doc(documentId).get();
  }

  // Storage methods
  Future<String?> uploadFile(String path, File file) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  // Room management methods
  Future<void> createRoom(Map<String, dynamic> roomData) async {
    try {
      await _firestore.collection('rooms').add({
        ...roomData,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': currentUser?.uid,
      });
    } catch (e) {
      print('Error creating room: $e');
    }
  }

  Stream<QuerySnapshot> getRoomsStream() {
    return _firestore
        .collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> joinRoom(String roomId, String userId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('Error joining room: $e');
    }
  }

  Future<void> leaveRoom(String roomId, String userId) async {
    try {
      await _firestore.collection('rooms').doc(roomId).update({
        'participants': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      print('Error leaving room: $e');
    }
  }
} 