import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/payment_model.dart';
import '../services/database_service.dart';
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

  Stream<List<PaymentModel>> streamSources() {
    if (_currentUser != null) {
      final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
        path: ApiPath.stripeSources(userId: _currentUser.uid),
      );
      return res.map(
        (list) {
          final List<PaymentModel> sources = list.documents
              .map(
                (doc) => PaymentModel.fromFirestore(doc.data, doc.documentID),
              )
              .toList();

          return sources;
        },
      );
    }
    return null;
  }

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
