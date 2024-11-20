import 'package:fit_app/application/components/widgets/defaultAppBar.widget.dart';
import 'package:fit_app/application/components/widgets/footer.widget.dart';
import 'package:fit_app/application/entities/schedule.entity.dart';
import 'package:fit_app/application/infra/@providers/User.provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
      final schedule = Schedule(date: selectedDate, time: selectedTime);

      if (_isTimeSlotTaken(
          userProvider.activeUser?.schedules ?? [], schedule)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horário já ocupado! Tente outro horário."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        userProvider.addSchedule(schedule);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horário agendado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
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

  void _deleteAppointment(int index) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.activeUser?.schedules.removeAt(index);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final schedules = userProvider.activeUser?.schedules ?? [];

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
                SizedBox(
                  height: 350,
                  child: TableCalendar(
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
                schedules.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Nenhum agendamento ainda."),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
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
        bottomNavigationBar: FooterWidget(selectedIndex: 3));
  }
}
