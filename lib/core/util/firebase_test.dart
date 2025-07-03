import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

/// Utility class for testing Firebase connections
class FirebaseTest {
  /// Test Firebase Auth connection
  static Future<bool> testFirebaseAuth() async {
    try {
      print('🧪 Firebase Test: Testing Firebase Auth...');

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? currentUser = auth.currentUser;

      print('🧪 Firebase Auth: Current user: ${currentUser?.uid ?? 'null'}');
      print('🧪 Firebase Auth: App: ${auth.app.name}');

      return true;
    } on PlatformException catch (e) {
      print('❌ Firebase Auth Test Failed (Platform): ${e.code} - ${e.message}');
      print('❌ Details: ${e.details}');
      return false;
    } catch (e) {
      print('❌ Firebase Auth Test Failed: $e');
      return false;
    }
  }

  /// Test Firestore connection
  static Future<bool> testFirestore() async {
    try {
      print('🧪 Firebase Test: Testing Firestore...');

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Try to read from a test collection
      await firestore
          .collection('test')
          .limit(1)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Firestore connection timeout');
            },
          );

      print('🧪 Firestore: Connection successful');
      return true;
    } on PlatformException catch (e) {
      print('❌ Firestore Test Failed (Platform): ${e.code} - ${e.message}');
      print('❌ Details: ${e.details}');
      return false;
    } catch (e) {
      print('❌ Firestore Test Failed: $e');
      return false;
    }
  }

  /// Test Firebase Auth with test user creation
  static Future<bool> testFirebaseAuthWithRegistration() async {
    try {
      print('🧪 Firebase Test: Testing user registration...');

      final FirebaseAuth auth = FirebaseAuth.instance;
      final String testEmail =
          'test+${DateTime.now().millisecondsSinceEpoch}@example.com';
      const String testPassword = 'TestPassword123!';

      print('🧪 Creating test user with email: $testEmail');

      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          );

      if (userCredential.user != null) {
        print('✅ Test user created successfully: ${userCredential.user!.uid}');

        // Delete the test user
        await userCredential.user!.delete();
        print('✅ Test user deleted successfully');

        return true;
      } else {
        print('❌ Test user creation failed: no user returned');
        return false;
      }
    } on PlatformException catch (e) {
      print('❌ Test Registration Failed (Platform): ${e.code} - ${e.message}');
      print('❌ Details: ${e.details}');
      return false;
    } on FirebaseAuthException catch (e) {
      print('❌ Test Registration Failed (Auth): ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Test Registration Failed: $e');
      return false;
    }
  }

  /// Test complete Firebase connection
  static Future<void> testCompleteFirebaseConnection() async {
    print('🧪 Firebase Test: Starting complete Firebase connection test...');

    final authTest = await testFirebaseAuth();
    final firestoreTest = await testFirestore();
    final registrationTest = await testFirebaseAuthWithRegistration();

    if (authTest && firestoreTest && registrationTest) {
      print('✅ Firebase Test: All Firebase services are working correctly');
    } else {
      print('❌ Firebase Test: Some Firebase services failed');
      print('   - Auth: ${authTest ? "✅" : "❌"}');
      print('   - Firestore: ${firestoreTest ? "✅" : "❌"}');
      print('   - Registration: ${registrationTest ? "✅" : "❌"}');
    }
  }
}
