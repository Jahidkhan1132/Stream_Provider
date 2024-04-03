import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:stream_provider_app/userModel.dart';

import 'db_helper.dart';

class UserProvider extends ChangeNotifier {
  Stream<List<User>> get userStream => _userStreamController.stream;

  final _userStreamController = StreamController<List<User>>();

  void fetchUsers() async {
    List<User> users = await DatabaseHelper.instance.getUsers();
    _userStreamController.add(users);
  }

  Future<void> addUser(User user) async {
    await DatabaseHelper.instance.insertUser(user);
    fetchUsers();
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await DatabaseHelper.instance.updateUser(user);
    fetchUsers();
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    await DatabaseHelper.instance.deleteUser(id);
    fetchUsers();
    notifyListeners();
  }
}