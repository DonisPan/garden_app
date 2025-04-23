class AdminAnnouncer {
  /// Names of the plants this announcement refers to.
  final List<String> plantNames;

  /// The message body of the announcement.
  final String message;

  const AdminAnnouncer({required this.plantNames, required this.message});
}
