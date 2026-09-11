import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:propmatch_mobile/core/constants/api_endpoints.dart';
import 'package:propmatch_mobile/core/network/dio_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
}

class MobilePushNotificationService {
  final DioClient dioClient;

  MobilePushNotificationService({required this.dioClient});

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        final token = await messaging.getToken();
        if (token != null) {
          await registerToken(token);
        }

        messaging.onTokenRefresh.listen((newToken) {
          registerToken(newToken);
        });
      }
    } catch (e) {
      debugPrint('FCM initialization notice: $e');
    }
  }

  Future<void> registerToken(String token) async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      await dioClient.post(
        '${ApiEndpoints.notifications}/device-token',
        data: {'token': token, 'platform': platform},
      );
    } catch (e) {
      debugPrint('Failed to register device token on backend: $e');
    }
  }

  Future<void> removeToken(String token) async {
    try {
      await dioClient.post(
        '${ApiEndpoints.notifications}/device-token/remove',
        data: {'token': token},
      );
    } catch (e) {
      debugPrint('Failed to remove device token: $e');
    }
  }
}
