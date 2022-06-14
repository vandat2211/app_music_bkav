import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class SearchEventLoadData extends SearchEvent{
  final String query;
  SearchEventLoadData({required this.query});
  @override
  List<Object> get props => [query];
}



