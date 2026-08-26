import 'package:flutter/material.dart';
import 'conn/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCI3nC1cVE3bKAagsxh74IWQPncIopEUHM",
  appId: "1:146684990013:android:178e51324085ebb916d054",
  messagingSenderId: "146684990013",
  projectId: "skripsi-umar",
  storageBucket: "skripsi-umar.firebasestorage.app",
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? pendingFcmTipe;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: firebaseOptions);
  print("Handling a background message: ${message.messageId}");
}

void handleFcmRouting(String? tipe) {
  if (tipe == null) return;

  final context = navigatorKey.currentContext;
  if (context == null) return;

  if (tipe == 'tugas_baru' || tipe == 'review_tugas') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TugasSayaPeserta()),
    );
  } else if (tipe == 'update_izin' || tipe == 'update_surat') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PersuratanPeserta()),
    );
  } else if (tipe == 'update_bimbingan') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BimbinganPeserta()),
    );
  } else if (tipe == 'evaluasi_baru') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EvaluasiPeserta()),
    );
  } else if (tipe == 'tugas_terlambat' || tipe == 'tugas_dikumpulkan') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManajemenTugasMentordua()),
    );
  } else if (tipe == 'izin_baru' || tipe == 'persuratan_baru') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PersuratanPesertaMentordua()),
    );
  } else if (tipe == 'bimbingan_baru') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BimbinganPesertaMentor()),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mencegah navigasi bar transparan / overlap (menonaktifkan edge-to-edge secara paksa)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.white, // Warna background tombol navigasi (kembali/recent app)
      systemNavigationBarIconBrightness: Brightness.dark, // Warna ikon navigasi
      statusBarColor:
          Colors.transparent, // Status bar (jam/baterai) tetap transparan
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Inisialisasi Firebase secara eksplisit untuk mencegah kegagalan baca file config di Android
  await Firebase.initializeApp(options: firebaseOptions);

  // Daftarkan handler background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Tangkap klik notifikasi saat aplikasi ditutup (Terminated)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.data.containsKey('tipe')) {
    pendingFcmTipe = initialMessage.data['tipe'];
  }

  // Tangkap klik notifikasi saat aplikasi di background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data.containsKey('tipe')) {
      handleFcmRouting(message.data['tipe']);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      // home:  PenggunaHome(),
      home: Splashscreen(),
    );
  }
}
