import 'package:fit_app/application/components/pages/workout/workoutPage.component.dart';
import 'package:fit_app/application/components/widgets/defaultAppBar.widget.dart';
import 'package:fit_app/application/components/widgets/footer.widget.dart';
import 'package:fit_app/application/entities/Event.entity.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutSchedulerPage extends StatefulWidget {
  const WorkoutSchedulerPage({super.key});

  @override
  WorkoutSchedulerPageState createState() => WorkoutSchedulerPageState();
}

class WorkoutSchedulerPageState extends State<WorkoutSchedulerPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  String? _selectedWorkout;
  final List<String> _workouts = ['Treino A', 'Treino B', 'Treino C'];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return [
      if (day.day == 18) Event('Treino A'),
      if (day.day == 20) Event('Treino B'),
      if (day.day == 25) Event('Treino C'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.8;
    double containerHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: const DefaultAppBar('Seleção de Treinos'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TableCalendar(
                locale: 'pt-br',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarFormat: CalendarFormat.week,
                availableGestures: AvailableGestures.none,
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                width: containerWidth,
                height: containerHeight,
                child: Column(
                  children: [
                    Text(
                      'Selecione um Treino:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 242, 242),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 200, 198, 198)
                                .withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      width: containerWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: _selectedWorkout,
                            hint: const Text('Escolha o treino'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedWorkout = newValue;
                              });
                            },
                            items: _workouts.map<DropdownMenuItem<String>>(
                                (String workout) {
                              return DropdownMenuItem<String>(
                                value: workout,
                                child: Text(workout),
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            underline: const SizedBox(),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Ver Detalhes',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: containerWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    if (_selectedWorkout != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Iniciando $_selectedWorkout!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, selecione um treino'),
                        ),
                      );
                    }
                  },
                  child: const Text('Iniciar Treino',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
              ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, events, _) {
                  return Column(
                    children: [
                      for (var event in events)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: containerWidth,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(14.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const WorkoutPage(
                                            workoutName: 'Tela de exercicio')),
                                  );
                                },
                                title: Text(event.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                trailing: const Icon(Icons.event),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(selectedIndex: 2),
    );
  }
}
