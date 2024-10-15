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

  @override
  void initState() {
    super.initState();
    fetchPacientes();
  }

  void fetchPacientes() async {
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
      throw 'Erro ao carregar associados: $e';
    }
  }

  void filterSeach(String query) {
    if (query.isNotEmpty) {
      List<AssociadosModel> filteredList = associados
          .where((associados) =>
              associados.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        filteredAssociados = filteredList;
      });
    } else {
      setState(() {
        filteredAssociados = associados;
      });
    }
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
                  onChanged: (value) => filterSeach(value),
                  decoration:
                      const InputDecoration(labelText: 'Buscar associado'),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: filteredAssociados.length,
                        itemBuilder: (context, index) {
                          final associado = filteredAssociados[index];
                          return Text(associado.nome);
                        }))
              ],
            )
        ],
      ),
    );
  }
}
