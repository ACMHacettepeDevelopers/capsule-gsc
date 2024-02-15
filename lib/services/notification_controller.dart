import "dart:io";
import "dart:math";
import "package:awesome_notifications/awesome_notifications.dart";

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }
  Future<void> requestPermission(bool byChance) async {
    bool isNotificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isNotificationsAllowed){
      print("ALLOWED NOTIFICATIONS");
      return;
    }
    if (byChance) {
      int randomNumber = Random().nextInt(4);
      if (randomNumber == 0) {
        if (Platform.isAndroid) {
          await AwesomeNotifications()
              .requestPermissionToSendNotifications(permissions: [
            NotificationPermission.PreciseAlarms,
          ]);
        }
        if (Platform.isIOS) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      }
    }
    else{
    if (Platform.isAndroid) {
      await AwesomeNotifications()
          .requestPermissionToSendNotifications(permissions: [
        NotificationPermission.PreciseAlarms,
      ]);
    }
    if (Platform.isIOS) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }}
  }
}
