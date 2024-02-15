class PolicyModel {
  int? id;
  String? type;
  String? des;

  PolicyModel({this.id, this.type, this.des});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['des'] = des;
    return data;
  }
}
