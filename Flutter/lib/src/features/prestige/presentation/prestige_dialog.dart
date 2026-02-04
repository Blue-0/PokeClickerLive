import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/prestige/application/prestige_controller.dart';

class PrestigeConfirmationDialog extends ConsumerWidget {
  const PrestigeConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prestigeState = ref.watch(prestigeControllerProvider);
    final nextMultiplier = 1.0 + ((prestigeState.prestigeLevel + 1) * 0.1);

    return AlertDialog(
      title: const Text('Prestige Reset'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to Prestige? This will reset:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Money & Current HP'),
          const Text('• All Shop Upgrades'),
          const Text('• Current World Progress'),
          const SizedBox(height: 16),
          const Text(
            'You will gain:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text('• Permanent Multiplier: ${nextMultiplier.toStringAsFixed(1)}x'),
          const Text('• 1 Prestige Badge'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await ref.read(prestigeControllerProvider.notifier).performReset();
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress Reset! Prestige Gained!'),
                ),
              );
            }
          },
          child: const Text('Prestige Now!'),
        ),
      ],
    );
  }
}
