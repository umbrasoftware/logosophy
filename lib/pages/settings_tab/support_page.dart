import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.feedbackPage.name,
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: t.btnActions.email,
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 8,
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.feedbackPage.message,
                alignLabelWithHint: true,
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  final length = _messageController.text.trim().length;
                  _isMessage = length > 0 && length < 20;
                });
              },
            ),
            if (_isMessage)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 12.0),
                child: Text(t.feedbackPage.typeMore, style: TextStyle(color: colorScheme.error)),
              ),
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
            FilledButton(
              onPressed: (_isMessage || _isSending) ? null : onSubmit,
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14.0)),
              child: _isSending
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(t.btnActions.send),
            ),
          ],
        ),
      ),
    );
  }

  /// Submits the form to database.
  Future<void> onSubmit() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final pubspecInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    allInfo['appVersion'] = '${pubspecInfo.version}+${pubspecInfo.buildNumber}';

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
    if (!mounted) return;
    final color = wasOk ? Colors.green.shade700 : Theme.of(context).colorScheme.error;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: (Text(message)), backgroundColor: color));
    if (wasOk) Navigator.of(context).pop();
  }
}
