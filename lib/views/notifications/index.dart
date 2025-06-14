import 'package:demo/controllers/notification_controller.dart';
import 'package:demo/models/noification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController = Get.find();

  // Custom color palette matching login screen
  final Color primaryColor = const Color(0xFF6C63FF);
  final Color secondaryColor = const Color(0xFF4A40BF);
  final Color accentColor = const Color(0xFFF8B400);
  final Color backgroundColor = const Color(0xFFF9F9F9);
  final Color textColor = const Color(0xFF333333);
  final Color lightTextColor = const Color(0xFF777777);

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: _buildAppBar(),
        body: _buildNotificationList(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(
        () => Text(
          'Notifications ${notificationController.unreadCount.value > 0 ? '(${notificationController.unreadCount.value})' : ''}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        Obx(
          () => notificationController.unreadCount.value > 0
              ? IconButton(
                  icon: _buildMarkAllAsReadIcon(),
                  onPressed: notificationController.markAllAsRead,
                  tooltip: 'Tout marquer comme lu',
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildMarkAllAsReadIcon() {
    return Stack(
      children: [
        const Icon(Icons.mark_as_unread, color: Colors.white),
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Obx(
              () => Text(
                notificationController.unreadCount.value.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: notificationController.fetchNotifications,
      color: primaryColor,
      child: Obx(() {
        if (notificationController.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (notificationController.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: notificationController.notifications.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
          itemBuilder: (context, index) {
            final notification = notificationController.notifications[index];
            return _buildNotificationItem(notification);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 60, color: lightTextColor),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nous vous informerons lorsque quelque chose arrive',
            style: TextStyle(color: lightTextColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: notificationController.fetchNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Notificatione notification) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');
    final createdAt = notification.createdAt != null 
        ? DateTime.tryParse(notification.createdAt!) 
        : null;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) => _handleDismiss(notification),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          color: notification.isRead 
              ? Colors.white 
              : primaryColor.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildReadStatusIcon(notification),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notification.message ?? 'Pas de message',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: notification.isRead 
                            ? FontWeight.normal 
                            : FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!notification.isRead) _buildUnreadIndicator(),
                ],
              ),
              const SizedBox(height: 4),
              if (createdAt != null) _buildTimestamp(createdAt, dateFormat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red[400],
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<void> _handleDismiss(Notificatione notification) async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Supprimer la Notification',
      titleStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      middleText: 'Êtes-vous sûr de vouloir supprimer cette notification ?',
      middleTextStyle: TextStyle(color: lightTextColor),
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[400],
      cancelTextColor: primaryColor,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      await notificationController.deleteNotification(notification.id!);
      Get.snackbar(
        'Supprimé',
        'La notification a été supprimée',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void _handleNotificationTap(Notificatione notification) {
    if (!notification.isRead) {
      notificationController.markAsRead(notification.id!);
    }
    // TODO: Add navigation to relevant screen based on notification type
  }

  Widget _buildReadStatusIcon(Notificatione notification) {
    return Icon(
      notification.isRead ? Icons.check_circle : Icons.info,
      color: notification.isRead ? Colors.green : primaryColor,
      size: 20,
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTimestamp(DateTime createdAt, DateFormat dateFormat) {
    return Text(
      dateFormat.format(createdAt),
      style: TextStyle(color: lightTextColor, fontSize: 12),
    );
  }
}