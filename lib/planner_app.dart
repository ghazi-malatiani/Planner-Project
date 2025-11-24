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
  String sortMode = "date";
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await TaskStorage.loadTasks();
    sortTasks();
    setState(() => loading = false);
  }

  void saveTasks() => TaskStorage.saveTasks(tasks);

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      sortTasks();
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
      backgroundColor: isDarkMode ? Colors.grey[900] : null, // <-- Dark background
      builder: (_) => AddTaskModal(
        onAdd: addTask,
        isDarkMode: isDarkMode, 
      ),
    );
  }


  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high": return Colors.redAccent;
      case "medium": return Colors.orangeAccent;
      case "low": return Colors.green;
      default: return Colors.blueGrey;
    }
  }

  void sortTasks() {
    setState(() {
      if (sortMode == "date") {
        tasks.sort((a, b) => a.date.compareTo(b.date));
      } else if (sortMode == "duration") {
        tasks.sort((a, b) => a.duration.compareTo(b.duration));
      } else if (sortMode == "priority") {
        const order = {"high": 0, "medium": 1, "low": 2};
        tasks.sort((a, b) => order[a.priority]!.compareTo(order[b.priority]!));
      } else if (sortMode == "subject") {
        tasks.sort((a, b) => a.subject.toLowerCase().compareTo(b.subject.toLowerCase()));
      }
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.blue,
          title: const Text('Smart Student Planner'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => setState(() => isDarkMode = !isDarkMode),
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StatsPage(tasks: tasks, isDarkMode: isDarkMode,)),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: (value) {
                sortMode = value;
                sortTasks();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: "date", child: Text("Sort by Date")),
                const PopupMenuItem(value: "priority", child: Text("Sort by Priority")),
                const PopupMenuItem(value: "subject", child: Text("Sort by Subject")),
                const PopupMenuItem(value: "duration", child: Text("Sort by Duration")),
              ],
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: openAddTaskModal),
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
                priorityColor: getPriorityColor(tasks[index].priority),
                onToggleComplete: () => toggleComplete(index),
                onDelete: () => deleteTask(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
