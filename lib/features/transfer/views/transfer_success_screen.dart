import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransferSuccessScreen extends StatefulWidget {
  final Transaction transaction;

  const TransferSuccessScreen({super.key, required this.transaction});

  @override
  State<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _slideController;
  late Animation<double> _confettiAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _confettiAnimation = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOutQuart,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.forward();
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey[600]),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),

              // Success animation and icon
              _buildSuccessHeader(),

              SizedBox(height: 40),

              // Transaction details card
              _buildTransactionCard(),

              SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(context),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        // Animated success icon with confetti
        Stack(
          alignment: Alignment.center,
          children: [
            // Confetti effect
            AnimatedBuilder(
              animation: _confettiAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_confettiAnimation.value),
                  size: Size(200, 200),
                );
              },
            ),

            // Success icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green[500],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(Icons.check, color: Colors.white, size: 60),
            ),
          ],
        ),

        SizedBox(height: 32),

        Text(
          "Transfer Successful!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 12),

        Text(
          "You have successfully transferred \$${NumberFormat('#,##0.00').format(widget.transaction.transferRequest.amount)} to ${widget.transaction.transferRequest.toBeneficiary.name}!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTransactionCard() {
    final transaction = widget.transaction;
    final request = transaction.transferRequest;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaction Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Completed",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Transaction ID
          _buildDetailRow("Transaction ID", transaction.id, isCopiable: true),

          _buildDetailRow("From", request.fromAccount.maskedNumber),
          _buildDetailRow("To", request.toBeneficiary.name),
          _buildDetailRow(
            "Account Number",
            request.toBeneficiary.accountNumber,
          ),
          _buildDetailRow("Bank", request.toBeneficiary.bank?.name ?? "N/A"),
          _buildDetailRow(
            "Amount",
            "\$${NumberFormat('#,##0.00').format(request.amount)}",
          ),
          _buildDetailRow(
            "Transaction Fee",
            "\$${NumberFormat('#,##0.00').format(request.transactionFee)}",
          ),
          _buildDetailRow(
            "Total",
            "\$${NumberFormat('#,##0.00').format(request.amount + request.transactionFee)}",
            isTotal: true,
          ),
          _buildDetailRow("Note", request.content),
          _buildDetailRow(
            "Date & Time",
            DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isCopiable = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isTotal ? Colors.black87 : Colors.black87,
                  fontSize: 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (isCopiable) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Transaction ID copied to clipboard"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green[600],
                      ),
                    );
                  },
                  child: Icon(Icons.copy, size: 16, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Share Receipt Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              // Implement share functionality
              _shareReceipt();
            },
            icon: Icon(Icons.share, size: 20),
            label: Text(
              "Share Receipt",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4C4DDC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),

        SizedBox(height: 16),

        // Back to Home Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Back to Home",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _shareReceipt() {
    final transaction = widget.transaction;
    final request = transaction.transferRequest;

    final receiptText =
        '''
🎉 Transfer Successful!

Transaction ID: ${transaction.id}
From: ${request.fromAccount.maskedNumber}
To: ${request.toBeneficiary.name}
Amount: \$${NumberFormat('#,##0.00').format(request.amount)}
Date: ${DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.createdAt)}

Thank you for using our banking app!
''';

    // Implement actual sharing functionality here
    // For example: Share.share(receiptText);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Receipt sharing feature will be implemented"),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = [0.1, 0.3, 0.5, 0.7, 0.9]; // Pseudo-random positions

    for (int i = 0; i < 15; i++) {
      final t = (progress + i * 0.1) % 1.0;
      final x = size.width * random[i % random.length];
      final y = size.height * t;

      paint.color = [
        Colors.yellow,
        Colors.pink,
        Colors.blue,
        Colors.green,
        Colors.orange,
      ][i % 5].withOpacity(1.0 - t);

      canvas.drawCircle(Offset(x, y), 3.0 * (1.0 - t), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
