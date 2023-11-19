import 'package:newsqlite/database/strings.dart';

import '../database/database_helper.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class UserController {
  DatabaseHelper datahelper = DatabaseHelper();

  Future<int> insertUser(User user) async {
    final db = await datahelper.db;
    final result = await db.insert(Strings.tableUsers, user.toMap());
    return result;
  }

  Future<int> getUsersCount() async {
    final db = await datahelper.db;
    final result =
        await db.rawQuery('SELECT COUNT(*) FROM ${Strings.tableUsers}');
    return result.first.values.first as int;
  }

  Future<List<User>> getAllUsers() async {
    final db = await datahelper.db;
    final List<Map<String, Object?>> result =
        await db.query(Strings.tableUsers);
    return result.map((user) => User.fromMap(user)).toList();
  }

  Future<bool> insertPost(Post post) async {
    try {
      final db = await datahelper.db;
      // ignore: unused_local_variable
      final result = await db.insert(Strings.tablePosts, post.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getPostsCount() async {
    final db = await datahelper.db;
    final result =
        await db.rawQuery('SELECT COUNT(*) FROM ${Strings.tablePosts}');
    return result.first.values.first as int;
  }

  Future<List<Post>> getAllPosts() async {
    final db = await datahelper.db;
    final result = await db.query(Strings.tablePosts);
    return result.map((post) => Post.fromMap(post)).toList();
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    final db = await datahelper.db;
    final result = await db.query(Strings.tablePosts,
        where: '${Strings.columnUserID} = ?', whereArgs: [userId]);
    return result.map((post) => Post.fromMap(post)).toList();
  }
}
