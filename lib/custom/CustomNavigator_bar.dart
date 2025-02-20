import 'package:flutter/material.dart';
import 'package:monitoreo_lugares_tk/services/ui_provider_dashboard1.dart';
import 'package:provider/provider.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.seleccionMenu;


    return BottomNavigationBar(

      onTap: (int i) => uiProvider.seleccionMenu = i,
      currentIndex: currentIndex,
      elevation: 20.0,
      iconSize: 30,
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xff272974),
      unselectedItemColor: const Color(0xff4792CC),
      showSelectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label:'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.widgets), label:'Registros'),
      ],
  


    );
  }
}