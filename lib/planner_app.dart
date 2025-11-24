import 'package:flutter/material.dart';
import 'task.dart';
import 'task_storage.dart';
import 'task_card.dart';
import 'add_task_modal.dart';
import 'stats_page.dart';

class PlannerApp extends StatefulWidget {
  const PlannerApp({super.key});

  @override
  State<PlannerApp> createState() => _PlannerAppState();
}

class _PlannerAppState extends State<PlannerApp> {
  List<Task> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await TaskStorage.loadTasks();
    setState(() {
      loading = false;
    });
  }

  void saveTasks() {
    TaskStorage.saveTasks(tasks);
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      saveTasks();
    });
  }

  void toggleComplete(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      saveTasks();
    });
  }

  void deleteTask(int index) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed ?? false) {
      setState(() {
        tasks.removeAt(index);
        saveTasks();
      });
    }
  }

  void openAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTaskModal(onAdd: addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Student Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsPage(tasks: tasks),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openAddTaskModal,
          ),
        ],
      ),

      body: tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No tasks yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('Start planning your study schedule.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: openAddTaskModal,
              child: const Text('Add Your First Task'),
            )
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TaskCard(
              task: tasks[index],
              onToggleComplete: () => toggleComplete(index),
              onDelete: () => deleteTask(index),
            ),
          ),
        ),
      ),
    );
  }
}
