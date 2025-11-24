class Task {
  String title;
  String subject;
  String date;
  int duration;
  String priority;
  String notes;
  bool completed;

  Task({
    required this.title,
    required this.subject,
    required this.date,
    required this.duration,
    required this.priority,
    this.notes = '',
    this.completed = false,
  });


  List<String> toList() => [
    title,
    subject,
    date,
    duration.toString(),
    priority,
    notes,
    completed ? '1' : '0',
  ];


  factory Task.fromList(List<String> data) => Task(
    title: data[0],
    subject: data[1],
    date: data[2],
    duration: int.parse(data[3]),
    priority: data[4],
    notes: data[5],
    completed: data[6] == '1',
  );
}
