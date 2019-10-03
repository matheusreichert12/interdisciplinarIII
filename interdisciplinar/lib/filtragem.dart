import 'package:cloud_firestore/cloud_firestore.dart';

class Filtragem {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('clientes')
        .where('nome',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}