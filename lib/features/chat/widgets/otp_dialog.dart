import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPDialog extends StatefulWidget {
  final Future<String> Function() requestOTP;
  final Future<bool> Function(String) verifyOTP;
  final double amount;
  final String recipient;

  const OTPDialog({
    Key? key,
    required this.requestOTP,
    required this.verifyOTP,
    required this.amount,
    required this.recipient,
  }) : super(key: key);

  @override
  State<OTPDialog> createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  int _remainingAttempts = 3;

  @override
  void initState() {
    super.initState();
    _requestOTP();
  }

  Future<void> _requestOTP() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.requestOTP();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to send OTP. Please try again.';
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _error = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final isValid = await widget.verifyOTP(_otpController.text);
      if (isValid) {
        Navigator.of(context).pop(true);
      } else {
        _remainingAttempts--;
        setState(() {
          _isLoading = false;
          _error = 'Invalid OTP. $_remainingAttempts attempts remaining.';
          _otpController.clear();
        });

        if (_remainingAttempts <= 0) {
          Navigator.of(context).pop(false);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Verification failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Verify Transfer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount: \$${widget.amount.toStringAsFixed(2)}\nTo: ${widget.recipient}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Enter the 6-digit code sent to your phone:',
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _otpController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '000000',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (_) => setState(() => _error = null),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _isLoading ? null : _requestOTP,
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyOTP,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Verify'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}