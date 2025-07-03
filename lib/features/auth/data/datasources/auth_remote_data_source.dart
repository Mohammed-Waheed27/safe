import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models/user_model.dart';

/// Interface for authentication remote data source
abstract class AuthRemoteDataSource {
  /// Login user with email and password
  Future<UserModel> login(String email, String password);

  /// Register new user
  Future<UserModel> register(
    String fullName,
    String email,
    String phoneNumber,
    String password, {
    String? thirdPartyToken,
  });

  /// Logout user
  Future<void> logout();

  /// Get current user
  Future<UserModel?> getCurrentUser();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required this.dio,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance {
    _testFirebaseConnection();
  }

  /// Test Firebase connection on initialization
  Future<void> _testFirebaseConnection() async {
    try {
      print('🔥 Firebase: Testing Firebase connection...');

      // Test Firebase Auth connection
      final currentUser = _firebaseAuth.currentUser;
      print(
        '🔥 Firebase Auth: Connection test - Current user: ${currentUser?.uid ?? 'null'}',
      );

      // Test Firestore connection with timeout
      await _firestore
          .doc('test/connection')
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Firestore connection timeout');
            },
          );
      print('🔥 Firestore: Connection test successful');
    } catch (e) {
      print('❌ Firebase: Connection test failed - $e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      print('🔥 Firebase Auth: Starting user login for email: $email');

      // Sign in with email and password
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        print(
          '❌ Firebase Auth: Failed to sign in - userCredential.user is null',
        );
        throw Exception('Failed to sign in');
      }

      print(
        '✅ Firebase Auth: User signed in successfully with UID: ${user.uid}',
      );

      // Get user data from Firestore
      print('📊 Firestore: Fetching user data from users/${user.uid}');
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        print('❌ Firestore: User document not found for UID: ${user.uid}');
        throw Exception('User data not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      print('📊 Firestore: User data retrieved: $userData');

      final userModel = UserModel(
        id: user.uid,
        fullName: userData['fullName'] as String,
        email: userData['email'] as String,
        phoneNumber: userData['phoneNumber'] as String,
        thirdPartyToken: userData['thirdPartyToken'] as String?,
        photoUrl: userData['photoUrl'] as String?,
      );

      print('✅ Login completed successfully for user: ${userData['fullName']}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email address.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        case 'too-many-requests':
          throw Exception('Too many login attempts. Please try again later.');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } on PlatformException catch (e) {
      print('❌ Platform Exception: ${e.code} - ${e.message}');
      print('❌ Platform Details: ${e.details}');
      throw Exception('Firebase connection failed: ${e.message}');
    } catch (e) {
      print('❌ Login failed: ${e.toString()}');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(
    String fullName,
    String email,
    String phoneNumber,
    String password, {
    String? thirdPartyToken,
  }) async {
    try {
      print('🔥 Firebase Auth: Starting user registration for email: $email');

      // Create user with email and password
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        print(
          '❌ Firebase Auth: Failed to create user - userCredential.user is null',
        );
        throw Exception('Failed to create user');
      }

      print('✅ Firebase Auth: User created successfully with UID: ${user.uid}');

      // Save additional user data to Firestore
      final userData = {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'thirdPartyToken': thirdPartyToken,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      print('📊 Firestore: Saving user data to users/${user.uid}');
      print('📊 User data: $userData');

      await _firestore.collection('users').doc(user.uid).set(userData);

      print('✅ Firestore: User data saved successfully to users/${user.uid}');

      final userModel = UserModel(
        id: user.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        thirdPartyToken: thirdPartyToken,
        photoUrl: null,
      );

      print('✅ Registration completed successfully for user: $fullName');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'weak-password':
          throw Exception(
            'Password is too weak. Please use a stronger password.',
          );
        case 'email-already-in-use':
          throw Exception('An account already exists with this email address.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled.');
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } on FirebaseException catch (e) {
      print('❌ Firestore Error: ${e.code} - ${e.message}');
      throw Exception('Failed to save user data: ${e.message}');
    } on PlatformException catch (e) {
      print('❌ Platform Exception: ${e.code} - ${e.message}');
      print('❌ Platform Details: ${e.details}');
      throw Exception('Firebase connection failed: ${e.message}');
    } catch (e) {
      print('❌ Registration failed: ${e.toString()}');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      print('🔥 Firebase Auth: Starting user logout');
      await _firebaseAuth.signOut();
      print('✅ Firebase Auth: User logged out successfully');
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error during logout: ${e.code} - ${e.message}');
      throw Exception('Logout failed: ${e.message}');
    } on PlatformException catch (e) {
      print('❌ Platform Exception during logout: ${e.code} - ${e.message}');
      throw Exception('Firebase connection failed during logout: ${e.message}');
    } catch (e) {
      print('❌ Logout failed: ${e.toString()}');
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      print('🔍 Firebase Auth: Checking current user session');
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        print('❌ Firebase Auth: No current user found');
        return null;
      }

      print('✅ Firebase Auth: Current user found with UID: ${user.uid}');

      // Get user data from Firestore
      print('📊 Firestore: Fetching current user data from users/${user.uid}');
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        print(
          '❌ Firestore: Current user document not found for UID: ${user.uid}',
        );
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      print('📊 Firestore: Current user data retrieved: $userData');

      final userModel = UserModel(
        id: user.uid,
        fullName: userData['fullName'] as String,
        email: userData['email'] as String,
        phoneNumber: userData['phoneNumber'] as String,
        thirdPartyToken: userData['thirdPartyToken'] as String?,
        photoUrl: userData['photoUrl'] as String?,
      );

      print('✅ Current user session verified for: ${userData['fullName']}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      print(
        '❌ Firebase Auth Error getting current user: ${e.code} - ${e.message}',
      );
      return null;
    } on FirebaseException catch (e) {
      print('❌ Firestore Error getting current user: ${e.code} - ${e.message}');
      return null;
    } on PlatformException catch (e) {
      print(
        '❌ Platform Exception getting current user: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      print('❌ Get current user failed: ${e.toString()}');
      return null;
    }
  }
}
