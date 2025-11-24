import 'package:flutter/material.dart';
import 'task.dart';

class StatsPage extends StatelessWidget {
  final List<Task> tasks;

  const StatsPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;

    double progress = total == 0 ? 0 : completed / total;

    // Count subjects
    Map<String, int> subjectCounts = {};
    for (var task in tasks) {
      subjectCounts[task.subject] = (subjectCounts[task.subject] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overall Progress",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Progress Bar
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${(progress * 100).toStringAsFixed(1)}% completed",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Basic counts
            Text(
              "Task Breakdown",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBox(label: "Total", value: total),
                _StatBox(label: "Completed", value: completed),
                _StatBox(label: "Pending", value: pending),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Tasks per Subject",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: subjectCounts.isEmpty
                  ? const Center(child: Text("No subjects yet"))
                  : ListView(
                children: subjectCounts.entries.map((entry) {
                  return ListTile(
                    leading: const Icon(Icons.book_outlined),
                    title: Text(entry.key),
                    trailing: Text("${entry.value} tasks"),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small stats widget
class _StatBox extends StatelessWidget {
  final String label;
  final int value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
