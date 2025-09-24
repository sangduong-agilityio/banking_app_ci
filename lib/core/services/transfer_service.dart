import 'package:supabase_flutter/supabase_flutter.dart';

class TransferService {
  final SupabaseClient _client;

  TransferService(this._client);

  /// Send OTP via Email
  Future<void> sendOtpEmail(String transferId, String email) async {
    await _client.from('transfer_otps').insert({
      'transfer_id': transferId,
      'email': email,
      'otp_code': _generateOtp(),
      'expires_at': DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
      'sent_method': 'email',
    });
  }

  /// Verify OTP
  Future<bool> verifyOtp(String transferId, String otpCode) async {
    final result = await _client
        .from('transfer_otps')
        .select()
        .eq('transfer_id', transferId)
        .eq('otp_code', otpCode)
        .single();

    final expiresAt = DateTime.parse(result['expires_at']);
    if (DateTime.now().isAfter(expiresAt)) return false;

    // Update transfer status to completed
    await _client
        .from('transfers')
        .update({'status': 'completed'})
        .eq('id', transferId);

    // Insert transaction record
    await _client.from('transactions').insert({
      'transfer_id': transferId,
      'status': 'completed',
      'reference_number': DateTime.now().millisecondsSinceEpoch.toString(),
      'created_at': DateTime.now().toIso8601String(),
    });

    return true;
  }

  /// Generate 6-digit OTP
  String _generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    return random.toString().padLeft(6, '0');
  }
}
