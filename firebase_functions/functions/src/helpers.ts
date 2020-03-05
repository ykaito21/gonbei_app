import * as functions from "firebase-functions";
import { firestore } from "./config";

// validate data
export const assertData = (data: any, key: string) => {
  if (!data[key]) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      `function called without ${key} data`
    );
  } else {
    return data[key];
  }
};

// validate auth
export const assertAuth = (context: any) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "function called without context.auth"
    );
  } else {
    return context.auth.uid;
  }
};

// catch error
export const catchErrors = async (promise: Promise<any>) => {
  try {
    return await promise;
  } catch (err) {
    throw new functions.https.HttpsError("unknown", err);
  }
};

// get stripe customer id
export const getStripeDoc = async (userId: String) => {
  return await firestore
    .doc(`stripe/${userId}`)
    .get()
    .then(doc => doc.data());
};
