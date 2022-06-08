import 'package:bremind/domain/repository/amen.content/model/query.methods.dart';
import 'package:flutter/foundation.dart';

class ContentQuery {
  final String property;
  final QueryMethods method;
  final Object value;
  final int limit;
  late String orderProperty;
  final bool orderDescending;

  ContentQuery(
    this.property,
    this.method,
    this.value, {
    this.limit = 20,
    final String? orderByProperty,
    this.orderDescending = true,
  }) {
    orderProperty = orderByProperty ?? property;
  }

  String get id =>
      property +
      describeEnum(method) +
      value.hashCode.toString() +
      limit.toString();

  static ContentQuery testQuery() {
    return ContentQuery("id", QueryMethods.isNotEqualTo, '');
  }

  ContentQuery copyWith({
    String? property,
    QueryMethods? method,
    Object? value,
    int? limit,
    String? orderByProperty,
    bool? orderDescending,
  }) {
    return ContentQuery(
      property ?? this.property,
      method ?? this.method,
      value ?? this.value,
      limit: limit ?? this.limit,
      orderByProperty: orderByProperty ?? orderProperty,
      orderDescending: orderDescending ?? this.orderDescending,
    );
  }
}
