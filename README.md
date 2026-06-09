# turso_dart

Dart binding for Turso, the evolution of libsql/re-write of sqlite

Local database
```Dart
  final path = await getApplicationSupportDirectory();
  final db = connect(LocalDbConfig('${path.path}/test.db'));
  final conn = db.connect();
  conn.execute(
    "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)",
  );
  conn.execute(
    "INSERT INTO test (name) VALUES (?1)",
    params: Params.positional(["Alice"]),
  );
  conn.execute(
    "INSERT INTO test (name) VALUES (:name)",
    params: Params.named({":name": "Bob"}),
  );
  final res = conn.query("SELECT * FROM test");
  print(res);
```

Sync database
```Dart

  final path = await getApplicationSupportDirectory();
  final db = connectSync(
    SyncDbConfig('${path.path}/sync.db', remoteUrl: "", authToken: ""),
  );
  final conn = db.connect();
  db.pull();
  conn.execute(
    "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)",
  );
  conn.execute(
    "INSERT INTO test (name) VALUES (?1)",
    params: Params.positional(["Alice"]),
  );
  conn.execute(
    "INSERT INTO test (name) VALUES (:name)",
    params: Params.named({":name": "Bob"}),
  );
  db.push();
  db.pull();
  final res = conn.query("SELECT * FROM user");
  print(res);
```