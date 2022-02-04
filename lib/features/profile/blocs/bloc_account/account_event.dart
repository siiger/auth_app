part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class UpdateAccount extends AccountEvent {
  const UpdateAccount(this.user);
  final User user;

  @override
  List<Object> get props => [user];
}

class Name extends AccountEvent {
  const Name(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class Email extends AccountEvent {
  const Email(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class DayOfBirth extends AccountEvent {
  const DayOfBirth(this.dayOfBirth);
  final DateTime dayOfBirth;

  @override
  List<Object> get props => [dayOfBirth];
}

class Save extends AccountEvent {
  const Save();
  @override
  List<Object> get props => [];
}

class PhoneNumber extends AccountEvent {
  const PhoneNumber(this.phone);
  final String phone;

  @override
  List<Object> get props => [phone];
}

class StreetName extends AccountEvent {
  const StreetName(this.streetName);
  final String streetName;

  @override
  List<Object> get props => [streetName];
}

class StreetNumber extends AccountEvent {
  const StreetNumber(this.streetNumber);
  final String streetNumber;

  @override
  List<Object> get props => [streetNumber];
}

class City extends AccountEvent {
  const City(this.city);
  final String city;

  @override
  List<Object> get props => [city];
}

class ZipCode extends AccountEvent {
  const ZipCode(this.zipCode);
  final String zipCode;

  @override
  List<Object> get props => [zipCode];
}

class UpdateData extends AccountEvent {
  const UpdateData(this.data);
  final String data;

  @override
  List<Object> get props => [data];
}

