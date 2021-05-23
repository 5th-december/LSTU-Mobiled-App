import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

class ListedResponse<T> {
  final int count;

  final int offset;

  @JsonKey(name: 'next_offset')
  final int nextOffset;

  final int remains;

  final List<T> payload;

  ListedResponse(
      {this.count,
      this.offset,
      this.nextOffset,
      this.remains,
      @required this.payload});

  factory ListedResponse.fromJson(
      Map<String, dynamic> json, Function payloadExtractor) {
    final items = json['payload'].cast<Map<String, dynamic>>();

    return ListedResponse<T>(
        count: json['count'] ?? null,
        offset: json['offset'] ?? null,
        nextOffset: json['next_offset'] ?? null,
        remains: json['remains'] ?? null,
        payload: new List<T>.from(
            items.map((itemsJson) => payloadExtractor(itemsJson))));
  }
}
