import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../services/news_api_service.dart';
import '../models/news.dart';
import '../widgets/news_card.dart';

class FinancialNewsScreen extends StatefulWidget {
  const FinancialNewsScreen({super.key});
  @override
  _FinancialNewsScreenState createState() => _FinancialNewsScreenState();
}

class _FinancialNewsScreenState extends State<FinancialNewsScreen> {
  final _newsService = NewsApiService();
  List<News>? _news;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    try {
      _news = await _newsService.fetchFinancialNews();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading news: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial News'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNews),
          Switch(
            value: themeProv.isDarkMode,
            onChanged: (_) => themeProv.toggleTheme(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_news == null || _news!.isEmpty)
              ? const Center(child: Text('No news available'))
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    itemCount: _news!.length,
                    itemBuilder: (ctx, i) {
                      final a = _news![i];
                      return NewsCard(
                        headline: a.headline,
                        source: a.source,
                        snippet: a.snippet,
                        onTap: () async {
                          if (await canLaunch(a.url)) await launch(a.url);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
