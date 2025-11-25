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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CalendarPage(user: widget.user),
      SubjectsPage(user: widget.user),
      PersonalTasksPage(user: widget.user),
      const SchedulePage(),
      SettingsPage(user: widget.user),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE9DEF0),
      appBar: AppBar(
        title: const Text('Chrono Class'),
        backgroundColor: const Color(0xFF7A6592),
        foregroundColor: Colors.white,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7A6592),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Matérias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Aulas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config.',
          ),
        ],
      ),
    );
  }
}