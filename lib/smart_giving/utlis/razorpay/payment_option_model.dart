


import 'package:clone/smart_giving/utlis/razorpay/razorpay_utils.dart';

class RazorPayOptions {
  static const String key = razorPayKeyId;
  final int amountInPaisa; 
  final String name;
  final String orderId;
  final String? subscriptionId;
  final String description;
  final Prefill prefill;
  final Map<String, bool>? method; 

  RazorPayOptions({
    required this.amountInPaisa,
    required this.name,
    required this.orderId,
    this.subscriptionId, 
    required this.description,
    required this.prefill,
    this.method, 
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'amount': amountInPaisa,
      'name': name,
      'order_id': orderId,
      if (subscriptionId != null) 'subscription_id': subscriptionId, 
      'description': description,
      'timeout': 10 * 60,
      'prefill': prefill.toJson(),
      if (method != null) 'method': method, 
    };
  }
}


class Prefill {
  final String contact;
  final String email;

  Prefill({
    required this.contact,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': contact,
      'email': email,
    };
  }
}
