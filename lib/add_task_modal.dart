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
  DateTime? selectedDate;

  void pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


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
                GestureDetector(
                  onTap: pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Select date"
                              : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
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

                            if (selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a date")),
                              );
                              return;
                            }

                            _formKey.currentState!.save();
                            widget.onAdd(Task(
                              title: title,
                              subject: subject,
                              date: selectedDate!.toIso8601String(),
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
