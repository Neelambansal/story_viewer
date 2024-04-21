import 'package:flutter/material.dart';
import 'package:story_viewer/repository/user_repository.dart';
import 'story_viewer_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'StoryViewer Demo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Tap to see user's stories",
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold))),
            FutureBuilder<List<Users>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final users = snapshot.data;
                  return buildUsersView(users!);
                }

                if (snapshot.hasError) {
                  return const Text("No data available");
                }

                return const Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              future: UserRepository.getUsers(),
            )
          ],
        ));
  }

  Widget buildUsersView(List<Users> users) {
    return SizedBox(
        height: 80.0,
        child: ListView.builder(
            itemExtent: 100.0,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoryViewerScreen(
                                    userImage: users[index].image)))
                      },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 70.0,
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      users[index].image ?? "",
                                    ),
                                    radius: 60.0,
                                  ))),
                        )),
                  ));
            }));
  }
}
