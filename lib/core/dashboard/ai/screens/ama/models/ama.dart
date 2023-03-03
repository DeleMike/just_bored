import 'dart:convert';

/// AMA data model
class Ama {
  /// AMA data model
  Ama({required this.id, required this.message, required this.isUser});

  final String id;
  final String message;
  final bool isUser;

  /// change to [Ama] data model
  factory Ama.fromjson(Map<String, dynamic> json) {
    return Ama(
      id: json['id'],
      message: json['message'],
      isUser: json['is_user'],
    );
  }

  /// Convert to json object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'is_user': isUser,
    };
  }

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'message': message,
       'is_user': isUser,
    });
  }
}
