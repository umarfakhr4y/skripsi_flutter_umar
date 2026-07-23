import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../size_helper.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shimmer/shimmer.dart';

part '../splashscreen.dart';
part '../page/loginPage.dart';
part '../page/registerPage.dart';
part '../page/profilePage/profilePage.dart';
part '../page/profilePage/editProfile.dart';
part '../page/profilePage/pengaturanNotifikasiPage.dart';
part '../page/profilePage/aboutPage.dart';
part '../page/lupaPasswordPage.dart';
part '../page/autentikasimain.dart';
part '../page/getrole.dart';

part '../page/mentorpage/mentorMain.dart';
part '../page/mentorpage/mentorHome.dart';
part '../page/mentorpage/mentorNotif.dart';
part '../page/mentorpage/fitur/liatpesertamagangMentor.dart';
part '../page/mentorpage/fitur/absensipesertaMentor.dart';
part '../page/mentorpage/fitur/persuratanpesertaMentor.dart';
part '../page/mentorpage/mentorTools.dart';
part '../page/mentorpage/fitur/manajementugasMentor.dart';
part '../page/mentorpage/fitur/bimbinganpesertaMentor.dart';
part '../page/mentorpage/fitur/tambahtugasMentor.dart';
part '../page/mentorpage/fitur/laporanpesertaMentor.dart';
part '../page/mentorpage/fitur/detailpesertamagangMentor.dart';
part '../page/mentorpage/fitur/detailtugasMentor.dart';
part '../page/mentorpage/fitur/lampiraninstruksiMentor.dart';
part '../page/mentorpage/fitur/evaluasibulanannMentor.dart';
part '../page/mentorpage/fitur/riwayatevaluasiMentor.dart';
part '../page/mentorpage/fitur/persuratanpesertaMentor_dua.dart';

part '../page/pesertapage/pesertaMain.dart';
part '../page/pesertapage/autentikasiPeserta.dart';
part '../page/pesertapage/pesertaHome.dart';
part '../page/pesertapage/pesertaMenu.dart';
part '../page/pesertapage/fitur/tugasSayaPeserta.dart';
part '../page/pesertapage/fitur/evaluasiPeserta.dart';
part '../page/pesertapage/fitur/bimbinganPeserta.dart';
part '../page/pesertapage/fitur/persuratanPeserta.dart';
