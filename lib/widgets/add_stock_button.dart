import 'package:flutter/material.dart';

class AddStockButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddStockButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.blue,
      child: Icon(Icons.add),
    );
  }
}
