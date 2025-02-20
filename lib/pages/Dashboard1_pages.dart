import 'package:flutter/material.dart';
import 'package:monitoreo_lugares_tk/custom/CustomNavigator_bar.dart';
import 'package:monitoreo_lugares_tk/pages/Pagina1_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Pagina2_pages.dart';
import 'package:monitoreo_lugares_tk/services/ui_provider_dashboard1.dart';
import 'package:provider/provider.dart';

class Dashboard1 extends StatelessWidget {
  static const String routename = 'Dashboard1';
  const Dashboard1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
}   

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    
    final UiProviderSelected = Provider.of<UiProvider>(context);
    final currentIndex = UiProviderSelected.seleccionMenu;

    switch (currentIndex) {
      case 0: 
         return Pagina1();
      case 1: 
         return const Pagina2();  
      default:
         return Pagina1 ();
    }
  }
}