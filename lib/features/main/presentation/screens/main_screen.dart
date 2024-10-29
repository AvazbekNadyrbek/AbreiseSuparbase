import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Услуги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Запись',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Оплата',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/services');
              break;
            case 2:
              context.go('/booking');
              break;
            case 3:
              context.go('/payment');
              break;
          }
        },
      ),
    );
  }
}
