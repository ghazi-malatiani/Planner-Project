import 'package:flutter/material.dart';
import 'task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final Color priorityColor;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;
    final greyText = textColor!.withOpacity(0.7);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: task.completed
              ? Colors.green.withOpacity(0.5)
              : priorityColor,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + actions row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration:
                      task.completed ? TextDecoration.lineThrough : null,
                      color: task.completed ? greyText : textColor,
                      fontSize: 17,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: task.completed ? Colors.green : greyText,
                      ),
                      onPressed: onToggleComplete,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Subject: ${task.subject}', style: TextStyle(color: greyText)),
            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(task.date, style: TextStyle(color: textColor)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('${task.duration} min', style: TextStyle(color: textColor)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                task.priority[0].toUpperCase() + task.priority.substring(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (task.notes.isNotEmpty) ...[
              const Divider(height: 14),
              Text(task.notes, style: TextStyle(color: greyText)),
            ]
          ],
        ),
      ),
    );
  }
}
