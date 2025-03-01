import 'dart:developer';

class OrderResponse {
  final String id;
  final String? entity;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String? receipt;
  final String? offerId;
  final String status;
  final int attempts;
  final List<dynamic> notes;
  final int createdAt;

  OrderResponse({
    required this.id,
     this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
     this.receipt,
    this.offerId,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.createdAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    log("Order $json");
    return OrderResponse(
      id: json['id'],
      entity: json['entity'],
      amount: json['amount'],
      amountPaid: json['amount_paid'],
      amountDue: json['amount_due'],
      currency: json['currency'],
      receipt: json['receipt'],
      offerId: json['offer_id'],
      status: json['status'],
      attempts: json['attempts'],
      notes: json['notes'],
      createdAt: json['created_at'],
    );
  }
}

class OrderErrorResponse {
  final String? code;
  final String? description;
  final String? source;
  final String? step;
  final String? reason;
  final Map<String, dynamic>? metadata;
  final String? field;

  OrderErrorResponse({
     this.code,
     this.description,
     this.source,
     this.step,
     this.reason,
     this.metadata,
     this.field,
  });

  factory OrderErrorResponse.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    return OrderErrorResponse(
      code: error['code'],
      description: error['description'],
      source: error['source'],
      step: error['step'],
      reason: error['reason'],
      metadata: error['metadata'],
      field: error['field'],
    );
  }
}
