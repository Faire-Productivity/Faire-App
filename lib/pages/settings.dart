import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("About", style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: () {
              showAbout();
            },
          )
        ],
      ),
    );
  }

  showAbout() {
    showAboutDialog(
      context: context,
      applicationName: "Faire",
      applicationVersion: "0.1.1-Github",
      applicationIcon: Image.asset("assets/faire_favicon.png",height: 50,),
      children: [
        Text("Faire, a new way to be productive.")
      ]
    );
  }
}
