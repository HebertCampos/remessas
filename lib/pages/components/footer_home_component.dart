import 'package:flutter/material.dart';
import 'package:remessas/pages/components/show_file_baixa.dart';
import 'package:remessas/pages/components/show_provisao_component.dart';
import 'package:remessas/pages/components/show_recebimento_component.dart';
import 'package:remessas/pages/components/show_remessa_component.dart';
import 'package:remessas/services/api_services.dart';

class FooterComponet extends StatelessWidget {
  final int page; // Tornar 'page' um campo final para ser imutável

  const FooterComponet({
    super.key,
    required this.page, // Passar 'page' como parâmetro requerido
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await ApiServices().baixaAssociados();
                },
                child: const Text('Lista associados'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await ApiServices().gerarPlanosAtivos();
                },
                child: const Text('Planos ativos'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showEditProvisaoDialog(context);
                },
                child: const Text('Provisão'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: page == 4
                    ? null
                    : () {
                        showEditRemessaComponent(context);
                      },
                child: const Text('Remessa'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: page == 4
                    ? null
                    : () {
                        showFileBaixa(context);
                      },
                child: const Text('Baixa arquivos'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: page == 4
                    ? null
                    : () {
                        showEditgerarRecebimentoDialog(context);
                      },
                child: const Text('Recebimentos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
