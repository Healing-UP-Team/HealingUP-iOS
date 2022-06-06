//
//  FirebaseReference.swift
//  HealingUP-iOS
//
//  Created by Dicky Buwono on 23/05/22.
//

import Foundation
import Firebase

enum FirestoreCollection: String {
  case membership
  case kesslerQuiz
}

func firestoreCollection(_ collectionRefrence: FirestoreCollection) -> CollectionReference {
  return Firestore.firestore().collection(collectionRefrence.rawValue)
}
