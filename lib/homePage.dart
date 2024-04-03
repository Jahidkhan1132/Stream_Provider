import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_provider_app/userModel.dart';
import 'package:stream_provider_app/userProvide.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context,listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stream Provider',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<User>>(
        stream: Provider.of<UserProvider>(context).userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<User>? users = snapshot.data as List<User>?;

          if (users == null || users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return   Card(
                color: Colors.orange.shade100,
                margin: const EdgeInsets.all(10),
                elevation: 3,

                child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,color: Colors.red,),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text('Are you sure you want to delete this user?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Close the dialog and delete the user
                                        Navigator.of(context).pop();
                                        if (user.id != null) {
                                          Provider.of<UserProvider>(context,listen: false).deleteUser(user.id!);
                                          // UserProvider().deleteUser(user.id!);
                                        }
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                        IconButton (
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController nameController = TextEditingController(text: user.name);
                                TextEditingController emailController = TextEditingController(text: user.email);

                                return AlertDialog(
                                  title: const Text('Edit User'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextField(
                                        controller: nameController,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(labelText: 'Name',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 11,
                                      ),
                                      TextField(
                                        controller: emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(labelText: 'Email',
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)
                                            )
                                        ),
                                      ),
                                    ],
                                  ),

                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        String newName = nameController.text;
                                        String newEmail = emailController.text;
                                        User updatedUser = User(id: user.id, name: newName, email: newEmail);
                                        Provider.of<UserProvider>(context, listen: false)
                                            .updateUser(updatedUser);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ],
                    )
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50),borderSide: BorderSide.none),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              TextEditingController emailController = TextEditingController();

              return AlertDialog(
                title: const Text('Add User'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),

                    ),

                    SizedBox(
                      height: 11,
                    ),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  ],
                ),

                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),

                  TextButton(
                    onPressed: () {
                      String name = nameController.text;
                      String email = emailController.text;
                      User newUser = User(name: name, email: email,);
                      Provider.of<UserProvider>(context, listen: false)
                          .addUser(newUser);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },backgroundColor: Colors.blue,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
