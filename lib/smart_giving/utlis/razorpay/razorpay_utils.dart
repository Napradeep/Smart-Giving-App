import 'dart:convert';
import 'dart:developer';

import 'package:clone/smart_giving/utlis/razorpay/order_req_model.dart';
import 'package:clone/smart_giving/utlis/razorpay/order_res_model.dart';
import 'package:clone/smart_giving/utlis/razorpay/subscription_req_model.dart';
import 'package:clone/smart_giving/utlis/razorpay/subscription_res_model.dart';
import 'package:dio/dio.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

const razorPayKeyId = "rzp_test_IEX5XUvVeODm15";
//'rzp_live_zldtavf5nKnRgs'; //live

const razorPayKeyScrete = "oyCMuj4sYJ4qJYQNLDRp3FOf";
// 'oE2Ty5g0IrLhvy2tm4y4S2ym';//live

class RazorPayUtils {
  final _razorpay = Razorpay();

  Razorpay get razorpay => _razorpay;

  onSuccess(Function? handler) async* {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      _handlePaymentSuccess(response);
      handler?.call(response);
    });
  }

  onError(Function? handler) async* {
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      _handlePaymentError(response);
      handler?.call(response);
    log("Payment failed: ${response.code} - ${response.message}");
    });
  }

  onExternalWallet(Function handler) async* {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      ExternalWalletResponse response,
    ) {
      _handleExternalWallet(response);
      handler(response);
    });
  }

  Future<OrderResponse> createOrder(OrderRequest request) async {
    try {
      final dio = Dio();

      dio.options.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode('$razorPayKeyId:$razorPayKeyScrete'))}';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        'https://api.razorpay.com/v1/orders',
        data: request.toJson(),
      );
      log('Order Created: ${response.data}');

      final orderResponse = OrderResponse.fromJson(response.data);
      log('Order Created: ${orderResponse.id}');
      return orderResponse;
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorResponse = OrderErrorResponse.fromJson(e.response!.data);
        log('Error: ${e.response!.data}');
        throw ('Error: ${errorResponse.description}');
      } else {
        log('Unexpected Error: $e');
        throw ('Unexpected Error: $e');
      }
    }
  }

  Future<SubscriptionResponse> createSubscription(
    SubscriptionRequest request,
  ) async {
    try {
      final dio = Dio();

      dio.options.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode('$razorPayKeyId:$razorPayKeyScrete'))}';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        'https://api.razorpay.com/v1/subscriptions',
        data: request.toJson(),
      );
      log('Subscription Created: ${response.data}');

      final subscriptionResponse = SubscriptionResponse.fromJson(response.data);
      log('Subscription Created: ${subscriptionResponse.id}');
      return subscriptionResponse;
    } catch (e) {
      if (e is DioException && e.response != null) {
        log('Error: ${e.response!.data}');

        final errorResponse = SubscriptionErrorResponse.fromJson(
          e.response!.data,
        );
        log('Error: ${errorResponse.description}');
        throw "Error: ${errorResponse.description}";
      }
      log('Unexpected Error: $e');
      rethrow;
    }
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  log("_handlePaymentSuccess : $response");
}

void _handlePaymentError(PaymentFailureResponse response) {
  log("_handlePaymentError : $response");
  print("Payment failed: ${response.code} - ${response.message}");
  log('hii');
}

void _handleExternalWallet(ExternalWalletResponse response) {
  log("_handleExternalWallet : $response");
}
