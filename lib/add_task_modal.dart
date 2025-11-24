import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Task) onAdd;
  const AddTaskModal({super.key, required this.onAdd});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String subject = '';
  String date = '';
  int duration = 60;
  String priority = 'medium';
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Study Task',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                // Title
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter task title' : null,
                  onSaved: (v) => title = v!,
                ),
                // Subject
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Subject'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter subject' : null,
                  onSaved: (v) => subject = v!,
                ),
                // Date
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Enter date' : null,
                  onSaved: (v) => date = v!,
                ),
                // Duration
                TextFormField(
                  decoration:
                  const InputDecoration(labelText: 'Duration (min)'),
                  keyboardType: TextInputType.number,
                  initialValue: '60',
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter duration';
                    int? val = int.tryParse(v);
                    if (val == null || val < 15) return 'Min 15 minutes';
                    return null;
                  },
                  onSaved: (v) => duration = int.parse(v!),
                ),
                // Priority
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Priority'),
                  value: priority,
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (v) => setState(() => priority = v!),
                ),
                // Notes
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                  onSaved: (v) => notes = v ?? '',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.onAdd(Task(
                              title: title,
                              subject: subject,
                              date: date,
                              duration: duration,
                              priority: priority,
                              notes: notes,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Task'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
