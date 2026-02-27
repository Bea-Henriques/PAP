import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: 
          AppBar(
            title: CustomText(text: 'Olá Username', fontSize: 22),
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.blue, size: 30),
            actions: [
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.person)),
            ],
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.transparent,
            onDestinationSelected: (int index){
              setState(() {
                _currentPageIndex = index;
              });
            },
            indicatorColor: Colors.blue.shade100,
            selectedIndex: _currentPageIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.dashboard, size: 26),
                icon: Icon(Icons.dashboard_outlined, size: 26),
                label: 'Dashboard',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.folder, size: 26),
                icon: Icon(Icons.folder_open_outlined, size: 26),
                label: 'Projects',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.calendar_today, size: 26),
                icon: Icon(Icons.calendar_today_outlined, size: 26),
                label: 'Today',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.chat_bubble, size: 26),
                icon: Icon(Icons.chat_bubble_outline, size: 26),
                label: 'Chatbot',
              ),
            ]),
      ),
    );
  }
}