import 'package:flutter/material.dart';
import 'models.dart';

class LogScreen extends StatelessWidget {
  final List<FitnessEntry> entries;
  final void Function(FitnessEntry) onAdd;

  const LogScreen({super.key, required this.entries, required this.onAdd});

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddEntrySheet(onAdd: onAdd),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add),
        label: const Text("Log Activity"),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("No activity logged yet."))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final e = entries[i];
                return ListTile(
                  title: Text(
                    "${e.type.label}: ${e.value.toStringAsFixed(0)} ${e.type.unit}",
                  ),
                  subtitle: Text(e.date.toString()),
                );
              },
            ),
    );
  }
}

class _AddEntrySheet extends StatefulWidget {
  final void Function(FitnessEntry) onAdd;
  const _AddEntrySheet({required this.onAdd});

  @override
  State<_AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<_AddEntrySheet> {
  ActivityType _type = ActivityType.steps;
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<ActivityType>(
            value: _type,
            items: ActivityType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          TextField(
            controller: _valueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(_valueController.text);
              if (value == null) return;
              widget.onAdd(
                FitnessEntry(type: _type, value: value, date: DateTime.now()),
              );
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
