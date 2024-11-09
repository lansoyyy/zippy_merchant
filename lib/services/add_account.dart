import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/utils/const.dart';

Future<String> addPost(
    String name,
    String desc,
    String businessName,
    String address,
    String merchantId,
    String operatingHours,
    String operatingDays,
    List categories,
    List wallets) async {
  final docUser = FirebaseFirestore.instance.collection('Merchant').doc();

  final json = {
    'name': name,
    'desc': desc,
    'businessName': businessName,
    'address': address,
    'merchantId': merchantId,
    'operatingHours': operatingHours,
    'operatingDays': operatingDays,
    'categories': categories,
    'wallets': wallets,
    'id': docUser.id,
    'uid': userId,
  };

  await docUser.set(json);

  return docUser.id;
}
