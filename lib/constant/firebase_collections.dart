import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static const String USER_COLLECTIONS = 'users';
  static const String SHOP_COLLECTIONS = 'shops';
  static const String WORK_GALLERY = 'workGallery';
  static const String SHOP_CATEGORY = 'category';
  static const String MASSAGE_TYPES = 'types';
  static const String SHOP_VIEWS = 'views';
  static const String BOOKINGS = 'Bookings';
  static const String recomendations = 'recomendations';
  static const String MESSAGECOLLECTION = 'messages';
  static const String NOTIFICATION_COLLECIONS = 'notifications';
  static const String REVIEW_COLLECTION = 'reviews';
  static const String BOOKMARK_COLLECTION = 'bookmarks';
  static const String POINT_COLLECTION = 'points';
  static var bookingRef = FirebaseFirestore.instance.collection(BOOKINGS);
  static var shopRef = FirebaseFirestore.instance.collection(SHOP_COLLECTIONS);
  static const String paymentRequest = 'paymentRequest';
  static const String bookingPayment = 'bookingPayments';
  static const String customTime = 'customTime';
}
