import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> addMenu(String name, String price, String description,
    String voucherOption, File? image) async {
  CollectionReference menu = FirebaseFirestore.instance.collection('Menu');

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
    'name': name,
    'price': price,
    'description': description,
    'voucherOption': voucherOption,
    'imageUrl': imageUrl,
    'createdAt': Timestamp.now(),
  });
}
