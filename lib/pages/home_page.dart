import 'package:flutter/material.dart';
import 'package:remessas/models/associados_model.dart';
import 'package:remessas/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiServices apiServices = ApiServices();
  List<AssociadosModel> associados = [];
  List<AssociadosModel> filteredAssociados = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();

  // Variáveis para os checkboxes
  List<String> tiposCobranca = [
    'NOVO ASSOCIADO',
    'DESCONTO DEBITO EM CONTA',
    'DESCONTO EM FOLHA',
    'DESCONTO ASFAL-SAUDE'
  ];
  Map<String, bool> selectedTiposCobranca = {
    'NOVO ASSOCIADO': false,
    'DESCONTO DEBITO EM CONTA': false,
    'DESCONTO EM FOLHA': false,
    'DESCONTO ASFAL-SAUDE': false,
  };

  @override
  void initState() {
    super.initState();
    fetchAssociados();
  }

  @override
  void dispose() {
    searchController.dispose(); // Limpa o controller
    super.dispose();
  }

  void fetchAssociados() async {
    try {
      List<AssociadosModel> fetchAssociados = await apiServices.getAssociados();
      setState(() {
        associados = fetchAssociados;
        filteredAssociados = fetchAssociados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar associados: $e')),
      );
    }
  }

  void filterSearch(String query) {
    List<AssociadosModel> filteredList = associados.where((associado) {
      // Verifica se o nome contém a busca
      final matchesSearch =
          associado.nome.toLowerCase().contains(query.toLowerCase());

      // Verifica se o tipo de cobrança está selecionado
      final matchesTipoCobranca = selectedTiposCobranca.entries
          .where((entry) => entry.value) // Verifica checkboxes selecionados
          .map((entry) => entry.key) // Pega as chaves (tipos de cobrança)
          .toList();

      // Se não houver nenhum checkbox selecionado, considera como um match
      if (matchesTipoCobranca.isEmpty) return matchesSearch;

      // Verifica se o tipo de cobrança do associado está na lista de selecionados
      final matchesTipo = matchesTipoCobranca.contains(associado.tipoCobranca);

      return matchesSearch && matchesTipo;
    }).toList();

    setState(() {
      filteredAssociados = filteredList;
    });
  }

  void filterTiposCobranca() {
    filterSearch(searchController
        .text); // Atualiza o filtro quando um checkbox é marcado/desmarcado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sócios Contribuintes'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) => filterSearch(value),
                  decoration:
                      const InputDecoration(labelText: 'Buscar associado'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Filtros:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: tiposCobranca.map((tipo) {
                            return Row(
                              children: [
                                Transform.scale(
                                  scale: 0.5,
                                  child: Checkbox(
                                    value: selectedTiposCobranca[tipo],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedTiposCobranca[tipo] = value!;
                                      });
                                      filterTiposCobranca();
                                    },
                                  ),
                                ),
                                Text(
                                  tipo,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAssociados.length,
                    itemBuilder: (context, index) {
                      final associado = filteredAssociados[index];
                      return CardListAssociadosComponent(associado: associado);
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

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
      ),
    );
  }
}
