import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final supabase = Supabase.instance.client;

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // إنشاء مستخدم جديد باستخدام Supabase Auth
      final signUpResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        
      );

      if (signUpResponse.user != null) {
        log('User created successfully: ${signUpResponse.user!.id}');
        return signUpResponse.user;
      } else if (signUpResponse.session == null) {
        log('Signup failed: No session was created. This might be due to email confirmation being required.');
      }
    } catch (e) {
      log('Error creating user: $e');
    }
    return null;
  }
}
