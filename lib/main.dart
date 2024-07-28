import 'package:flutter/material.dart';
import 'package:storage_test/services/isar.dart';
import 'package:storage_test/services/scheduler.dart';
import 'package:storage_test/stores/users_store.dart';
// import 'package:storage_test/stores/users_store_old.dart';
import 'package:signals/signals_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await isar.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SchedulerMixin {
  // final userStore = UsersStore();

  void fetch() {
    userStore.sync();
    // userStore.sync.fetch();
  }

  @override
  void initState() {
    super.initState();
    useScheduler(
      () {
        print('scheduler');
      },
      const Duration(minutes: 5),
      SchedulerOptions(trigger: SchedulerTrigger.appear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Watch((context) {
        final isLoading = userStore.isLoading.value;
        // final isLoading = userStore.sync.isLoading.value;
        final users = userStore.users.value;

        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: fetch,
        tooltip: 'Fetch data',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
