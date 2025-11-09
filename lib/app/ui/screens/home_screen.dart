import 'package:flutter/material.dart';
import 'package:text_reader/app/ui/screens/pages/home_page.dart';
import 'package:text_reader/app/ui/screens/pages/libary_page.dart';
import 'package:text_reader/app/ui/screens/pages/more_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> pages = [HomePage(), LibaryPage(), MorePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: 'Libary',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'More'),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     PostServices.getAll();
      //   },
      // ),
    );
  }
}
