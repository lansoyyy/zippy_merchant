import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zippy/utils/const.dart';

Future<void> addMenu(String name, String price, String description,
    String voucherOption, File? image) async {
  CollectionReference menu = FirebaseFirestore.instance.collection('Menu');
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid == null) {
    throw Exception('User not logged in');
  }

  String imageUrl = '';
  if (image != null) {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('menu_images')
        .child('${DateTime.now().toIso8601String()}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
  }

  await menu.add({
    'availability': 'Available',
    'name': name,
    'price': price,
    'description': description,
    'voucherOption': voucherOption,
    'imageUrl': imageUrl,
    'createdAt': Timestamp.now(),
    'uid': uid, // Correctly store the current user's uid here
  });
}
