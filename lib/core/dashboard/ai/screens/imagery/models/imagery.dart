import 'dart:convert';

/// model data class for image generation screen
class Imagery {
  /// model data class for image generation screen
  Imagery({required this.id, required this.prompt, required this.imageUrl, required this.isUser, required this.groupId});

  /// id of the user currently using the application
  final String id;

  /// prompt used to generate image
  final String prompt;

  /// image URL - used to display images
  final String imageUrl;

  /// is this the user or AI
  final bool isUser;

  /// the group an image and prompt belongs to
  final int groupId;

  /// change to [Imagery] data model
  factory Imagery.fromjson(Map<String, dynamic> json) {
    return Imagery(
      id: json['id'],
      prompt: json['prompt'],
      imageUrl: json['image_url'],
      isUser: json['is_user'],
      groupId: json['group_id'],
    );
  }

  /// Convert to json object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'image_url': imageUrl,
      'is_user': isUser,
      'group_id': groupId,
    };
  }

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'prompt': prompt,
      'image_url': imageUrl,
      'is_user': isUser,
      'group_id':groupId
    });
  }
}
