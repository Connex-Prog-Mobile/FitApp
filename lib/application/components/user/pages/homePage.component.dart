import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  UserHomePageState createState() => UserHomePageState();
}

class UserHomePageState extends State<UserHomePage> {
  String titulo = "Ficha de Treino";
  String treino = "Treino Superiores";
  String exercicios = "Supino reto, Remada, Desenvolvimento de ombro";
  String objetivo = "Fortalecimento muscular e aumento de força";
  String observacao = "Focar na postura e na execução correta dos movimentos.";

  String dataAgendamento = "20/11/2024 - Segunda-feira";
  String horarioAgendamento = "14:00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar('Home'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza horizontalmente
              children: [
                // Card com informações do treino
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Centraliza os textos
                      children: [
                        // Título
                        Text(
                          'FICHA DE TREINO',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Treino
                        Text(
                          treino,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Exercícios
                        Text(
                          "Exercícios: $exercicios",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        // Objetivo
                        Text(
                          "Objetivo: $objetivo",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        // Observação
                        Text(
                          "Observação: $observacao",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Card com informações de agendamento
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Centraliza os textos
                      children: [
                        // Título
                        Text(
                          "COMPROMISSOS AGENDADOS",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Data e Hora do Agendamento
                        Text(
                          "Data do Agendamento: $dataAgendamento",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Horário do Agendamento: $horarioAgendamento",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(selectedIndex: 0),
    );
  }
}
