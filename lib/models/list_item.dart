class ListItem {
  int id;
  int idList;
  String name;
  String quantity;
  String note;
  String isDone;
  bool doneDoneBuying;

  ListItem(
      this.id, this.idList, this.name, this.quantity, this.note, this.isDone,
      {this.doneDoneBuying});

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'idList': idList,
      'name': name,
      'quantity': quantity,
      'note': note,
      'isDone': isDone
    };
  }
}
