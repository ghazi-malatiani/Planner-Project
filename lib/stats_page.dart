import 'package:flutter/material.dart';
import 'task.dart';

class StatsPage extends StatelessWidget {
  final List<Task> tasks;

  const StatsPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    int completedTasks = tasks.where((t) => t.completed).length;
    int totalTasks = tasks.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total tasks: $totalTasks', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Completed tasks: $completedTasks', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Pending tasks: ${totalTasks - completedTasks}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
