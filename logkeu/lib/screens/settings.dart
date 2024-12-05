import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Mode Gelap',
                style: TextStyle(fontFamily: 'Lato'),
              ),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleDarkMode(),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Tentang Aplikasi',
                style: TextStyle(fontFamily: 'Lato'),
              ),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Pencatat Keuangan',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(Icons.account_balance_wallet),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
