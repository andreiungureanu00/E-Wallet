class NotificationMessage {
  final id;
  final body;
  // ignore: non_constant_identifier_names
  final target_object_id;
  final unread;

  NotificationMessage(this.id, this.body, this.target_object_id, this.unread);
}