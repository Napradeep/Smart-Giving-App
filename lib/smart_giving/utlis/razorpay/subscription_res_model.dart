class SubscriptionResponse {
  final String id;
  final String? entity;
  final String? planId;
  final String? status;
  final int? currentStart;
  final int? currentEnd;
  final int? endedAt;
  final int? quantity;
  final int? chargeAt;
  final int? startAt;
  final int? endAt;
  final int? authAttempts;
  final int? totalCount;
  final int? paidCount;
  final bool? customerNotify;
  final int? createdAt;
  final int? expireBy;
  final String? shortUrl;
  final bool? hasScheduledChanges;
  final int? changeScheduledAt;
  final String? source;
  final String? offerId;
  final int? remainingCount;

  SubscriptionResponse({
    required this.id,
    required this.entity,
    required this.planId,
    required this.status,
    this.currentStart,
    this.currentEnd,
    this.endedAt,
    required this.quantity,
    required this.chargeAt,
    required this.startAt,
    required this.endAt,
    required this.authAttempts,
    required this.totalCount,
    required this.paidCount,
    required this.customerNotify,
    required this.createdAt,
    required this.expireBy,
    required this.shortUrl,
    required this.hasScheduledChanges,
    this.changeScheduledAt,
    required this.source,
    this.offerId,
    required this.remainingCount,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      id: json['id'],
      entity: json['entity'],
      planId: json['plan_id'],
      status: json['status'],
      currentStart: json['current_start'],
      currentEnd: json['current_end'],
      endedAt: json['ended_at'],
      quantity: json['quantity'],
      chargeAt: json['charge_at'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      authAttempts: json['auth_attempts'],
      totalCount: json['total_count'],
      paidCount: json['paid_count'],
      customerNotify: json['customer_notify'],
      createdAt: json['created_at'],
      expireBy: json['expire_by'],
      shortUrl: json['short_url'],
      hasScheduledChanges: json['has_scheduled_changes'],
      changeScheduledAt: json['change_scheduled_at'],
      source: json['source'],
      offerId: json['offer_id'],
      remainingCount: json['remaining_count'],
    );
  }
}



class SubscriptionErrorResponse {
  final String? code;
  final String? description;
  final String? source;
  final String? step;
  final String? reason;
  final Map<String, dynamic>? metadata;

  SubscriptionErrorResponse({
     this.code,
     this.description,
     this.source,
     this.step,
     this.reason,
     this.metadata,
  });

  factory SubscriptionErrorResponse.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    return SubscriptionErrorResponse(
      code: error['code'],
      description: error['description'],
      source: error['source'],
      step: error['step'],
      reason: error['reason'],
      metadata: error['metadata'],
    );
  }
}
