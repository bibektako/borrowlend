import 'package:borrowlend/features/home/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';

@immutable

sealed class HomeEvent {}
final class LoadCategoryEvent extends HomeEvent{}

final class NavigateToSearchView extends HomeEvent{
  final BuildContext context;
  final Widget destination;

  NavigateToSearchView({ required this.context, required this.destination});
}






 
