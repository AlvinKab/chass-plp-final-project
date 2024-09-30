class RawMaterial {
  final int id;
  final String material;
  final double quantityInTonnes;
  final double pricePerTon;
  final double totalPrice;
  final double paidAmount;
  final double amountOwed;

  RawMaterial({
    required this.id,
    required this.material,
    required this.quantityInTonnes,
    required this.pricePerTon,
    required this.totalPrice,
    required this.paidAmount,
    required this.amountOwed,
  });

  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      id: json['id'],
      material: json['material'],
      quantityInTonnes: json['quantity_in_tonnes'].toDouble(),
      pricePerTon: json['price_per_ton'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
      paidAmount: json['paid_amount'].toDouble(),
      amountOwed: json['amount_owed'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material': material,
      'quantity_in_tonnes': quantityInTonnes,
      'price_per_ton': pricePerTon,
      'total_price': totalPrice,
      'paid_amount': paidAmount,
      'amount_owed': amountOwed,
    };
  }
}
