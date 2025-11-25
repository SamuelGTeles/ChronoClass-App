import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'subjects_page.dart';
import 'personal_tasks_page.dart';
import 'schedule_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7A6592);
    const Color backgroundColor = Color(0xFFE9DEF0);

    // Lista de páginas
    final List<Widget> pages = [
      CalendarPage(user: widget.user),
      SubjectsPage(user: widget.user),
      PersonalTasksPage(user: widget.user),
      const SchedulePage(),
      SettingsPage(user: widget.user),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Chrono Class'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Matérias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Tarefas'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Aulas'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config.'),
        ],
      ),
    );
  }
}