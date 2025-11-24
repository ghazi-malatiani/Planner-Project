import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskModal extends StatefulWidget {
  final Function(Task) onAdd;
  final bool isDarkMode;

  const AddTaskModal({super.key, required this.onAdd, required this.isDarkMode});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String subject = '';
  int duration = 60;
  String priority = 'medium';
  String notes = '';
  DateTime? selectedDate;

  final subjects = [
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'Web Programming',
    'Object Oriented Programming',
    'Mobile Application',
    'English',
    'History',
    'Geography',
    'Economics',
    'Psychology',
    'Art / Design',
    'Music',
    'Philosophy',
    'Languages',
    'Physical Education'
  ];

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: child!,
      ),
    );

    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final borderColor = widget.isDarkMode ? Colors.white54 : Colors.grey;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Study Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Task Title
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  validator: (v) => v == null || v.isEmpty ? 'Enter task title' : null,
                  onSaved: (v) => title = v!,
                ),
                const SizedBox(height: 12),

                // Subject Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  value: subject.isEmpty ? null : subject,
                  items: subjects
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => subject = v!),
                  validator: (v) => v == null || v.isEmpty ? 'Select a subject' : null,
                  dropdownColor: bgColor,
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 12),

                // Date Picker
                GestureDetector(
                  onTap: pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Select date"
                              : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2,'0')}-${selectedDate!.day.toString().padLeft(2,'0')}",
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        Icon(Icons.calendar_month, color: textColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Duration
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Duration (min)',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  style: TextStyle(color: textColor),
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
                const SizedBox(height: 12),

                // Priority
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  value: priority,
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (v) => setState(() => priority = v!),
                  dropdownColor: bgColor,
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 12),

                // Notes
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                  ),
                  maxLines: 3,
                  style: TextStyle(color: textColor),
                  onSaved: (v) => notes = v ?? '',
                ),

                const SizedBox(height: 12),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: BorderSide(color: textColor),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isDarkMode ? Colors.blueGrey : Colors.blue,
                        ),
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
