import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Helper untuk mendapatkan headers beserta Bearer token
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Mengambil data seluruh peserta magang
  static Future<Map<String, dynamic>> getPeserta() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/peserta'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data peserta. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Mengambil data seluruh mentor
  static Future<Map<String, dynamic>> getMentor() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/mentor'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data mentor. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Mengambil data seluruh divisi
  static Future<Map<String, dynamic>> getDivisi() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/divisi'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data divisi. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Mengambil data kehadiran hari ini
  static Future<Map<String, dynamic>> getKehadiranHariIni() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/kehadiran-hari-ini'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data kehadiran. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Mengambil data jumlah tugas
  static Future<Map<String, dynamic>> getTugas() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/admin/tugas'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data tugas. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Menambah Divisi baru
  static Future<Map<String, dynamic>> tambahDivisi(String namaDivisi) async {
    try {
      final headers = await _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = jsonEncode({'nama_divisi': namaDivisi});

      final response = await http.post(
        Uri.parse('$baseUrl/admin/divisi'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Gagal menambah divisi. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Mengubah Divisi
  static Future<Map<String, dynamic>> editDivisi(int id, String namaDivisi) async {
    try {
      final headers = await _getHeaders();
      headers['Content-Type'] = 'application/json';
      final body = jsonEncode({'nama_divisi': namaDivisi});
      final response = await http.put(
        Uri.parse('$baseUrl/admin/divisi/$id'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Gagal mengubah divisi. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  /// Menghapus Divisi
  static Future<Map<String, dynamic>> hapusDivisi(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/divisi/$id'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus divisi. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
