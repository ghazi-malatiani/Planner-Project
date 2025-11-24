import 'package:flutter/material.dart';
import 'task.dart';

class StatsPage extends StatelessWidget {
  final List<Task> tasks;
  final bool isDarkMode;

  const StatsPage({super.key, required this.tasks, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;
    double progress = total == 0 ? 0 : completed / total;

    // Count tasks per subject
    Map<String, int> subjectCounts = {};
    for (var task in tasks) {
      subjectCounts[task.subject] = (subjectCounts[task.subject] ?? 0) + 1;
    }

    final bgColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.blue,
        title: Text("Statistics", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary Card
            Card(
              color: cardColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Progress",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${(progress * 100).toStringAsFixed(1)}% completed",
                      style: TextStyle(fontSize: 16, color: subTextColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Task Counts
            Text(
              "Task Breakdown",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBox(label: "Total", value: total, textColor: textColor),
                _StatBox(label: "Completed", value: completed, textColor: textColor),
                _StatBox(label: "Pending", value: pending, textColor: textColor),
              ],
            ),
            const SizedBox(height: 25),

            // Tasks per Subject
            Text(
              "Tasks per Subject",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: subjectCounts.isEmpty
                  ? Center(
                child: Text("No subjects yet", style: TextStyle(color: subTextColor)),
              )
                  : ListView(
                children: subjectCounts.entries.map((entry) {
                  return Card(
                    color: cardColor,
                    child: ListTile(
                      leading: Icon(Icons.book_outlined, color: textColor),
                      title: Text(entry.key, style: TextStyle(color: textColor)),
                      trailing: Text("${entry.value} tasks", style: TextStyle(color: subTextColor)),
                    ),
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
  final Color textColor;

  const _StatBox({required this.label, required this.value, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: textColor)),
      ],
    );
  }
}
