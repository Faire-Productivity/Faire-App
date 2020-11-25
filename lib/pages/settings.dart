import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Uri _faireGitHubUri = Uri.https('github.com', '/Faire-Productivity/Faire-App/issues');
  bool _lyticsEnabled = false;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Your Data', style: TextStyle(color: Colors.pink, fontSize: 14, fontWeight: FontWeight.bold),),
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              SwitchListTile(
                title: Text("Enable Analytics", style: TextStyle(fontWeight: FontWeight.bold),),
                secondary: Icon(Icons.analytics),
                value: _lyticsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _lyticsEnabled = !_lyticsEnabled;
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text('Experimental', style: TextStyle(color: Colors.pink, fontSize: 14, fontWeight: FontWeight.bold),),
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              SwitchListTile(
                title: Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold),),
                secondary: Icon(Icons.nights_stay),
                value: _darkModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _darkModeEnabled = !_darkModeEnabled;
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text('Other', style: TextStyle(color: Colors.pink, fontSize: 14, fontWeight: FontWeight.bold),),
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text("Report an Issue", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  launch(_faireGitHubUri.toString());
                },
                leading: Icon(Icons.bug_report),
              ),
              ListTile(
                title: Text("About", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  showAbout();
                },
                leading: Icon(Icons.info),
              )
            ],
          ),
        ],
      )
    );
  }

  showAbout() {
    showAboutDialog(
      context: context,
      applicationName: "Faire",
      applicationVersion: "0.1.2",
      applicationIcon: Image.asset("assets/faire_favicon.png",height: 50,),
      children: [
        Text("Faire, a new way to be productive.")
      ]
    );
  }
}