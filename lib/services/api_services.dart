import 'dart:convert';

import 'package:remessas/constants/api_constants.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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

  Future<void> gerarProvisao(String competencia) async {
    final url = Uri.parse(
        '$baseUrl/social/gerarprovisao?mes_ano_cobranca=$competencia');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Cria um link de download
        html.AnchorElement(
            href: '$baseUrl/social/gerarprovisao?mes_ano_cobranca=$competencia')
          ..setAttribute(
              'download', 'arquivo_baixado.txt') // Define o nome do arquivo
          ..click(); // Simula um clique no link para iniciar o download
      } else {
        throw 'Falha ao realizar provisão';
      }
    } catch (e) {
      throw 'Erro ao gerar provisão $e';
    }
  }
}
