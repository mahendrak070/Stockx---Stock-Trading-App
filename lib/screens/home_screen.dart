// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app_project/screens/portfolio_screen.dart';
import '../providers/theme_provider.dart';
import 'stock_watchlist_screen.dart';
import 'stock_data_screen.dart';
import 'financial_news_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockX'),
        centerTitle: true,
        actions: [
          Switch(
            value: themeProv.isDarkMode,
            onChanged: (_) => themeProv.toggleTheme(),
          ),
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20,
        ),
        children: [
          HomeButton(
            title: 'Stock Watchlist',
            icon: Icons.list_alt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StockWatchlistScreen()),
            ),
          ),
          HomeButton(
            title: 'Stock Data',
            icon: Icons.bar_chart,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StockDataScreen()),
            ),
          ),
          HomeButton(
            title: 'Financial News',
            icon: Icons.newspaper,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FinancialNewsScreen()),
            ),
          ),
          HomeButton(
            title: 'Portfolio',
            icon: Icons.pie_chart,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PortfolioScreen()),
            ),
          ),

      
        ],
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
