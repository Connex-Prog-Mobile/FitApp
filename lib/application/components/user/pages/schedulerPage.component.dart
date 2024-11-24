import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/schedule.entity.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:FitApp/application/infra/database/databaseHelper.dart';
import 'package:FitApp/application/infra/database/repositories/schedule.repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late ScheduleRepository _scheduleRepository;
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();

    _initializeScheduleRepository();
  }

  Future<void> _initializeScheduleRepository() async {
    final db = await DatabaseHelper().database;
    _scheduleRepository = ScheduleRepository(db);
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.activeUser?.id;

    if (userId != null) {
      final schedulesMap =
          await _scheduleRepository.getSchedulesByUserId(userId);
      setState(() {
        _schedules =
            schedulesMap.map((schedule) => Schedule.fromMap(schedule)).toList();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final User? user = userProvider.activeUser;
      final schedule =
          Schedule(userId: user!.id, date: selectedDate, time: selectedTime);

      if (_isPastSchedule(schedule)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Não é possível agendar para um horário no passado."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      } else if (_isTimeSlotTaken(
          userProvider.activeUser?.schedules ?? [], schedule)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horário já ocupado! Tente outro horário."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        final newSchedule = {
          'user_id': userProvider.activeUser?.id,
          'date': selectedDate.toIso8601String(),
          'time': selectedTime.format(context),
          'description': 'Consulta agendada',
        };

        final insertedId =
            await _scheduleRepository.insertSchedule(newSchedule);

        setState(() {
          schedule.id = insertedId;
          userProvider.addSchedule(schedule);
        });

        _loadSchedules();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horário agendado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  bool _isPastSchedule(Schedule schedule) {
    final selectedDateTime = DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      schedule.time.hour,
      schedule.time.minute,
    );

    final now = DateTime.now();
    return selectedDateTime.isBefore(now);
  }

  bool _isTimeSlotTaken(List<Schedule> schedules, Schedule newSchedule) {
    for (var existingSchedule in schedules) {
      if (isSameDay(existingSchedule.date, newSchedule.date) &&
          existingSchedule.time == newSchedule.time) {
        return true;
      }
    }
    return false;
  }

  void _deleteAppointment(int index) async {
    final schedule = _schedules[index];

    if (schedule.id != null)
      await _scheduleRepository.deleteSchedule(schedule.id!);

    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar('Agendar Consulta'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'SELECIONE O DIA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TableCalendar(
                locale: 'pt-br',
                focusedDay: selectedDate,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Horário:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text("Selecionar Horário"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Compromissos agendados:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _schedules.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Nenhum agendamento ainda."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = _schedules[index];
                        return ListTile(
                          title: Text(schedule.formattedDateTime),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteAppointment(index),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(selectedIndex: 1),
    );
  }
}
