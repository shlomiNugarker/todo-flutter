import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

// ========================================
// Data Model - represents a single task
// ========================================
class Todo {
  String title; // Task text
  bool isDone; // Is completed

  Todo({required this.title, this.isDone = false});
}

// ========================================
// Main Widget - App configuration
// ========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false, // Hides the "DEBUG" banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TodoApp(),
    );
  }
}

// ========================================
// TodoApp - Main screen (with State)
// ========================================
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});rr

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // List of tarrsks - this is our State
  final List<Todo> _todos = [];

  // Controller for the text field in dialog
  final TextEditingController _textController = TextEditingController();

  // ========================================
  // Functions for managing tasks
  // ========================================

  // Add a new task
  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter task...',
            ),
            autofocus: true,
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            // Add button
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    _todos.add(Todo(title: _textController.text));
                  });
                  _textController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Toggle task status (completed / not completed)
  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  // Delete a task
  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  // ========================================
  // Building the UI
  // ========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar - Top bar
      appBar: AppBar(
        title: const Text('My Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // Body - Screen content
      body: _todos.isEmpty
          // If no tasks - show message
          ? const Center(
              child: Text(
                'No tasks yet!\nTap + to add one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          // If there are tasks - show list
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  // Checkbox on the left
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => _toggleTodo(index),
                  ),
                  // Task text
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      // Strikethrough if completed
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      // Gray color if completed
                      color: todo.isDone ? Colors.grey : null,
                    ),
                  ),
                  // Delete button on the right
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(index),
                  ),
                );
              },
            ),

      // Floating button to add task
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
