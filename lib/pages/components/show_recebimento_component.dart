import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessas/services/api_services.dart';

Future<void> showEditgerarRecebimentoDialog(BuildContext context) async {
  TextEditingController dataProvisaoController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gerar arquivo de recebimento social'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: dataProvisaoController,
                  decoration: const InputDecoration(labelText: 'Competência'),
                  inputFormatters: [maskFormatter],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String dataProvisao = dataProvisaoController.text;

                // Verifica se o formato está correto (ex: '10/2024')
                if (dataProvisao.contains('/')) {
                  List<String> partes = dataProvisao.split('/');
                  int mes = int.tryParse(partes[0]) ?? 0;
                  int ano = int.tryParse(partes[1]) ?? 0;
                  if (mes >= 1 && mes <= 12 && ano >= 2010 && ano <= 2050) {
                    await ApiServices().gerarRecebimento(dataProvisao);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Gerando relatório de recebimento social $dataProvisao")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Data inválida. Mês ou ano fora do intervalo permitido.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Formato inválido. Use o formato MM/YYYY.")),
                  );
                }
              },
              child: const Text('Gerar'),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        );
      });
}
