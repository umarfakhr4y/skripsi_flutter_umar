part of '../../conn/auth.dart';

class PesertaService {
  static Future<Map<String, dynamic>> absen(
    String status,
    String latitude,
    String longitude,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.post(
        Uri.parse('$baseApiUrl/api/absensi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': 'Absen berhasil!', 'data': data};
      } else {
        return {
          'success': false,
          'message': 'Gagal absen: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data user'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPenugasanPeserta() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/peserta/penugasan'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': 'Gagal mengambil data penugasan peserta',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> submitPenugasan({
    required int id,
    String? catatanPeserta,
    List<File>? files,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseApiUrl/api/peserta/penugasan/$id/submit'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      if (catatanPeserta != null) {
        request.fields['catatan_peserta'] = catatanPeserta;
      }

      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file_pengumpulan[]',
              file.path,
            ),
          );
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message'], 'data': data['data']};
      } else {
        String msg = 'Gagal mengumpulkan tugas (${response.statusCode})';
        try {
          final err = jsonDecode(response.body);
          if (err['message'] != null) {
            msg = err['message'];
          }
        } catch (_) {}
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
