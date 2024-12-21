import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // 할 일 항목을 저장할 리스트
  final List<Map<String, String>> _todos = [];

  // 할 일 추가
  void _addTodo(String title, String description) {
    setState(() {
      _todos.add({'title': title, 'description': description});
    });
  }

  // 할 일 삭제
  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index); // 해당 항목을 리스트에서 삭제
    });
  }

  // 새로운 할 일을 추가하는 화면으로 이동
  void _navigateToAddTaskScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    // 새 할 일이 반환되면 리스트에 추가
    if (result != null) {
      _addTodo(result['title'], result['description']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 할 일 목록 표시
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(todo['title']!),
                      subtitle: Text(todo['description']!),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTodo(index),
                      ),
                    ),
                    Divider(), // 항목 사이에 구분선 추가
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // + 버튼: 새로운 할 일을 추가하는 화면으로 이동
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTaskScreen(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("할 일 추가하기"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 제목 입력 필드
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // 설명 입력 필드
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 4, // 여러 줄로 입력 가능
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text.trim();
                final String description = _descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  // 입력된 데이터를 반환하며 화면을 닫음
                  Navigator.pop(context, {'title': title, 'description': description});
                }
              },
              child: Text("추가하기"),
            ),
          ],
        ),
      ),
    );
  }
}
