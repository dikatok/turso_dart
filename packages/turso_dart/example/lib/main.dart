import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turso_dart/turso_dart.dart';

void main() async {
  final path = await getApplicationSupportDirectory();
  final db = connect(LocalDbConfig('${path.path}/test.db'));
  final conn = db.connect();
  conn.execute(
    "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)",
  );
  conn.execute("INSERT INTO test (name) VALUES ('foo')");
  final res = conn.query("SELECT * FROM test");
  print(res);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Native Packages')),
        body: SingleChildScrollView(
          child: Container(
            padding: const .all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: .center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
