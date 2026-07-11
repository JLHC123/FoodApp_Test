// Determine the expiration status icon color based on days left
String expirationStatus(int daysLeft) {
  if (daysLeft < 0) {
    return '🔴';
  }
  else if (daysLeft <= 3) {
    return '🟡';
  }
  else {
    return '🟢';
  }
}

// Get time truncated to just year month day for comparison purposes
DateTime truncateTime(DateTime time) {
  final truncatedTime = DateTime(
    time.year,
    time.month,
    time.day
  );
  return truncatedTime;
}