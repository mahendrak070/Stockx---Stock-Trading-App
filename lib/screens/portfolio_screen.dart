import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PortfolioTransaction {
  final String stockName;
  final bool isBuy; // true = buy (cash out), false = sell (cash in)
  final int shares;
  final double price;
  final DateTime date;

  PortfolioTransaction({
    required this.stockName,
    required this.isBuy,
    required this.shares,
    required this.price,
    required this.date,
  });

  double get total => shares * price * (isBuy ? -1 : 1);
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final List<PortfolioTransaction> _transactions = [];

  double get _balance =>
      _transactions.fold(0.0, (sum, tx) => sum + tx.total);

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final stockCtrl = TextEditingController();
    final sharesCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    bool isBuy = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Transaction'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: sharesCtrl,
                decoration: const InputDecoration(labelText: 'Shares'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || int.tryParse(v) == null
                        ? 'Enter a number'
                        : null,
              ),
              TextFormField(
                controller: priceCtrl,
                decoration:
                    const InputDecoration(labelText: 'Price per Share'),
                keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || double.tryParse(v) == null
                        ? 'Enter a number'
                        : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Type:'),
                  const SizedBox(width: 10),
                  DropdownButton<bool>(
                    value: isBuy,
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Buy')),
                      DropdownMenuItem(value: false, child: Text('Sell')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => isBuy = v);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final tx = PortfolioTransaction(
                  stockName: stockCtrl.text.trim(),
                  shares: int.parse(sharesCtrl.text.trim()),
                  price: double.parse(priceCtrl.text.trim()),
                  isBuy: isBuy,
                  date: DateTime.now(),
                );
                setState(() => _transactions.insert(0, tx));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          Switch(
            value: themeProv.isDarkMode,
            onChanged: (_) => themeProv.toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Balance: \$${_balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(child: Text('No transactions yet'))
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (ctx, i) {
                      final t = _transactions[i];
                      return ListTile(
                        leading: Icon(
                          t.isBuy ? Icons.call_made : Icons.call_received,
                          color: t.isBuy ? Colors.red : Colors.green,
                        ),
                        title: Text(t.stockName),
                        subtitle: Text(
                          '${t.shares} × \$${t.price.toStringAsFixed(2)}\n'
                          '${t.date.toLocal().toString().split('.')[0]}',
                        ),
                        trailing: Text(
                          '${t.total >= 0 ? '+' : ''}\$${t.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                t.total >= 0 ? Colors.green : Colors.red, //Added Color Red
                          ),
                        ),
                        isThreeLine: true,
                      );
                    },
                  ), 
          ),
        ],
      ),
    );
  }
}
