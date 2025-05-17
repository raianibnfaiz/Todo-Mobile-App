import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'In Progress', icon: Icon(Icons.pending_actions)),
            Tab(text: 'Pending', icon: Icon(Icons.access_time)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle_outline)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodoList(
            todos: context.watch<TodoProvider>().inProgressTodos,
            emptyMessage: 'No tasks in progress',
          ),
          TodoList(
            todos: context.watch<TodoProvider>().pendingTodos,
            emptyMessage: 'No pending tasks',
          ),
          TodoList(
            todos: context.watch<TodoProvider>().completedTodos,
            emptyMessage: 'No completed tasks',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const AddTodoModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 