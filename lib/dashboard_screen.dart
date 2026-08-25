import 'package:flutter/material.dart';
import 'models.dart';

class DashboardScreen extends StatelessWidget {
  final List<FitnessEntry> entries;

  const DashboardScreen({super.key, required this.entries});

  double _sumToday(ActivityType type) {
    final now = DateTime.now();
    return entries
        .where(
          (e) =>
              e.type == type &&
              e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day,
        )
        .fold(0.0, (total, e) => total + e.value);
  }

  @override
  Widget build(BuildContext context) {
    final steps = _sumToday(ActivityType.steps);
    final workout = _sumToday(ActivityType.workout);
    final calories = _sumToday(ActivityType.calories);

    final stepsProgress = (steps / 8000).clamp(0.0, 1.0);
    final workoutProgress = (workout / 30).clamp(0.0, 1.0);
    final caloriesProgress = (calories / 500).clamp(0.0, 1.0);

    final overallPercent =
        ((stepsProgress + workoutProgress + caloriesProgress) / 3 * 100)
            .round();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Today's Progress",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildOverallCard(context, overallPercent),
        const SizedBox(height: 20),
        _buildCard(
          context,
          Icons.directions_walk,
          "Steps",
          steps,
          8000,
          "steps",
        ),
        _buildCard(
          context,
          Icons.fitness_center,
          "Workout",
          workout,
          30,
          "min",
        ),
        _buildCard(
          context,
          Icons.local_fire_department,
          "Calories Burned",
          calories,
          500,
          "kcal",
        ),
      ],
    );
  }

  Widget _buildOverallCard(BuildContext context, int percent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            "$percent%",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "of daily goals completed",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    IconData icon,
    String label,
    double value,
    double goal,
    String unit,
  ) {
    final progress = (value / goal).clamp(0.0, 1.0);
    const accent = Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withOpacity(0.15),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "${value.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} $unit",
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: accent.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }
}
