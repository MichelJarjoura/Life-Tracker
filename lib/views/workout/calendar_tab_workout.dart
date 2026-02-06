import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTabWorkout extends StatelessWidget {
  const CalendarTabWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// Current Split
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Push/Pull/Legs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.settings, color: Colors.black),
                          SizedBox(width: 5),
                          Text(
                            "Change split",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text("6-day split focusing on push, pull, and legs"),
                const SizedBox(height: 15),
                const Text(
                  "Weekly schedule:",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 10,
                  runSpacing: 10,
                  direction: Axis.horizontal,
                  children: [
                    _ScheduleCard(),
                    _ScheduleCard(),
                    _ScheduleCard(),
                    _ScheduleCard(),
                    _ScheduleCard(),
                    _ScheduleCard(),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Stats row
        Row(
          children: const [
            Expanded(child: _StatCard("4", "Completed")),
            SizedBox(width: 8),
            Expanded(child: _StatCard("2", "Missed")),
            SizedBox(width: 8),
            Expanded(child: _StatCard("6", "Total")),
          ],
        ),

        const SizedBox(height: 16),

        /// Calendar placeholder
        Card(
          child: Container(
            alignment: Alignment.center,
            child: TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime(2022),
              lastDay: DateTime(2028),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard(this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        elevation: 0,
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Push 1:"),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Chest"),
                    ),
                  ),

                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("shoulders"),
                    ),
                  ),
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("triceps"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
