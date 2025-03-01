class OrderRequest {
  final int amountInPaisa;
  final String currency;

  OrderRequest({
    required this.amountInPaisa,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amountInPaisa,
      'currency': currency,
    };
  }
}
