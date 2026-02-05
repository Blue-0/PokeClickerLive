import 'package:flutter/material.dart';
import '../utils/password_strength.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final strength = PasswordStrengthCalculator.calculate(password);
    final color = PasswordStrengthCalculator.getColor(strength);
    final label = PasswordStrengthCalculator.getLabel(strength);
    final progress = PasswordStrengthCalculator.getProgress(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _getHint(strength),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _getHint(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Ajoutez des majuscules, chiffres et symboles';
      case PasswordStrength.medium:
        return 'Bon début! Ajoutez plus de caractères';
      case PasswordStrength.strong:
        return 'Très bien! Mot de passe sécurisé';
      case PasswordStrength.veryStrong:
        return 'Excellent! Mot de passe très sécurisé';
    }
  }
}
