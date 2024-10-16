import 'package:flutter/material.dart';
import 'package:remessas/models/associados_model.dart';

class CardListAssociadosComponent extends StatelessWidget {
  const CardListAssociadosComponent({
    super.key,
    required this.associado,
  });

  final AssociadosModel associado;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Text('Código\n${associado.codTitular}'),
        title: Text(associado.nome),
        subtitle: Text(associado.tipoCobranca),
        onTap: () {},
      ),
    );
  }
}
