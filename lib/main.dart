import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_provider_app/userModel.dart';
import 'package:stream_provider_app/userProvide.dart';

import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        StreamProvider<List<User>>(
          create: (context) => Provider.of<UserProvider>(context, listen: false).userStream,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}