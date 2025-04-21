import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/models/notification.dart';
import 'package:garden_app/viewmodels/plant_notifications_viewmodel.dart';
import 'package:garden_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class AddPlantNotificationPage extends StatelessWidget {
  const AddPlantNotificationPage({
    Key? key,
    required this.plant,
    this.notification,
  }) : super(key: key);

  final Plant plant;
  final PlantNotification? notification;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantNotificationsViewModel(plant: plant),
      child: Consumer<PlantNotificationsViewModel>(
        builder: (context, viewModel, child) {
          // controllers and state
          final messageCtrl = TextEditingController(
            text: notification?.message ?? '',
          );
          DateTime pickDate = notification?.startDate ?? DateTime.now();
          TimeOfDay pickTime = TimeOfDay.fromDateTime(pickDate);
          bool repeat = notification?.repeatEveryDays != null;
          int days = notification?.repeatEveryDays ?? 1;

          Future<void> selectDate() async {
            final d = await showDatePicker(
              context: context,
              initialDate: pickDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (d != null) {
              pickDate = DateTime(
                d.year,
                d.month,
                d.day,
                pickTime.hour,
                pickTime.minute,
              );
            }
          }

          Future<void> selectTime() async {
            final t = await showTimePicker(
              context: context,
              initialTime: pickTime,
            );
            if (t != null) pickTime = t;
          }

          Widget _buildTextField({
            required TextEditingController controller,
            required String? label,
            bool readOnly = false,
          }) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: label,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            );
          }

          Widget _buildPicker({
            required String label,
            required String value,
            required VoidCallback onTap,
          }) {
            return InkWell(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(value, style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: TopBar(
              title:
                  notification == null
                      ? 'notifications.add_title'.tr()
                      : 'notifications.edit_title'.tr(),
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
              showRightButton: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: messageCtrl,
                    label: 'notifications.message_label'.tr(),
                  ),
                  _buildPicker(
                    label: 'notifications.date'.tr(),
                    value: DateFormat.yMMMd().format(pickDate),
                    onTap: selectDate,
                  ),
                  _buildPicker(
                    label: 'notifications.time'.tr(),
                    value: pickTime.format(context),
                    onTap: selectTime,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'notifications.repeat'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Switch(value: repeat, onChanged: (v) => repeat = v),
                    ],
                  ),
                  if (repeat)
                    DropdownButtonFormField<int>(
                      value: days,
                      items:
                          [1, 7, 14, 30]
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                    d == 1
                                        ? '1 ${'day'.tr()}'
                                        : '$d ${'days'.tr()}',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => days = v ?? 1,
                      decoration: InputDecoration(
                        labelText: 'notifications.repeat_every'.tr(),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final dt = DateTime(
                      pickDate.year,
                      pickDate.month,
                      pickDate.day,
                      pickTime.hour,
                      pickTime.minute,
                    );
                    if (notification == null) {
                      viewModel.addNotification(
                        message: messageCtrl.text,
                        startDate: dt,
                        repeatEveryDays: repeat ? days : null,
                      );
                    } else {
                      viewModel.updateNotification(
                        notification: notification!,
                        message: messageCtrl.text,
                        startDate: dt,
                        repeatEveryDays: repeat ? days : null,
                      );
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'notifications.save'.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
