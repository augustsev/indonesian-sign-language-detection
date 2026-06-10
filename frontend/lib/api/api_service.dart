import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../data/kamus_model.dart';
import 'config.dart';

class ApiService {
  static const String _baseUrl = AppConfig.baseUrl;

  static Future<List<String>> predictHuruf(File imageFile) async {
    try {
      var uri = Uri.parse('$_baseUrl/predict');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: basename(imageFile.path),
        ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return List<String>.from(decoded['predicted']);
      } else {
        throw Exception('Gagal prediksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error API: $e');
      rethrow;
    }
  }
  
  static Future<List<KamusModel>> fetchKamus() async {
    try {
      var uri = Uri.parse('$_baseUrl/kamus');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => KamusModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data kamus: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch kamus: $e');
      rethrow;
    }
  }
  static Future<List<KamusModel>> fetchKosakata() async {
    try {
      var uri = Uri.parse('$_baseUrl/kamus/kosakata');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => KamusModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data kosakata: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch kosakata: $e');
      rethrow;
    }
  }

}
