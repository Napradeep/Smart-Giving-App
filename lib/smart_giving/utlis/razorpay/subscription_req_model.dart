class SubscriptionRequest {
  final String planId;

  SubscriptionRequest.yearly() :  planId ="plan_PNSItuBf1Xoruf";
  SubscriptionRequest.monthly() : planId ="plan_PNSIMpZSPwgVS1";

  Map<String, dynamic> toJson() {
    return {
      "plan_id": planId,
      "total_count": 99,
      "quantity": 1,
      "customer_notify": 1,
      
    };
  }
}
