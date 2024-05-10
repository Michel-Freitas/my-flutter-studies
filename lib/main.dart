import 'package:flutter/material.dart';

import 'screens/TodoListHome.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: TodoListHome(),
    );
  }
}