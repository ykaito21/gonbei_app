// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../models/payment_info.dart';
// import '../services/api_path.dart';
// import '../services/db_service.dart';
// import '../services/payment_service.dart';
// import 'base_provider.dart';

// class PaymentProvider extends BaseProvider {
//   FirebaseUser _currentUser;
//   DbService _dbService = DbService();
//   PaymentService _paymentService = PaymentService();

//   set currentUser(FirebaseUser value) {
//     if (_currentUser != value) {
//       _currentUser = value;
//     }
//   }

// //* Square Payment
//   // Future<void> paymentStart() async {
//   //   await _paymentService.onStartCardEntryFlow();
//   // }

// //* Stripe Payment

//   //* for addStripePaymentMehtod onCall function
//   Future<bool> addCardToStripe() async {
//     try {
//       setViewState(ViewState.Busy);
//       final res = await _paymentService.addPaymentMethod();
//       setViewState(ViewState.Retrieved);
//       return res;
//     } catch (e) {
//       //? need to implement error state?
//       setViewState(ViewState.Error);
//       print(e);
//       rethrow;
//     }
//   }

//   //* for addStripePaymentSource function
//   // Future<void> addCardToStripe() async {
//   //   try {
//   //     final String paymentMethodId = await _paymentService.addPaymentMethod();
//   //     _dbService.createDocument(
//   //         path: ApiPath.stripePaymentMethod(
//   //             userId: _currentUser.uid, paymentMethodId: paymentMethodId));
//   //   } catch (e) {
//   //     print(e);
//   //     rethrow;
//   //   }
//   // }

//   Stream<List<PaymentInfo>> streamSources() {
//     if (_currentUser != null) {
//       final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
//         path: ApiPath.stripeSources(userId: _currentUser.uid),
//       );
//       return res.map(
//         (list) {
//           final List<PaymentInfo> sources = list.documents
//               .map(
//                 (doc) => PaymentInfo.fromFirestore(doc.data, doc.documentID),
//               )
//               .toList();

//           return sources;
//         },
//       );
//     }
//     return null;
//   }

//   // check current user added card or not
//   //TODO maybe need to support multiple cards and delete card
//   Future<bool> checkPaymentMethod() async {
//     try {
//       if (_currentUser != null) {
//         final DocumentSnapshot res = await _dbService.getDocumentById(
//           path: ApiPath.stripeInfo(userId: _currentUser.uid),
//         );

//         if (res?.data['paymentMethodId'] != null) {
//           return true;
//         } else {
//           return false;
//         }
//       }
//       return false;
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }
// }
