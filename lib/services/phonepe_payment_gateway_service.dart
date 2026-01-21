import 'dart:convert';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:flutter/material.dart';

class PhonePeService {
  // Configuration
  static const String environment = 'SANDBOX'; // Change to 'PRODUCTION' for live
  static const String merchantId = 'M23BZ7J8ECCFG_2511101048'; // Your merchant ID
  static const bool enableLogging = true;

  // For generating flowId (recommended: use user-specific info or UUID)
  String generateFlowId() {
    return 'FLOW_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Initialize PhonePe SDK
  Future<bool> initializeSDK() async {
    try {
      final flowId = generateFlowId();
      print('Initializing PhonePe SDK...');
      print('Environment: $environment');
      print('Merchant ID: $merchantId');
      print('Flow ID: $flowId');

      final isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowId,
        enableLogging,
      );

      print('PhonePe SDK Initialization Result: $isInitialized');
      return isInitialized;
    } catch (e) {
      print('PhonePe SDK Initialization Error: $e');
      return false;
    }
  }

  /// Start PhonePe Transaction
  Future<Map<String, dynamic>> startTransaction({
    required String orderId,
    required String token,
    required String appSchema, // For iOS only
  }) async {
    try {
      // Construct the payload as per PhonePe documentation
      final payload = {
        "orderId": orderId,
        "merchantId": merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"}
      };

      final request = jsonEncode(payload);
      print('Payment Request Payload: $request');

      // Start the transaction
      final response = await PhonePePaymentSdk.startTransaction(
        request,
        appSchema, // For iOS, empty string for Android
      );

      print('PhonePe Transaction Response: $response');

      if (response != null) {
        return {
          'status': response['status']?.toString() ?? 'UNKNOWN',
          'error': response['error']?.toString() ?? '',
          'rawResponse': response,
        };
      } else {
        return {
          'status': 'FAILURE',
          'error': 'No response from PhonePe',
        };
      }
    } catch (e) {
      print('PhonePe Transaction Error: $e');
      return {
        'status': 'FAILURE',
        'error': e.toString(),
      };
    }
  }

  /// Handle payment response
  void handlePaymentResponse(
      Map<String, dynamic> response,
      BuildContext context,
      Function(bool) onPaymentComplete,
      ) {
    final status = response['status'];
    final error = response['error'];

    print('Payment Status: $status');
    print('Payment Error: $error');

    switch (status) {
      case 'SUCCESS':
        print('Payment Successful!');
        onPaymentComplete(true);
        break;

      case 'FAILURE':
        print('Payment Failed: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
        onPaymentComplete(false);
        break;

      case 'INTERRUPTED':
        print('Payment Interrupted: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment was interrupted'),
            backgroundColor: Colors.orange,
          ),
        );
        onPaymentComplete(false);
        break;

      default:
        print('Unknown Payment Status: $status');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown payment status'),
            backgroundColor: Colors.orange,
          ),
        );
        onPaymentComplete(false);
    }
  }
}