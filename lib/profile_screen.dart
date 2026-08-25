import 'package:flutter/material.dart';
import 'models.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile? profile;
  final void Function(UserProfile) onSave;

  const ProfileScreen({super.key, required this.profile, required this.onSave});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _dob = widget.profile?.dob;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  void _save() {
    widget.onSave(UserProfile(name: _nameController.text, dob: _dob));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile saved")));
  }

  @override
  Widget build(BuildContext context) {
    final age = _dob != null ? UserProfile(name: '', dob: _dob).age : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your name",
              ),
            ),
            const SizedBox(height: 24),
            const Text("Date of Birth"),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickDate,
              child: Text(
                _dob == null
                    ? "Select date"
                    : "${_dob!.day}/${_dob!.month}/${_dob!.year}"
                          "${age != null ? '  •  Age: $age' : ''}",
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _save, child: const Text("Save Profile")),
          ],
        ),
      ),
    );
  }
}
