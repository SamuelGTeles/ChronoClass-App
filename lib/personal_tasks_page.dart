import 'package:flutter/material.dart';
import 'database_helper.dart';

class PersonalTasksPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const PersonalTasksPage({super.key, required this.user});

  @override
  State<PersonalTasksPage> createState() => _PersonalTasksPageState();
}

class _PersonalTasksPageState extends State<PersonalTasksPage> {
  List<Map<String, dynamic>> tasks = [];
  String currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasksList = await DatabaseHelper.instance.getPersonalTasks(widget.user['id']);
    setState(() {
      tasks = tasksList;
    });
  }

  Future<void> _addTask(String title, String priority) async {
    await DatabaseHelper.instance.insertPersonalTask({
      'title': title,
      'description': '',
      'priority': priority,
      'completed': 0,
      'created_by': widget.user['id'],
    });
    _loadTasks();
  }

  Future<void> _toggleTask(int taskId, bool completed) async {
    await DatabaseHelper.instance.updatePersonalTask(taskId, !completed);
    _loadTasks();
  }

  Future<void> _deleteTask(int taskId) async {
    await DatabaseHelper.instance.deletePersonalTask(taskId);
    _loadTasks();
  }

  List<Map<String, dynamic>> get _filteredTasks {
    switch (currentFilter) {
      case 'very_urgent':
        return tasks.where((task) => task['priority'] == 'very_urgent' && task['completed'] == 0).toList();
      case 'urgent':
        return tasks.where((task) => task['priority'] == 'urgent' && task['completed'] == 0).toList();
      case 'not_urgent':
        return tasks.where((task) => task['priority'] == 'not_urgent' && task['completed'] == 0).toList();
      case 'completed':
        return tasks.where((task) => task['completed'] == 1).toList();
      default:
        return tasks.where((task) => task['completed'] == 0).toList();
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'very_urgent': return Colors.red;
      case 'urgent': return Colors.orange;
      case 'not_urgent': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'very_urgent': return 'Muito Urgente';
      case 'urgent': return 'Urgente';
      case 'not_urgent': return 'Não Urgente';
      default: return 'Normal';
    }
  }

  void _showAddTaskDialog() {
    String title = '';
    String priority = 'urgent';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Título da Tarefa'),
              onChanged: (value) => title = value,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: priority,
              items: const [
                DropdownMenuItem(value: 'very_urgent', child: Text('Muito Urgente')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgente')),
                DropdownMenuItem(value: 'not_urgent', child: Text('Não Urgente')),
              ],
              onChanged: (value) => priority = value!,
              decoration: const InputDecoration(labelText: 'Prioridade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty) {
                _addTask(title, priority);
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarefas Pessoais',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Organize e priorize suas tarefas pessoais. As atividades da turma estão no Calendário.'),
              ],
            ),
          ),

          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Todas', 'all'),
                _buildFilterChip('Muito Urgente', 'very_urgent'),
                _buildFilterChip('Urgente', 'urgent'),
                _buildFilterChip('Não Urgente', 'not_urgent'),
                _buildFilterChip('Concluídas', 'completed'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de tarefas
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma tarefa encontrada',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tente ajustar seus filtros ou criar uma nova tarefa.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = _filteredTasks[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['completed'] == 1,
                            onChanged: (value) => _toggleTask(task['id'], task['completed'] == 1),
                          ),
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: task['completed'] == 1 
                                  ? TextDecoration.lineThrough 
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(_getPriorityText(task['priority'])),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(task['priority']),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (task['completed'] == 0)
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _deleteTask(task['id']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: currentFilter == value,
        onSelected: (selected) {
          setState(() {
            currentFilter = value;
          });
        },
      ),
    );
  }
}