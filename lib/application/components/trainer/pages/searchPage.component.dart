import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/entities/user.type.dart';
import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:FitApp/application/infra/database/repositories/user.repository.dart';
import 'package:FitApp/application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<User> filteredUsers = [];
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUsers();
    setState(() {
      filteredUsers = userProvider.usersList;
    });
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (query.isNotEmpty) {
      setState(() {
        filteredUsers = userProvider.usersList.where((user) {
          return user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        }).toList();
      });
    } else {
      setState(() {
        filteredUsers = userProvider.usersList;
      });
    }
  }

  Future<void> _generateUserPdf(BuildContext context, User user) async {
    final pdfGenerator = PdfGenerator(userRepository: _userRepository);

    try {
      await pdfGenerator.generateStudentPdf(context, user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF gerado com sucesso!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final activeUser = userProvider.activeUser;

    return Scaffold(
        appBar: const DefaultAppBar('Pesquisa'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar por nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              filteredUsers.isEmpty
                  ? const Center(
                      child: Text('Nenhum usuário encontrado.'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : ''),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(user.name),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('E-mail: ${user.email}\n'
                                            'Contato: ${user.contact}'),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await _generateUserPdf(
                                                context, user);
                                          },
                                          child: const Text('Gerar PDF'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: (activeUser?.isAuthenticated ?? false)
            ? const FooterWidget(
                selectedIndex: 0,
                userType: UserType.trainer,
              )
            : const SizedBox.shrink());
  }
}
