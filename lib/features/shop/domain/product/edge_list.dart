class EdgeList {
  List<Edges>? edges;

  EdgeList({this.edges});

  EdgeList.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      edges = <Edges>[];
      json['edges'].forEach((v) {
        edges!.add(new Edges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.edges != null) {
      data['edges'] = this.edges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Edges {
  Node? node;

  Edges({this.node});

  Edges.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (node != null) {
      data['node'] = node!.toJson();
    }
    return data;
  }
}

class Node {
  String? title;
  String? compareAtPrice;
  String? price;
  String? legacyResourceId;

  Node({this.title, this.compareAtPrice, this.price, this.legacyResourceId});

  Node.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    compareAtPrice = json['compareAtPrice'];
    price = json['price'];
    legacyResourceId = json['legacyResourceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['compareAtPrice'] = this.compareAtPrice;
    data['price'] = this.price;
    data['legacyResourceId'] = this.legacyResourceId;
    return data;
  }
}
