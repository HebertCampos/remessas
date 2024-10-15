import 'dart:convert';

import 'package:remessas/constants/api_constants.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<List<AssociadosModel>> getAssociados() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/social/beneficiariosassociados?timestamp=${DateTime.now().millisecondsSinceEpoch}'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // print('RETORNO DAS INFORMAÇÕES: $data');
        return data.map((item) => AssociadosModel.fromJson(item)).toList();
      } else {
        final errorMessage = json.decode(response.body)['error'];
        throw Exception('Erro 1: $errorMessage');
      }
    } catch (e) {
      throw Exception('Erro 2: $e');
    }
  }
}
