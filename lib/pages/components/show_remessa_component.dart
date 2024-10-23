import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:remessas/services/api_services.dart';

Future<void> showEditRemessaComponent(BuildContext context) async {
  TextEditingController dataProvisaoController = TextEditingController();
  TextEditingController dataCobrancaController = TextEditingController();
  TextEditingController remessaController = TextEditingController();

  List<String> tipoBanco = ['CEF', 'B. BRASIL'];
  String selectedTipoBanco = tipoBanco[0]; // Valor inicial selecionado

  final maskFormatter = MaskTextInputFormatter(
    mask: '##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  final dataMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  final remessaMaskFormatter = MaskTextInputFormatter(
    mask: '######',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // Use StatefulBuilder para usar setState dentro do diálogo
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Gerar remessa para o banco'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: dataProvisaoController,
                    decoration: const InputDecoration(labelText: 'Competência'),
                    inputFormatters: [maskFormatter],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedTipoBanco, // Valor atual selecionado
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
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: remessaController,
                          decoration:
                              const InputDecoration(labelText: 'Remessa'),
                          inputFormatters: [remessaMaskFormatter],
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: dataCobrancaController,
                    decoration:
                        const InputDecoration(labelText: 'Data Cobrança'),
                    inputFormatters: [dataMaskFormatter],
                  ),
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
                      await ApiServices().gerarRemessa(
                          dataProvisao,
                          selectedTipoBanco,
                          remessaController.text,
                          dataCobrancaController.text);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Gerando arquivos de remessa $dataProvisao para o banco $selectedTipoBanco"),
                        ),
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
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
