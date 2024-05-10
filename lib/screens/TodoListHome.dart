import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListHome extends StatefulWidget {
  const TodoListHome({Key? key}) : super(key: key);

  @override
  State<TodoListHome> createState() => _TodoListHomeState();
}

class _TodoListHomeState extends State<TodoListHome> {
  final TextEditingController _tarefaController = TextEditingController();
  List<String> _todoList = [];

  void _salveTodo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', _todoList);
  }

  void _loadTodoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList = prefs.getStringList('todoList') ?? [];
    });
  }

  void _addTodo() {
    setState(() {
      _todoList.add(_tarefaController.text);
      _tarefaController.clear();
    });
    _salveTodo();
  }

  void _editTodo(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Editar Tarefa"),
            content: TextField(
              controller: TextEditingController(text: _todoList[index]),
              decoration: const InputDecoration(labelText: "Tarefa"),
              onChanged: (value) {
                setState(() {
                  _todoList[index] = value;
                });
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _tarefaController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    _salveTodo();
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'))
            ],
          );
        });
  }

  void _deleteTodo(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deletar Tarefa'),
            content: Text('Deseja realmente deletar a tarefa?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _todoList.removeAt(index);
                    });
                    _salveTodo();
                    Navigator.pop(context);
                  },
                  child: const Text('Deletar'))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_todoList[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        _editTodo(index);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        _deleteTodo(index);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _tarefaController,
                    decoration: const InputDecoration(labelText: "Tarefa"),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _tarefaController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    TextButton(
                        onPressed: () {
                          _addTodo();
                          Navigator.pop(context);
                        },
                        child: const Text('Adicionar'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
