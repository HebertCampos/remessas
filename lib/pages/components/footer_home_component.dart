import 'package:flutter/material.dart';
import 'package:remessas/pages/components/show_provisao_component.dart';
import 'package:remessas/pages/components/show_remessa_component.dart';

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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: page == 1 ? null : () {}, // Desativa se page == 1
            //     child: const Text('Lista Sócios'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: page == 2 ? null : () {}, // Desativa se page == 2
            //     child: const Text('Data de Emissão'),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showEditProvisaoDialog(context);
                }, // Desativa se page == 3
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
                      }, // Desativa se page == 4
                child: const Text('Remessa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
