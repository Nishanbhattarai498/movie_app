import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          authProvider.userName
                                  ?.substring(0, 1)
                                  .toUpperCase() ??
                              'U',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        authProvider.userName ?? 'User',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        authProvider.userEmail ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return ListTile(
                          leading: Icon(Icons.dark_mode),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: themeProvider.themeMode == ThemeMode.dark,
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to notifications settings
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help & Support'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to help
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'CineMax',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.movie),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sign Out'),
                        content: Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              authProvider.logout();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
