import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'news_screen.dart';
import 'watchlist_screen.dart';
import 'market_screen.dart';
import 'portfolio_screen.dart'; // Import your PortfolioScreen
import 'stocks.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  static const String id = 'Main_screen';

  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const UserProfileScreen(),
    const NewsScreen(),
    const WatchlistScreen(),
    MarketScreen(),
    const PortfolioScreen(),
    const StocksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Stocks',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
