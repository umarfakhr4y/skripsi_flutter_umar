part of '../../conn/auth.dart';

class MentorService {
  static Future<Map<String, dynamic>> getPesertaAbsensi() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/mentor/peserta'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'],
          'summary': data['summary'],
        };
      } else {
        return {'success': false, 'message': 'Gagal mengambil data peserta'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> createPenugasan({
    required int pesertaId,
    required String judulTugas,
    required String deskripsi,
    required String deadline,
    required List<File> fotoPetunjuk,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseApiUrl/api/mentor/penugasan'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['peserta_magang_id'] = pesertaId.toString();
      request.fields['judul_tugas'] = judulTugas;
      request.fields['deskripsi'] = deskripsi;
      request.fields['deadline'] = deadline;

      for (var file in fotoPetunjuk) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_petunjuk[]', file.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Tugas berhasil dibuat',
          'data': data['data'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal membuat tugas',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> updatePenugasan({
    required int id,
    required int pesertaId,
    required String judulTugas,
    required String deskripsi,
    required String deadline,
    required String statusTugas,
    required List<File> fotoPetunjuk,
    List<String>? existingFotoPetunjuk,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseApiUrl/api/mentor/penugasan/$id'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['_method'] = 'PUT';
      request.fields['peserta_magang_id'] = pesertaId.toString();
      request.fields['judul_tugas'] = judulTugas;
      request.fields['deskripsi'] = deskripsi;
      request.fields['deadline'] = deadline;
      request.fields['status_tugas'] = statusTugas;

      if (existingFotoPetunjuk != null && existingFotoPetunjuk.isNotEmpty) {
        for (var path in existingFotoPetunjuk) {
          request.files.add(
            http.MultipartFile.fromString('existing_foto_petunjuk[]', path),
          );
        }
      } else {
        request.fields['existing_foto_petunjuk'] = 'empty';
      }

      for (var file in fotoPetunjuk) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_petunjuk[]', file.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Tugas berhasil diperbarui',
          'data': data['data'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Gagal memperbarui tugas',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateStatusPenugasan({
    required int id,
    required String statusTugas,
    String? catatanMentor,
    int? pesertaId,
    String? judulTugas,
    String? deskripsi,
    String? deadline,
    List<dynamic>? existingFotoPetunjuk,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final Map<String, dynamic> bodyData = {
        '_method': 'PUT',
        'action': statusTugas == 'Selesai' ? 'acc' : 'reject',
      };

      if (catatanMentor != null && catatanMentor.isNotEmpty) {
        bodyData['catatan_mentor'] = catatanMentor;
      }

      print('=== REQUEST UPDATE STATUS PENUGASAN ===');
      print('URL: http://192.168.18.81:8000/api/mentor/penugasan/$id/review');
      print('BODY: ${jsonEncode(bodyData)}');

      final response = await http.post(
        Uri.parse('$baseApiUrl/api/mentor/penugasan/$id/review'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      print('=== RESPONSE UPDATE STATUS PENUGASAN ===');
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Status tugas berhasil diperbarui',
          'data': data['data'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['message'] ?? 'Gagal memperbarui status tugas';
        if (errorData['errors'] != null && errorData['errors'] is Map) {
          final errorsMap = errorData['errors'] as Map;
          final List<String> errorDetails = [];
          errorsMap.forEach((key, value) {
            if (value is List) {
              errorDetails.add('$key: ${value.join(', ')}');
            } else {
              errorDetails.add('$key: $value');
            }
          });
          if (errorDetails.isNotEmpty) {
            errorMessage += ' (${errorDetails.join('; ')})';
          }
        }
        print('=== VALIDATION ERROR DETAILS: $errorMessage ===');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('=== EXCEPTION UPDATE STATUS PENUGASAN: $e ===');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPenugasanMentor() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/mentor/penugasan'),
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
          'message': 'Gagal mengambil data penugasan mentor',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> deletePenugasanMentor(int id) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.delete(
        Uri.parse('$baseApiUrl/api/mentor/penugasan/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Penugasan berhasil dihapus',
        };
      } else {
        return {'success': false, 'message': 'Gagal menghapus penugasan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPengaturanAbsen() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token == null) return {'success': false, 'message': 'No token'};

    try {
      final response = await http.get(
        Uri.parse('$baseApiUrl/api/mentor/pengaturan-absen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> setPengaturanAbsen(String waktu) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token == null) return {'success': false, 'message': 'No token'};

    try {
      final response = await http.post(
        Uri.parse('$baseApiUrl/api/mentor/pengaturan-absen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'batas_waktu': waktu}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
