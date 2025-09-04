// lib/cubit/user_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_app/model/userModel.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
