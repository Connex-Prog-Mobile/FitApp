import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<String> people = ['João', 'Maria', 'Carlos']; // get do banco

  TextEditingController controller = TextEditingController();

  int? editIndex;

  String searchQuery = "";

  void addOrEditPerson() {
    if (controller.text.isEmpty) return;

    setState(() {
      if (editIndex != null) {
        people[editIndex!] = controller.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contato atualizado com sucesso!')),
        );
        editIndex = null;
      } else {
        people.add(controller.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contato adicionado com sucesso!')),
        );
      }
      controller.clear();
    });
  }

  void editPerson(int index) {
    setState(() {
      controller.text = people[index];
      editIndex = index;
    });
  }

  void deletePerson(int index) {
    setState(() {
      people.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contato removido!')),
      );
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPeople = people
        .where((person) => person.toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pessoas'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite um nome',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: addOrEditPerson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(editIndex != null ? 'Salvar' : 'Adicionar'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: updateSearchQuery,
              decoration: const InputDecoration(
                labelText: 'Buscar contatos',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredPeople.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum contato encontrado',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPeople.length,
                      itemBuilder: (context, index) {
                        final person = filteredPeople[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () =>
                                      editPerson(people.indexOf(person)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      deletePerson(people.indexOf(person)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
