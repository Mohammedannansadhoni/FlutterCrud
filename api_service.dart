import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> verifyPAN(String pan) async {
    final response = await http.post(
      Uri.parse('http://lab.pixel6.co/api/verify-pan.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'panNumber': pan}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify PAN');
    }
  }

  static Future<Map<String, dynamic>> getPostcodeDetails(String postcode) async {
    final response = await http.post(
      Uri.parse('http://lab.pixel6.co/api/get-postcode-details.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'postcode': postcode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get postcode details');
    }
  }
}
