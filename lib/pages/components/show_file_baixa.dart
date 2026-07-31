import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessas/services/api_response_utils.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:remessas/services/api_services.dart';

Future<void> selectFile(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.bytes != null) {
    Uint8List fileBytes = result.files.single.bytes!;
    final content = utf8.decode(fileBytes);

    try {
      final responseData = await ApiServices().enviaArquivoBaixa(content);
      final message = buildApiSuccessMessage(responseData);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar arquivo: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> showFileBaixa(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Arquivo de baixa de remessa'),
        content: Center(
          child: ElevatedButton(
            onPressed: () => selectFile(context),
            child: const Text('Selecionar Arquivo'),
          ),
        ),
      );
    },
  );
}


Future<void> selectFileCSV(BuildContext context, String competencia, String valor, String acao) async {
  final competenciaLimpa = competencia.trim();
  final valorLimpo = valor.trim();
  final acaoLimpa = acao.trim();

  if (competenciaLimpa.isEmpty || valorLimpo.isEmpty || acaoLimpa.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informe todos os campos antes de enviar o arquivo.'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result != null && result.files.single.bytes != null) {
    try {
      final fileBytes = result.files.single.bytes!;
      final content = utf8.decode(fileBytes);

      await ApiServices().enviaArquivoConsignado(content, competenciaLimpa, valorLimpo, acaoLimpa);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Arquivo CSV enviado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar arquivo: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> showFileConsignado(BuildContext context) async {
  TextEditingController competenciaController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController acaoController = TextEditingController();

  final maskCompetencia = MaskTextInputFormatter(
    mask: '##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  final maskValor = MaskTextInputFormatter(
    mask: 'R\$ ###,##',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Garar arquivo consignado'),
        content: Center(
          child: Column(
            children: [
              TextField(
                controller: competenciaController,
                decoration: const InputDecoration(
                  labelText: 'Competência (MM/AAAA)',
                ),
                inputFormatters: [maskCompetencia],
                onChanged: (value) {
                },
              ),
              TextField(
                controller: valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                ),
                inputFormatters: [maskValor],
                onChanged: (value) {
                },
              ),
              TextField(
                controller: acaoController,
                decoration: const InputDecoration(
                  labelText: 'Ação',
                  hintText: 'A - Alteração, E - Exclusão, I - Inclusão, M - Migração',
                ),
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text.toUpperCase();
                    if (text.isEmpty || ['A', 'E', 'I', 'M'].contains(text)) {
                      return TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }
                    return oldValue;
                  }),
                ],
                maxLength: 1,
                onChanged: (value) {
                },
              ),
              ElevatedButton(
                onPressed: () => selectFileCSV(context, competenciaController.text, valorController.text, acaoController.text),
                child: const Text('Selecionar Arquivo'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
