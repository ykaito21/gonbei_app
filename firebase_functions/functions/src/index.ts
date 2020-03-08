import * as functions from "firebase-functions";
import { firestore, stripe } from "./config";
import { assertAuth, assertData, getStripeDoc } from "./helpers";

exports.createStripeCustomer = functions.firestore
  .document("users/{userId}")
  .onCreate(async (_, context) => {
    try {
      console.log("RUN: create stripe customer");
      const userId = context.params.userId;
      // create stripe customer
      const customer = await stripe.customers.create({
        metadata: {
          firebaseUID: userId
        }
      });
      const customerId = customer.id;
      const customerData = { customerId };
      // create stripe customer document
      await firestore.doc(`stripe/${userId}`).set(customerData);
      console.log("SUCCESS: create stripe customer");
      return;
    } catch (error) {
      console.log("ERROR: create stripe customer");
      console.log(error);
      throw new functions.https.HttpsError(
        error,
        "ERROR: create stripe customer"
      );
    }
  });

exports.addStripePaymentMehtod = functions.https.onCall(
  async (data, context) => {
    try {
      console.log("RUN: add stripe payment method");
      const userId = assertAuth(context);
      const paymentMethodId = assertData(data, "paymentMethodId");

      // get stripe doc
      const snap = await getStripeDoc(userId);
      // get stripe customer id
      const customer = assertData(snap, "customerId");
      // create source with strip api
      const resFromStripe = await stripe.paymentMethods.attach(
        paymentMethodId,
        {
          customer
        }
      );
      // update customer to add default payment method
      await stripe.customers.update(customer, {
        invoice_settings: {
          default_payment_method: paymentMethodId
        }
      });
      const paymentMethodData = { paymentMethodId };
      await firestore
        .doc(`stripe/${userId}`)
        .set(paymentMethodData, { merge: true });
      // add source to firestore
      await firestore
        .collection(`stripe/${userId}/sources/`)
        .add(resFromStripe);
      console.log("SUCCESS: add stripe payment method");
      return { result: true };
    } catch (error) {
      console.log("ERROR: add stripe payment method");
      console.log(error);
      return { result: false };
      // throw new functions.https.HttpsError(
      //   error,
      //   "ERROR: add stripe payment method"
      // );
    }
  }
);

exports.createStripeCharge = functions.firestore
  .document("users/{userId}/orders/{orderId}")
  .onCreate(async (snapshot, context) => {
    try {
      console.log("RUN: create stripe charge");
      const userId = context.params.userId;
      const orderId = context.params.orderId;

      // get stripe doc
      const snap = await getStripeDoc(userId);
      // get stripe customer id and paymen method id
      const customer = assertData(snap, "customerId");
      const paymentMethodId = assertData(snap, "paymentMethodId");

      // get order info
      const amount = assertData(snapshot.data(), "price");
      //TODO addapt different currency
      const currency = "JPY";
      const description = `OMUSUBI id: ${orderId} total: ${amount}`;

      const intent = {
        amount,
        currency,
        customer,
        description
        // payment_method: paymentMethodId
      };

      const resFromStripe = await stripe.paymentIntents.create(intent, {
        idempotency_key: orderId
      });
      const paymentIntentId = resFromStripe.id;
      // confirm to proceed can be stopped to cancel before proceed
      const confirmFromStripe = await stripe.paymentIntents.confirm(
        paymentIntentId,
        {
          payment_method: paymentMethodId
        }
      );
      const chargeData = {
        confirmFromStripe
      };

      await snapshot.ref.set(chargeData, { merge: true });
      console.log("SUCCESS: create stripe charge");
      return;
    } catch (error) {
      console.log("ERROR: create stripe charge");
      console.error(error);
      throw new functions.https.HttpsError(
        error,
        "ERROR: create stripe charge"
      );
      // await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
    }
  });

//TODO cause unnecessary function call, maybe need improvement https onCall like add paymentmethod?
exports.refundStripeCharge = functions.firestore
  .document("users/{userId}/orders/{orderId}")
  .onUpdate(async (change, _) => {
    try {
      console.log("RUN: refund stripe charge");
      const data = change.after.data();
      if (data === null) {
        console.log("ERROR DATA NOT FOUND: refund stripe charge");
        return;
      }

      const chargeStatus = assertData(data, "status");
      // only proceed status is refund request
      if (chargeStatus !== "REFUND_REQUESTED") {
        console.log("NOT REFUND REQUEST: refund stripe charge");
        return;
      }
      const chargeData = assertData(data, "confirmFromStripe");
      const paymentIntentId = assertData(chargeData, "id");
      const paymentData = { payment_intent: paymentIntentId };
      const resFromStripe = await stripe.refunds.create(paymentData);
      // const userId = context.params.userId;
      // await firestore
      //   .doc(`users/${userId}/refunds/${paymentIntentId}`)
      //   .set(resFromStripe, { merge: true });
      if (resFromStripe.status !== "succeeded") {
        console.log("ERROR WITH STRIPE PROCESS: refund stripe charge");
        throw new functions.https.HttpsError(
          "unknown",
          "ERROR: refund stripe charge"
        );
      }
      await change.after.ref.set(
        {
          status: "REFUNDED"
        },
        { merge: true }
      );
      console.log("SUCCESS: refund stripe charge");
      return;
    } catch (error) {
      console.log("ERROR: refund stripe charge");
      console.error(error);
      throw new functions.https.HttpsError(
        error,
        "ERROR: refund stripe charge"
      );
      // await change.ref.set({ error: userFacingMessage(error) }, { merge: true });
    }
  });

//TODO maybe implement remove card

// function userFacingMessage(error) {
//   return error.type
//     ? error.message
//     : "An error occurred, support-team has been alerted!!!";
// }

// exports.countCart = functions.firestore
//   .document("users/{userId}/cart/{cartItemId}")
//   .onWrite(async (snapshot, context) => {
//     const userId = context.params.userId;

//     const docRef = firestore.doc(`users/${userId}`);
//     return docRef
//       .collection("cart")
//       .get()
//       .then(querySnapshot => {
//         const cartCount = querySnapshot.size;
//         const data = { cartCount };
//         return docRef.update(data);
//       })
//       .catch(err => {
//         console.log(err);
//       });
//   });
