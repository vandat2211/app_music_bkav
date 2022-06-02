import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class SearchEventLoadData extends SearchEvent{
  final String query;
  SearchEventLoadData({required this.query});

}






