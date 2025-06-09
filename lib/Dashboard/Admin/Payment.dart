import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay razorpay;
  TextEditingController _amountController = TextEditingController();
  String _paymentType = 'card'; // default method

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void openCheckout() {
    int amount = int.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_Ys1nk5c7y3p0ZD', // Replace with test key
      'amount': amount * 100, // convert to paise
      'name': 'Daimora',
      'description': 'Purchase',
      'prefill': {
        'contact': '7283962317',
        'email': 'aasheetagajera03@gmail.com',
      },
      'method': {
        'card': _paymentType == 'card',
        'upi': _paymentType == 'upi',
        'wallet': _paymentType == 'wallet',
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("✅ Payment successful: ${response.paymentId}");
    // Optionally: Send to backend for verification
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Payment failed: ${response.message}");
  }

  @override
  void dispose() {
    razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daimora Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter amount (₹)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _paymentType,
              onChanged: (value) {
                setState(() {
                  _paymentType = value!;
                });
              },
              items: [
                DropdownMenuItem(value: 'card', child: Text("Card")),
                DropdownMenuItem(value: 'upi', child: Text("UPI")),
                DropdownMenuItem(value: 'wallet', child: Text("Wallet")),
              ],
              decoration: InputDecoration(
                labelText: "Payment Method",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: openCheckout,
              icon: Icon(Icons.payment),
              label: Text("Pay Now"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
