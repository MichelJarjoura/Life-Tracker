import 'package:flutter/material.dart';
import 'package:liquidity_tracker/widgets/activity_buttons.dart';
import 'package:liquidity_tracker/widgets/calendar_card.dart';

enum DayStatus { workout, missed, rest }

class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          CalendarCard(),
          SizedBox(height: 20),
          ActivityButtons(),
        ],
      ),
    );
  }
}
