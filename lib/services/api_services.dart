import 'dart:convert';

import 'package:remessas/constants/api_constants.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<AssociadosModel>> getAssociados() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/social/beneficiariosassociados'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => AssociadosModel.fromJson(item)).toList();
      } else {
        final errorMessage = json.decode(response.body)['error'];
        throw Exception('Erro: $errorMessage');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}
