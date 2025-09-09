import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperapp/practice_new.dart/model_table.dart';

class FlutterTables extends StatefulWidget {
  const FlutterTables({super.key});

  @override
  State<FlutterTables> createState() => _FlutterTablesState();
}

class _FlutterTablesState extends State<FlutterTables> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TableProvider>(context, listen: false).fetchUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TableProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("DataTable", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  showFirstLastButtons: true,
                  rowsPerPage: 10,
                  columns: [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Street")),
                    DataColumn(label: Text("City")),
                    DataColumn(label: Text("Zipcode")),
                    DataColumn(label: Text("Actions")),
                  ],
                  source: UserDataSource(provider.users, provider, context),
                  dividerThickness: 1,
                ),
              ),
            ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<Map<String, dynamic>> users;
  final TableProvider provider;
  final BuildContext context;

  UserDataSource(this.users, this.provider, this.context);

  @override
  DataRow getRow(int index) {
    final user = users[index];
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),

        DataCell(Text("${user['firstName']} ${user['lastName']}")),
        DataCell(Text(user['email'].toString())),
        DataCell(Text(user['address']['address'].toString())),
        DataCell(Text(user['address']['city'].toString())),
        DataCell(Text(user['address']['postalCode'].toString())),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => showEditDialog(user, index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => provider.deleteUser(index),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showEditDialog(Map<String, dynamic> user, int index) {
    final nameController = TextEditingController(
      text: "${user['firstName']} ${user['lastName']}",
    );
    final emailController = TextEditingController(text: user['email']);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateUser(
                  index,
                  nameController.text,
                  emailController.text,
                );
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => users.length;
  @override
  int get selectedRowCount => 0;
}
