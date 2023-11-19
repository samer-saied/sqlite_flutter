import 'package:flutter/material.dart';
import 'package:newsqlite/controller/user_controller.dart';
import 'package:newsqlite/models/post_model.dart';

import 'models/user_model.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  User? dropdownValue;
  List<User> users = [];
  String title = "";
  String content = "";

  void _fetchUsers() async {
    users = await UserController().getAllUsers();
    setState(() {
      dropdownValue = users.first;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Add Post"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<User>>(
                future: UserController().getAllUsers(),
                builder: (context, data) {
                  switch (data.connectionState) {
                    case ConnectionState.done:
                      return DropdownButton<User>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (User? user) {
                          setState(() {
                            dropdownValue = user;
                          });
                        },
                        items: users.map<DropdownMenuItem<User>>((User value) {
                          return DropdownMenuItem<User>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      );
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return const Center(child: Text('No Data'));
                  }
                },
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'title',
                ),
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    title = value;
                  }
                },
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'content',
                ),
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    content = value;
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Post post = Post(
                        id: await UserController().getPostsCount() + 1,
                        userId: dropdownValue!.id,
                        title: title,
                        content: content,
                      );
                      await UserController().insertPost(post).then((value) {
                        value
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("Done"),
                                  );
                                },
                              )
                            : null;
                      });
                    },
                    child: const Text('Add Post'),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
