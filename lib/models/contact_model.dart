import 'package:flutter/foundation.dart';

/// Represents a single trusted emergency contact (Guardian).
///
/// Replaces the raw [Map<String, String>] previously used in [ContactsScreen].
/// Immutable by design — use [copyWith] to derive modified copies.
@immutable
class EmergencyContact {
  /// The guardian's display name (e.g. "Mom", "Priya").
  final String name;

  /// The guardian's full phone number string (e.g. "+91 98765 43210").
  final String phone;

  const EmergencyContact({
    required this.name,
    required this.phone,
  });

  /// Returns a new [EmergencyContact] with optionally overridden fields.
  EmergencyContact copyWith({String? name, String? phone}) {
    return EmergencyContact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() => 'EmergencyContact(name: $name, phone: $phone)';

  @override
  bool operator ==(Object other) =>
      other is EmergencyContact &&
      other.name == name &&
      other.phone == phone;

  @override
  int get hashCode => Object.hash(name, phone);
}
