import 'package:firebase_auth/firebase_auth.dart';
import 'package:gonbei_app/src/core/services/database_service.dart';

import '../services/api_path.dart';
import '../services/payment_service.dart';
import 'base_provider.dart';

class PaymentProvider extends BaseProvider {
  FirebaseUser _currentUser;
  final _dbService = DatabaseService.instance;
  final _paymentService = PaymentService.instance;

  set currentUser(FirebaseUser value) {
    if (_currentUser != value) {
      _currentUser = value;
    }
  }

  //* for addStripePaymentMehtod onCall function
  Future<bool> addCardToStripe() async {
    try {
      setViewState(ViewState.Busy);
      final res = await _paymentService.addPaymentMethod();
      setViewState(ViewState.Retrieved);
      return res;
    } catch (e) {
      setViewState(ViewState.Error);
      print(e);
      rethrow;
    }
  }

  //* for addStripePaymentSource function
  // Future<void> addCardToStripe() async {
  //   try {
  //     final String paymentMethodId = await _paymentService.addPaymentMethod();
  //     _dbService.createDocument(
  //         path: ApiPath.stripePaymentMethod(
  //             userId: _currentUser.uid, paymentMethodId: paymentMethodId));
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Stream<List<PaymentInfo>> streamSources() {
  //   if (_currentUser != null) {
  //     final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
  //       path: ApiPath.stripeSources(userId: _currentUser.uid),
  //     );
  //     return res.map(
  //       (list) {
  //         final List<PaymentInfo> sources = list.documents
  //             .map(
  //               (doc) => PaymentInfo.fromFirestore(doc.data, doc.documentID),
  //             )
  //             .toList();

  //         return sources;
  //       },
  //     );
  //   }
  //   return null;
  // }

  // check current user added card or not
  //TODO maybe need to support multiple cards and delete card
  Future<bool> checkPaymentMethod() async {
    try {
      if (_currentUser != null) {
        final res = await _dbService.getDocumentById(
          path: ApiPath.stripeInfo(userId: _currentUser.uid),
        );

        if (res?.data['paymentMethodId'] != null) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
