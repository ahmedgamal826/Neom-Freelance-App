// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:neon/core/Services/Notifications/notification_service.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     NotificationService.clearUnreadCount();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Notifications")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await NotificationService.showInstant();
//                     },
//                     child: const Text("📢 إشعار فوري"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       await NotificationService.clearCards();
//                       await NotificationService.cancelAll();
//                       if (!mounted) return;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("تم مسح سجل الإشعارات ❌")),
//                       );
//                     },
//                     child: const Text("🗑️ مسح السجل"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final DateTime when =
//                       await NotificationService.scheduleTestAfterSeconds(
//                     seconds: 10,
//                   );
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         "تمت جدولة إشعار اختبار بعد 10 ثواني (${when.second.toString().padLeft(2, '0')}s) ✅",
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text("⚡ اختبار بعد 10 ثواني"),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final DateTime when =
//                       await NotificationService.scheduleTestAfterMinutes(
//                     minutes: 1,
//                   );
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         "تمت جدولة إشعار اختبار عند ${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')} ✅",
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text("🧪 اختبار بعد دقيقة"),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () async {
//                   final List<PendingNotificationRequest> pending =
//                       await NotificationService.getPendingSchedules();
//                   if (!mounted) return;

//                   showModalBottomSheet<void>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       if (pending.isEmpty) {
//                         return const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text("لا توجد إشعارات مجدولة حاليًا."),
//                         );
//                       }

//                       return ListView.separated(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: pending.length,
//                         separatorBuilder: (_, __) => const Divider(height: 16),
//                         itemBuilder: (BuildContext context, int index) {
//                           final PendingNotificationRequest item =
//                               pending[index];
//                           return ListTile(
//                             dense: true,
//                             leading: const Icon(Icons.schedule),
//                             title: Text(item.title ?? "بدون عنوان"),
//                             subtitle: Text(
//                               "ID: ${item.id}\n${item.body ?? ''}",
//                             ),
//                             isThreeLine: true,
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//                 child: const Text("🔍 فحص الجدولة الحالية"),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ValueListenableBuilder<List<NotificationCardItem>>(
//                 valueListenable: NotificationService.cards,
//                 builder: (
//                   BuildContext context,
//                   List<NotificationCardItem> items,
//                   Widget? child,
//                 ) {
//                   if (items.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         "لا توجد إشعارات بعد",
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     );
//                   }

//                   return ListView.separated(
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 10),
//                     itemBuilder: (BuildContext context, int index) {
//                       final NotificationCardItem item = items[index];
//                       return Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           leading: Icon(
//                             item.isRead
//                                 ? Icons.notifications_none
//                                 : Icons.notifications_active,
//                             color: item.isRead ? Colors.grey : Colors.orange,
//                           ),
//                           title: Text(item.title),
//                           subtitle: Text(
//                             "${item.body}\n${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')} - ${item.time.day}/${item.time.month}/${item.time.year}",
//                           ),
//                           isThreeLine: true,
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
