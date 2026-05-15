import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead];
}

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [notifications, isLoading];
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    // Load initial mock notifications
    loadNotifications();
  }

  void loadNotifications() {
    emit(state.copyWith(isLoading: true));
    
    // Simulate API fetch with mock data
    final mockNotifications = [
      NotificationModel(
        id: '1',
        title: 'Promotion Spéciale !',
        body: 'Profitez de 20% de réduction sur tous les engrais ce weekend.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        title: 'Commande Confirmée',
        body: 'Votre commande #12345 a été confirmée par le vendeur.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];

    emit(state.copyWith(notifications: mockNotifications, isLoading: false));
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updated));
  }
}
