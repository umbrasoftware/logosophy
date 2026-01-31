import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/main.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isProblem = false;
  bool _canContact = true;
  bool _isMessage = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(t.feedbackPage.contactUs)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(border: const OutlineInputBorder(), labelText: t.feedbackPage.name),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(border: const OutlineInputBorder(), labelText: t.btnActions.email),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 8,
              controller: _messageController,
              decoration: InputDecoration(border: const OutlineInputBorder(), labelText: t.feedbackPage.message),
              onChanged: (value) {
                setState(() {
                  final length = _messageController.text.trim().length;
                  _isMessage = length > 0 && length < 20;
                });
              },
            ),
            _isMessage ? Text(t.feedbackPage.typeMore, style: TextStyle(color: Colors.red)) : SizedBox.shrink(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(t.feedbackPage.isProblem),
                Switch(
                  value: _isProblem,
                  onChanged: (value) => setState(() {
                    _isProblem = value;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(t.feedbackPage.canContact),
                Switch(
                  value: _canContact,
                  onChanged: (value) => setState(() {
                    _canContact = value;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isMessage ? null : onSubmit,
              style: ElevatedButton.styleFrom(backgroundColor: colorScheme.surfaceContainer),
              child: _isSending ? CircularProgressIndicator() : Text(t.btnActions.send),
            ),
          ],
        ),
      ),
    );
  }

  /// Submits the form to database.
  Future<void> onSubmit() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;

    setState(() {
      _isSending = true;
    });

    final id = await supabase.client
        .from('feedback')
        .insert({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "message": _messageController.text.trim(),
          "is_problem": _isProblem,
          "can_contact": _canContact,
          "device_info": allInfo.toString(),
        })
        .select('id')
        .maybeSingle();

    setState(() {
      _isSending = false;
    });

    final wasOk = id != null && id["id"] as int > 0;
    final message = wasOk ? t.feedbackPage.okMessage : t.feedbackPage.errorMessage;
    final color = wasOk ? Colors.green : Colors.red;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text(message)), backgroundColor: color));
    if (wasOk) Navigator.of(context).pop();
  }
}
