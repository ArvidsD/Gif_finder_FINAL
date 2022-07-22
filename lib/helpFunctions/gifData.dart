//This was created with help from  https://app.quicktype.io/

import 'dart:convert';

GifData GifDataFromJson(String str) => GifData.fromJson(json.decode(str));

String GifDataToJson(GifData data) => json.encode(data.toJson());

class GifData {
  GifData({
    required this.data,
    required this.pagination,
    required this.meta,
  });

  List<Gifs> data;
  Pagination pagination;
  Meta meta;

  factory GifData.fromJson(Map<String, dynamic> json) => GifData(
    data: List<Gifs>.from(json["data"].map((x) => Gifs.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
    "meta": meta.toJson(),
  };
}

class Gifs {
  Gifs({

    required  this.url,

    required this.images,

  });



  String url;

  Images images;


  factory Gifs.fromJson(Map<String, dynamic> json) => Gifs(

    url: json["url"],

    images: Images.fromJson(json["images"]),

  );

  Map<String, dynamic> toJson() => {

    "url": url,

    "images": images.toJson(),

  };
}
//image: snapshot.data['data'][index]['images']['fixed_height']['url'],
class Images {
  Images({
    required  this.original,
    required this.fixedHeight,

  });

  FixedHeight original;
  FixedHeight fixedHeight;


  factory Images.fromJson(Map<String, dynamic> json) => Images(
    original: FixedHeight.fromJson(json["original"]),
    fixedHeight: FixedHeight.fromJson(json["fixed_height"]),

  );

  Map<String, dynamic> toJson() => {
    "original": original.toJson(),
    "fixed_height": fixedHeight.toJson(),

  };
}
class Meta {
  Meta({
    required   this.status,
    required   this.msg,
    required  this.responseId,
  });

  int status;
  String msg;
  String responseId;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    status: json["status"],
    msg: json["msg"],
    responseId: json["response_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "response_id": responseId,
  };
}

class Pagination {
  Pagination({
    required   this.totalCount,
    required   this.count,
    required   this.offset,
  });

  int totalCount;
  int count;
  int offset;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json["total_count"],
    count: json["count"],
    offset: json["offset"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "count": count,
    "offset": offset,
  };
}

class FixedHeight {
  FixedHeight({
    required   this.height,
    required  this.width,
    required   this.size,
    required  this.url,

  });

  String height;
  String width;
  String size;
  String url;


  factory FixedHeight.fromJson(Map<String, dynamic> json) => FixedHeight(
    height: json["height"],
    width: json["width"],
    size: json["size"],
    url: json["url"],

  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "width": width,
    "size": size,
    "url": url,

  };
}