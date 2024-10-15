import 'package:intl/intl.dart';

class AssociadosModel {
  final String agencia;
  final String autorizadoDebito;
  final String banco;
  final String codTitular;
  final String conta;
  final String cpf;
  final String dataExclusao;
  final String dataInclusao;
  final String dataNascimento;
  final String matricula;
  final String nome;
  final String tipoCobranca;

  AssociadosModel(
      {required this.agencia,
      required this.autorizadoDebito,
      required this.banco,
      required this.codTitular,
      required this.conta,
      required this.cpf,
      required this.dataExclusao,
      required this.dataInclusao,
      required this.dataNascimento,
      required this.matricula,
      required this.nome,
      required this.tipoCobranca});

  factory AssociadosModel.fromJson(Map<String, dynamic> json) {
    return AssociadosModel(
      agencia: json['agencia'] ?? '',
      autorizadoDebito: json['autorizado_debito'] ?? '',
      banco: json['banco'] ?? '',
      codTitular: json['cod_titular'] ?? '',
      conta: json['conta'] ?? '',
      cpf: json['cpf'] ?? '',
      dataExclusao: json['data_exclusao'] ?? '',
      dataInclusao: json['data_inclusao'] ?? '',
      dataNascimento: json['data_nascimento'] ?? '',
      matricula: json['matricula'] ?? '',
      nome: json['nome'] ?? '',
      tipoCobranca: json['tipo_cobranca'] ?? '',
    );
  }
  String formatDate(String date) {
    try {
      final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      final DateTime dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    } catch (e) {
      // Se a data estiver em um formato incorreto, retorne uma string padrão ou lance uma exceção
      return 'Data inválida';
    }
  }

  @override
  String toString() {
    return "AssociadosModel(agencia: $agencia, autorizado_debito: $autorizadoDebito, banco: $banco, cod_titular: $codTitular, conta:$conta, cpf:$cpf, data_exclusao:$dataExclusao, data_inclusao:$dataInclusao, data_nascimento:$dataNascimento, matricula:$matricula, nome:$nome, tipo_cobranca:$tipoCobranca)";
  }
}
