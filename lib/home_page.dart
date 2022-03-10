import 'package:crud_app/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'package:crud_app/item_model.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          _titleController.text = '';
                          _descriptionController.text = '';
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await _addItem();
                          }

                          if (id != null) {
                            await _updateItem(id);
                          }

                          _titleController.text = '';
                          _descriptionController.text = '';

                          Navigator.of(context).pop();
                        },
                        child: Text(id == null ? 'Create New' : 'Update'),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
      ItemTodo(
        title: _titleController.text,
        description: _descriptionController.text,
      ),
    );
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      ItemTodo(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
      ),
    );
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a Task'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1B89BC),
          title: Text(widget.title),
          actions: <Widget>[
            GestureDetector(
              onTap: () => _showForm(null),
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Color(0xffFAFAFC),
        body: SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _journals.length,
                    itemBuilder: (context, index) => CustomListTile(
                          _journals[index]['title'],
                          _journals[index]['description'],
                          onUpdate: () => _showForm(_journals[index]['id']),
                          onDelete: () => _deleteItem(_journals[index]['id']),
                        )
                    // Card(
                    //   color: Colors.blue[200],
                    //   margin: const EdgeInsets.all(15),
                    //   child: ListTile(
                    //       title: Text(
                    //         _journals[index]['title'],
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       subtitle: Text(
                    //         _journals[index]['description'],
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.white70,
                    //         ),
                    //       ),
                    //       trailing: SizedBox(
                    //         width: 100,
                    //         child: Row(
                    //           children: [
                    //             IconButton(
                    //               icon: const Icon(
                    //                 Icons.edit,
                    //                 color: Colors.white,
                    //               ),
                    //               onPressed: () =>
                    //                   _showForm(_journals[index]['id']),
                    //             ),
                    //             IconButton(
                    //               icon: const Icon(
                    //                 Icons.delete,
                    //                 color: Colors.white,
                    //               ),
                    //               onPressed: () =>
                    //                   _deleteItem(_journals[index]['id']),
                    //             ),
                    //           ],
                    //         ),
                    //       )),
                    // ),
                    )));
  }
}
