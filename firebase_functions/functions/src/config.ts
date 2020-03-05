import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const firestore = admin.firestore();
const settings = { timestampsInSnapshots: true };
firestore.settings(settings);

export const stripeSecret = functions.config().stripe.secret;

import Stripe from "stripe";
export const stripe = new Stripe(stripeSecret, {
  apiVersion: "2020-03-02"
});
