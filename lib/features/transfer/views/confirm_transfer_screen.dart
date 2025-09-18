import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:banking_app/features/transfer/views/transfer_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_bloc.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';

class ConfirmTransferScreen extends StatefulWidget {
  const ConfirmTransferScreen({super.key});

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;
  String _verificationType = 'initial';

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state.transaction != null) {
            _navigateToSuccess(context, state.transaction!);
          } else if (state.status == const TransferStatus.failure()) {
            _showErrorSnackBar(
              context,
              state.errorMessage ?? 'Transfer failed',
            );
          }
        },
        builder: (context, state) {
          if (state.status == const TransferStatus.loading()) {
            return _buildProcessingState();
          }

          return SlideTransition(
            position: _slideAnimation,
            child: _buildConfirmationView(state),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Confirm Transfer",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF4C4DDC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C4DDC)),
                strokeWidth: 4,
              ),
            ),
          ),
          SizedBox(height: 32),
          Text(
            "Processing your transfer...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "This may take a few moments",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationView(TransferState state) {
    if (state.selectedAccount == null ||
        state.selectedBeneficiary == null ||
        state.amount == null) {
      return _buildErrorState("Missing transfer details");
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transfer summary card
          _buildTransferSummaryCard(state),
          SizedBox(height: 32),

          // Verification section
          _buildVerificationSection(),

          SizedBox(height: 32),

          // Confirm button
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Go Back"),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferSummaryCard(TransferState state) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C4DDC), Color(0xFF6B73FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4C4DDC).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transfer Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                "\${NumberFormat('#,##0.00').format(state.amount!)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Divider(color: Colors.white30),
          SizedBox(height: 16),

          // Transfer details
          _buildSummaryRow("From", state.selectedAccount!.maskedNumber),
          _buildSummaryRow("To", state.selectedBeneficiary!.name),
          _buildSummaryRow(
            "Bank",
            state.selectedBeneficiary!.bank?.name ?? "N/A",
          ),
          _buildSummaryRow("Account", state.selectedBeneficiary!.accountNumber),
          _buildSummaryRow(
            "Fee",
            "\${NumberFormat('#,##0.00').format(state.transactionFee)}",
          ),
          _buildSummaryRow("Note", state.content ?? ""),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    switch (_verificationType) {
      case 'otp':
        return _buildOTPSection();
      case 'biometric':
        return _buildBiometricSection();
      case 'faceId':
        return _buildFaceIDSection();
      default:
        return _buildInitialVerificationSection();
    }
  }

  Widget _buildInitialVerificationSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Color(0xFF4C4DDC), size: 24),
              SizedBox(width: 12),
              Text(
                "Secure Verification Required",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "To complete this transfer, please choose your verification method:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 20),

          // Verification options
          _buildVerificationOption(
            icon: Icons.sms,
            title: "SMS OTP",
            subtitle: "Get verification code via SMS",
            onTap: () {
              setState(() {
                _verificationType = 'otp';
              });
            },
          ),
          SizedBox(height: 12),
          _buildVerificationOption(
            icon: Icons.fingerprint,
            title: "Touch ID",
            subtitle: "Use your fingerprint",
            onTap: () {
              setState(() {
                _verificationType = 'biometric';
              });
              _pulseController.repeat(reverse: true);
              context.read<TransferBloc>().add(AuthenticateWithBiometricsEvt());
            },
          ),
          SizedBox(height: 12),
          _buildVerificationOption(
            icon: Icons.face,
            title: "Face ID",
            subtitle: "Use face recognition",
            onTap: () {
              setState(() {
                _verificationType = 'faceId';
              });
              context.read<TransferBloc>().add(AuthenticateWithFaceIdEvt());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF4C4DDC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Color(0xFF4C4DDC), size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sms, color: Colors.blue[600], size: 24),
              SizedBox(width: 12),
              Text(
                "Enter OTP Code",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "We've sent a verification code to your registered mobile number",
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 20),

          // OTP Input
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              hintText: "000000",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.length == 6) {
                setState(() {
                  _isVerifying = true;
                });
                context.read<TransferBloc>().add(VerifyOTPEvt(value));
              }
            },
          ),

          SizedBox(height: 16),

          // Alternative methods
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _verificationType = 'biometric';
                  });
                  _pulseController.repeat(reverse: true);
                  context.read<TransferBloc>().add(
                    AuthenticateWithBiometricsEvt(),
                  );
                },
                icon: Icon(Icons.fingerprint, size: 18),
                label: Text("Use Touch ID"),
                style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _verificationType = 'faceId';
                  });
                  context.read<TransferBloc>().add(AuthenticateWithFaceIdEvt());
                },
                icon: Icon(Icons.face, size: 18),
                label: Text("Use Face ID"),
                style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSection() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.purple[300]!, width: 2),
              ),
              child: Icon(
                Icons.fingerprint,
                size: 48,
                color: Colors.purple[600],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Touch ID Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Place your finger on the Touch ID sensor",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.purple[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _pulseController.stop();
                  setState(() {
                    _verificationType = 'initial';
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 24),
              TextButton(
                onPressed: () {
                  _pulseController.stop();
                  setState(() {
                    _verificationType = 'otp';
                  });
                },
                child: Text(
                  "Use OTP instead",
                  style: TextStyle(color: Colors.purple[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaceIDSection() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.green[300]!, width: 2),
            ),
            child: Icon(Icons.face, size: 48, color: Colors.green[600]),
          ),
          SizedBox(height: 24),
          Text(
            "Face ID Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Look at the front camera to verify",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _verificationType = 'initial';
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 24),
              TextButton(
                onPressed: () {
                  setState(() {
                    _verificationType = 'otp';
                  });
                },
                child: Text(
                  "Use OTP instead",
                  style: TextStyle(color: Colors.green[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    bool canConfirm =
        _verificationType == 'initial' ||
        (_verificationType == 'otp' && _otpController.text.length == 6);

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: canConfirm
            ? [
                BoxShadow(
                  color: Color(0xFF4C4DDC).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: canConfirm ? _handleConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4C4DDC),
          disabledBackgroundColor: Colors.grey[300],
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (canConfirm && !_isVerifying) ...[
              Icon(Icons.security, size: 18),
              SizedBox(width: 8),
            ],
            if (_isVerifying) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8),
            ],
            Text(
              _isVerifying ? "Verifying..." : "Confirm Transfer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirm() {
    if (_verificationType == 'initial') {
      // Show verification options first
      setState(() {
        _verificationType = 'otp';
      });
    } else if (_verificationType == 'otp' && _otpController.text.length == 6) {
      setState(() {
        _isVerifying = true;
      });
      context.read<TransferBloc>().add(VerifyOTPEvt(_otpController.text));
    }
    HapticFeedback.mediumImpact();
  }

  void _navigateToSuccess(BuildContext context, Transaction transaction) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TransferSuccessScreen(transaction: transaction),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    setState(() {
      _isVerifying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
