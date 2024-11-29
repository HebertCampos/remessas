import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:remessas/services/api_services.dart';

Future<void> showEditContaBancariaDialog(
    BuildContext context, AssociadosModel associados) async {
  TextEditingController agenciaController = TextEditingController();
  TextEditingController operacaoController = TextEditingController();
  TextEditingController contaController = TextEditingController();

  List<String> tipoBanco = ['CEF', 'B. BRASIL'];

  String selectedTipoBanco =
      tipoBanco.contains(associados.banco) ? associados.banco : tipoBanco[0];

  final agenciaMaskFormatter = MaskTextInputFormatter(
    mask: '#####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final operacaoMaskFormatter = MaskTextInputFormatter(
    mask: '####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final contaMaskFormatter = MaskTextInputFormatter(
    mask: '##############',
    filter: {"#": RegExp(r'[0-9]')},
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Conta Bancária de ${associados.nome}'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedTipoBanco,
                    isExpanded: true,
                    items: tipoBanco.map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTipoBanco = newValue!;
                      });
                    },
                  ),
                  TextField(
                    controller: agenciaController..text = associados.agencia,
                    decoration: const InputDecoration(labelText: 'Agência'),
                    inputFormatters: [agenciaMaskFormatter],
                  ),
                  TextField(
                    controller: operacaoController,
                    decoration: const InputDecoration(labelText: 'Operação'),
                    inputFormatters: [operacaoMaskFormatter],
                  ),
                  TextField(
                    controller: contaController..text = associados.conta,
                    decoration: const InputDecoration(labelText: 'Conta'),
                    inputFormatters: [contaMaskFormatter],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (agenciaController.text.isNotEmpty &&
                      contaController.text.isNotEmpty) {
                    if (operacaoController.text.isEmpty) {
                      await ApiServices().alterDadosBancarios(
                        associados.codTitular,
                        selectedTipoBanco,
                        agenciaController.text,
                        '',
                        contaController.text,
                      );
                    } else {
                      await ApiServices().alterDadosBancarios(
                        associados.codTitular,
                        selectedTipoBanco,
                        agenciaController.text,
                        operacaoController.text,
                        contaController.text,
                      );
                    }
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.blueAccent,
                          content: Text('Dados cadastrados!')),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Os campos precisam ser preenchidos!')),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
