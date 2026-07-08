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
        Uri.parse('http://10.0.2.2:8000/api/absensi'),
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
        Uri.parse('http://10.0.2.2:8000/api/user'),
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
}
