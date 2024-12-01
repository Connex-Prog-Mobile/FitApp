import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/entities/user.type.dart';
import 'package:FitApp/application/infra/database/repositories/user.repository.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserRepository _userRepository = UserRepository();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    List<Map<String, dynamic>> userData = await _userRepository.getAllUsers();
    setState(() {
      users = userData.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  void editPerson(int index) {
    setState(() {
      _showEditModal(users[index]);
    });
  }

  void _showEditModal(User user) {
    TextEditingController nameController =
        TextEditingController(text: user.name);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController contactController =
        TextEditingController(text: user.contact);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contato'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                user.name = nameController.text;
                user.email = emailController.text;
                user.contact = contactController.text;

                await _userRepository.updateUser(user.id, user.toMap());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuário atualizado com sucesso!')),
                );
                Navigator.of(context).pop();
                _loadUsers();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void deletePerson(int index) async {
    final user = users[index];

    await _userRepository.deleteSchedulesByUserId(user.id);

    await _userRepository.deleteUser(user.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário removido!')),
    );
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar('Usuários Cadastrados'),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: users.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum usuário encontrado',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                  onPressed: () => editPerson(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => deletePerson(index),
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
      bottomNavigationBar: const FooterWidget(selectedIndex: 3, userType: UserType.trainer),
    );
  }
}
