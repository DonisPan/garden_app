import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/models/notification.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/viewmodels/plant_notifications_viewmodel.dart';
import 'package:garden_app/widgets/top_bar.dart';

class PlantNotificationsPage extends StatelessWidget {
  final Plant plant;

  const PlantNotificationsPage({Key? key, required this.plant})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantNotificationsViewModel(plant: plant),
      child: Consumer<PlantNotificationsViewModel>(
        builder: (context, viewModel, _) {
          final notifications = viewModel.notifications;
          return Scaffold(
            appBar: TopBar(
              title: 'notifications.title'.tr(),
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
              rightIcon: 'assets/svgs/plus.svg',
              onRightButtonTap: () => viewModel.rightButton(context),
            ),
            body:
                notifications.isEmpty
                    ? Center(
                      child: Text(
                        'notifications.empty'.tr(),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final PlantNotification item = notifications[index];
                          return _buildNotificationCard(
                            context,
                            item,
                            viewModel,
                          );
                        },
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    PlantNotification notification,
    PlantNotificationsViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${'notifications.starts'.tr()}: ${DateFormat.yMMMd().add_jm().format(notification.startDate)}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Text(
                      '${'notifications.frequency'.tr()}: ${notification.frequencyDescription}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    if (notification.nextOccurrence != null) ...[
                      Text(
                        '${'notifications.next'.tr()}: ${DateFormat.yMMMd().add_jm().format(notification.nextOccurrence!)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: notification.isActive,
                    onChanged:
                        (_) => viewModel.toggleNotification(notification),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/trash.svg',
                      height: 20,
                      color: Colors.red,
                    ),
                    onPressed: () => viewModel.deleteNotification(notification),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
