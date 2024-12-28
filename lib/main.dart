import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/users_class.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<Users> fetchData() async {
  try {
    final response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      return usersFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
         title: Text('Material App Bar'),
      ),
      body: Center(
        child: FutureBuilder<Users>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                var usersData = snapshot.data!;
                return ListView.builder(
                  itemCount: usersData.data.length,
                  itemBuilder: (context, index) {
                    var user = usersData.data[index];
                    return ListTile(
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      subtitle: Text(
                          user.email,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      leading: CircleAvatar(
                        maxRadius: 40,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Text('No data available');
          }
        )
      ),
    );
  }
}
