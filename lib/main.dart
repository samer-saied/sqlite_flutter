import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsqlite/controller/user_controller.dart';

import 'add_post_page.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

class _MyHomePageState extends State<MyHomePage> {
  final UserController userController = UserController();
  List<User> _users = [];
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _getAllUsers();
    _getAllPosts();
  }

  void _getAllUsers() async {
    final users = await userController.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  void _getAllPosts() async {
    final posts = await userController.getAllPosts();
    setState(() {
      _posts = posts;
    });
  }

  void _insertUser(User user) async {
    await userController.insertUser(user);
    _getAllUsers();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Sqlflite With flutter',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            //  overlayColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.people_alt,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(Icons.newspaper, color: Colors.white),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        title: Text("${user.id + 1} : ${user.name}"),
                        onTap: () async {
                          final posts =
                              await userController.getPostsByUserId(user.id);
                              if (kDebugMode) {
                                print(posts);
                              }
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add User'),
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              int count = await userController.getUsersCount();
                              _insertUser(User(id: count + 1, name: value));

                              setState(() {});
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('Add User'),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return ListTile(
                        title: Text(
                            "${post.id + 1} : ${_users[post.userId - 1].name} added ${post.title} post => ${post.content}"),
                        onTap: () async {
                          // ignore: unused_local_variable
                          final posts =
                              await userController.getPostsByUserId(post.id);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPostPage()));
                  },
                  child: const Text('Add Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
