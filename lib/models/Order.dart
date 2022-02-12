import 'package:ab3ad/models/Item.dart';
import 'package:ab3ad/models/User.dart';

class Order {
  final int id, categoryId, quantity, status;
  final String delivaryTime, notes, customerLat, customerLng;
  final Item item;
  final User user;

  Order(
      {required this.id,
      required this.user,
      required this.categoryId,
      required this.quantity,
      required this.status,
      required this.item,
      required this.delivaryTime,
      required this.notes,
      required this.customerLat,
      required this.customerLng});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json["id"],
        user: User.fromJson(json["user"]),
        categoryId: json["categoryId"],
        quantity: json["quantity"],
        status: json["status"],
        item: Item.fromJson(json['item']),
        delivaryTime: json["delivary_time"],
        notes: json["notes"],
        customerLat: json["customerLat"].toString(),
        customerLng: json["customerLng"].toString());
  }
}
