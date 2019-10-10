import 'package:cloud_firestore/cloud_firestore.dart';

class EquipamentoData {
  String category;
  String title;
  String description;
  double price;

  List images;
  List sizes;

  String id;
  String nome;
  String descricaoAdicional;
  double valorAdicional;
  double valorDia;
  

  EquipamentoData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
  }

  Map<String, dynamic> toResumeMap() {
    return {"title": title, "price": price};
  }
}
