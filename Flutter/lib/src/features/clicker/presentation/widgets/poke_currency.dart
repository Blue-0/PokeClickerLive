import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PokeCurrency extends StatefulWidget {
  final int currency;
  final TextStyle? style;

  const PokeCurrency({super.key, required this.currency, this.style});

  @override
  State<PokeCurrency> createState() => _PokeCurrencyState();
}

class _PokeCurrencyState extends State<PokeCurrency>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  int _oldCurrency = 0;

  @override
  void initState() {
    super.initState();
    _oldCurrency = widget.currency;
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant PokeCurrency oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currency > oldWidget.currency) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    }
    _oldCurrency = oldWidget.currency;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en_US');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.monetization_on, color: Colors.amber),
        const SizedBox(width: 4),
        ScaleTransition(
          scale: _scaleAnimation,
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: _oldCurrency, end: widget.currency),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Text(
                '₽ ${formatter.format(value)}',
                style:
                    widget.style ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ],
    );
  }
}
