import 'package:flutter/material.dart';
import 'conn/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCI3nC1cVE3bKAagsxh74IWQPncIopEUHM",
  appId: "1:146684990013:android:178e51324085ebb916d054",
  messagingSenderId: "146684990013",
  projectId: "skripsi-umar",
  storageBucket: "skripsi-umar.firebasestorage.app",
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: firebaseOptions);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase secara eksplisit untuk mencegah kegagalan baca file config di Android
  await Firebase.initializeApp(options: firebaseOptions);

  // Daftarkan handler background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      // home:  PenggunaHome(),
      home: Splashscreen(),
    );
  }
}
