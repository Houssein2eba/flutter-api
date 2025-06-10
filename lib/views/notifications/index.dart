import 'package:demo/controllers/notification_controller.dart';
import 'package:demo/models/noification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController = Get.find();

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          )
        ),
      ),
      backgroundColor: Colors.blue,
      elevation: 0,
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
        const Icon(Icons.mark_as_unread),
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10)),
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
      child: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notificationController.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: notificationController.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
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
          const Icon(Icons.notifications_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),          Text('Aucune notification', style: Get.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Nous vous informerons lorsque quelque chose arrive',
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(            onPressed: notificationController.fetchNotifications,
            child: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Notificatione notification) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
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
              ? Colors.transparent 
              : Colors.blue.shade50.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildReadStatusIcon(notification),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(                      notification.message ?? 'Pas de message',
                      style: TextStyle(
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
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<void> _handleDismiss(Notificatione notification) async {
    final confirmed = await Get.defaultDialog<bool>(      title: 'Supprimer la Notification',
      middleText: 'Êtes-vous sûr de vouloir supprimer cette notification ?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.blue,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      await notificationController.deleteNotification(notification.id!);      Get.snackbar(
        'Supprimé',
        'La notification a été supprimée',
        snackPosition: SnackPosition.BOTTOM,
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
      color: notification.isRead ? Colors.green : Colors.orange,
      size: 20,
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTimestamp(DateTime createdAt, DateFormat dateFormat) {
    return Text(
      dateFormat.format(createdAt),
      style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }

  
}