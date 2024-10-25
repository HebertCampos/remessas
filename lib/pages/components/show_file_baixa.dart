import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:remessas/services/api_services.dart';

Future<void> selectFile(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.bytes != null) {
    Uint8List fileBytes = result.files.single.bytes!;
    final content = utf8.decode(fileBytes);

    // Envia o conteúdo do arquivo para o serviço
    await ApiServices().enviaArquivoBaixa(content);

    // Exibe uma mensagem de confirmação
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arquivo enviado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Fecha o AlertDialog
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
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
