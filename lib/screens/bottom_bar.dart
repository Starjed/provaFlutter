import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/screens/converter.dart';
import 'package:lista_de_tarefas/screens/weather_page.dart';
import 'package:lista_de_tarefas/screens/to_do_page.dart';

class BottomBar  extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget> [
    const WeatherPage(),
    const ToDoPage(),
    const Converter(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_weather_cloudy_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_weather_cloudy_filled), label: "Weather"),
          BottomNavigationBarItem(icon: Icon(FluentSystemIcons.ic_fluent_note_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_note_filled), label: "Task"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.bitcoin_circle),
              activeIcon: Icon(CupertinoIcons.bitcoin_circle_fill), label: "Coin"),
        ],),
    );
  }
}
