import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

class AuthService {
  final _supabase = Supabase.instance.client;
  
  // Update with your Web Client ID from Google Cloud Console
  final gsi.GoogleSignIn _googleSignIn = gsi.GoogleSignIn(
    serverClientId: '735941202348-avib2frbghhpu3aum4sqavg0bcjapfmc.apps.googleusercontent.com',
    clientId: kIsWeb ? null : '735941202348-dcj33imrmv0493n5h3b4pa13p6pcth05.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    // 1. Web & iOS Flow (Using Supabase OAuth to avoid Nonce issues on iOS)
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'com.googleusercontent.apps.735941202348-dcj33imrmv0493n5h3b4pa13p6pcth05://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      return;
    } 

    // 2. Android Flow (Native)
    else {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }

      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: null, // Try omitting access token to avoid strict nonce checks/mismatches
      );
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _supabase.auth.signOut();
  }
  
  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
