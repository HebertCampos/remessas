import 'package:flutter/material.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:remessas/services/api_services.dart';

Future<void> showEditTipoCobrancaDialog(
    BuildContext context, AssociadosModel associados) async {
  // Lista de opções para o dropdown
  List<String> tiposCobranca = [
    'NOVO ASSOCIADO',
    'DESCONTO DEBITO EM CONTA',
    'DESCONTO EM FOLHA',
    'DESCONTO ASFAL-SAUDE'
  ];
  // Defina o valor inicial ou deixe nulo se não estiver na lista
  String? selectedTipoCobranca = tiposCobranca.contains(associados.tipoCobranca)
      ? associados.tipoCobranca
      : tiposCobranca[0]; // Define o primeiro valor como padrão

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Alterar tipo de cobrança"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(associados.nome),
                DropdownButton<String>(
                  value: selectedTipoCobranca, // Valor atual selecionado
                  isExpanded: true,
                  items: tiposCobranca.map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTipoCobranca = newValue;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedTipoCobranca == 'DESCONTO DEBITO EM CONTA') {
                    await ApiServices()
                        .alteraTipoCobranca(associados.codTitular, '2', 'S');
                  } else if (selectedTipoCobranca == 'DESCONTO EM FOLHA') {
                    await ApiServices()
                        .alteraTipoCobranca(associados.codTitular, '3', 'N');
                  } else if (selectedTipoCobranca == 'DESCONTO ASFAL-SAUDE') {
                    await ApiServices()
                        .alteraTipoCobranca(associados.codTitular, '4', 'N');
                  } else if (selectedTipoCobranca == 'NOVO ASSOCIADO') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Não pode voltar a ser: $selectedTipoCobranca"),
                      ),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tipo modificado: $selectedTipoCobranca"),
                    ),
                  );
                  Navigator.of(context)
                      .pop(true); // Fecha o diálogo após salvar
                },
                child: const Text('Salvar'),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        },
      );
    },
  );
}
