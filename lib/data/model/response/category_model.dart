import 'package:flutter_grocery/data/model/response/sub_sub_category.dart';

class CategoryModel {
  int? _id;
  String? _name;
  String? _image;
  int? _parentId;
  int? _position;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  late List<SubSubCate> _subCate;


  CategoryModel(
      {int? id,
        String? name,
        String? image,
        int? parentId,
        int? position,
        int? status,
        String? createdAt,
        String? updatedAt ,
      required List<SubSubCate> subCate}) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._parentId = parentId;
    this._position = position;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._subCate = subCate;
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  int? get parentId => _parentId;
  int? get position => _position;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<SubSubCate> get subCate => _subCate;

  CategoryModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['subsubcategories'] != null) {
      _subCate = [];
      json['subsubcategories'].forEach((v) {
        _subCate.add(new SubSubCate.fromJson(v));
      });
      print('LENNNNNNNNNNNNNNNNNNNNNNN = ${_subCate.length}');
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['subsubcategories'] = this._subCate.map((v) => v.toJson()).toList();
  
    return data;
  }
}
