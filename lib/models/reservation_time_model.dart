class ReservationTimeModel {
  late final String startAt;
  late final String endAt;
  late final String holes;
  late final num price;
  String? id;
  ReservationTimeModel(
      {required this.endAt,
      required this.holes,
      required this.startAt,
      required this.price});

  ReservationTimeModel.fromMap(Map<String, dynamic> map, this.id) {
    startAt = map['startAt'];
    endAt = map['endAt'];
    holes = map['holes'];
    price = map['price'];
  }

  Map<String, dynamic> toMap() {
    return {'startAt': startAt, 'endAt': endAt, 'holes': holes, 'price': price};
  }
}
