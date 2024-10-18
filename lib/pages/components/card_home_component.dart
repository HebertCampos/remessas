import 'package:flutter/material.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:remessas/pages/components/show_tipo_cobranca_home_component.dart';

class CardListAssociadosComponent extends StatelessWidget {
  const CardListAssociadosComponent({
    super.key,
    required this.associado,
    required this.onRefresh, // Adiciona o parâmetro onRefresh
  });

  final AssociadosModel associado;
  final VoidCallback onRefresh; // Função que será chamada após a edição

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Text('Código\n${associado.codTitular}'),
        title: Text(associado.nome),
        subtitle: Text(associado.tipoCobranca),
        trailing: Text('Data inclusão:\n${associado.dataInclusao}'),
        onTap: () async {
          // Aguarda a conclusão do diálogo de edição
          await showEditTipoCobrancaDialog(context, associado);
          // Chama a função onRefresh para recarregar os associados
          onRefresh();
        },
      ),
    );
  }
}
