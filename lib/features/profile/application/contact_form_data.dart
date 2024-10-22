import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_form_data.freezed.dart';
part 'contact_form_data.g.dart';

@freezed
class ContactData with _$ContactData {
  const factory ContactData({
    String? mobileNumber,
    String? email,
    String? description,
  }) = _ContactData;

  factory ContactData.fromJson(Map<String, dynamic> json) =>
      _$ContactDataFromJson(json);
}
