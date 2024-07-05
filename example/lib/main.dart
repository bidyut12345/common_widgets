import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
      //   useMaterial3: true,
      // ),
      themeMode: _themeMode,
      home: const MyHomePage(title: 'Common Widget Demo'),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var ddl = DropDownController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CustomDropDown(
              datasource: [
                {"name": "Sample1"},
                {"name": "Sample2"},
                {"name": "Sample3"},
              ],
              displayMember: "name",
              valueMember: "name",
              labelText: "test",
            ),
            CustomTextbox(controller: TextEditingController(), labelText: "labelText", hintText: "hintText"),
            CustomDropDown(
              controller: ddl,
              datasource: const [
                {"name": "Sample1"},
                {"name": "Sample2"},
                {"name": "Sample3"},
              ],
              displayMember: "name",
              valueMember: "name",
              labelText: "test",
            ),
            CustomTextbox(controller: TextEditingController(), labelText: "labelText", hintText: "hintText"),
            const CustomDropDown(
              datasource: [
                {"name": "Sample1"},
                {"name": "Sample2"},
                {"name": "Sample3"},
              ],
              displayMember: "name",
              valueMember: "name",
              labelText: "test",
            ),
            CustomTextbox(controller: TextEditingController(), labelText: "labelText", hintText: "hintText"),
            CustomButton(
                text: "asdasd",
                onPressed: () {
                  ddl.selectedValue = "Sample2";
                  // ddl.d
                  // MyApp.of(context).changeTheme(ThemeMode.dark);
                }),
          ],
        ),
      ),
    );
  }
}
