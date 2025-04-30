import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/viewmodels/plant_notifications_viewmodel.dart';
import 'package:garden_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class AddPlantNotificationPage extends StatelessWidget {
  const AddPlantNotificationPage({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => PlantNotificationsViewModel(
            plant: plant,
            plantRepository: Provider.of(context, listen: false),
          ),
      child: Consumer<PlantNotificationsViewModel>(
        builder: (context, viewModel, _) {
          Future<void> selectDate() async {
            final d = await showDatePicker(
              context: context,
              initialDate: viewModel.pickDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (d != null) {
              viewModel.pickDate = DateTime(
                d.year,
                d.month,
                d.day,
                viewModel.pickTime.hour,
                viewModel.pickTime.minute,
              );
            }
          }

          Future<void> selectTime() async {
            final t = await showTimePicker(
              context: context,
              initialTime: viewModel.pickTime,
            );
            if (t != null) viewModel.pickTime = t;
          }

          Widget buildTextField({
            required TextEditingController controller,
            required String label,
            TextInputType keyboardType = TextInputType.text,
          }) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
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
                onChanged: (text) {
                  if (controller == viewModel.messageController) return;
                  final val = int.tryParse(text) ?? 1;
                  viewModel.days = val;
                },
              ),
            );
          }

          Widget buildPicker({
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
              title: 'notifications.add_title'.tr(),
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
              showRightButton: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    controller: viewModel.messageController,
                    label: 'notifications.message_label'.tr(),
                  ),
                  buildPicker(
                    value: DateFormat.yMMMd().format(viewModel.pickDate),
                    onTap: selectDate,
                  ),
                  buildPicker(
                    value: viewModel.pickTime.format(context),
                    onTap: selectTime,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'notifications.repeat'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: viewModel.repeat,
                        onChanged: (newVal) => viewModel.repeat = newVal,
                      ),
                    ],
                  ),
                  if (viewModel.repeat)
                    buildTextField(
                      controller: TextEditingController(
                        text: viewModel.days.toString(),
                      ),
                      label: 'notifications.repeat_every_days'.tr(),
                      keyboardType: TextInputType.number,
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
                      viewModel.pickDate.year,
                      viewModel.pickDate.month,
                      viewModel.pickDate.day,
                      viewModel.pickTime.hour,
                      viewModel.pickTime.minute,
                    );
                    viewModel.addNotification(
                      message: viewModel.messageController.text,
                      startDate: dt,
                      repeatEveryDays: viewModel.repeat ? viewModel.days : null,
                    );
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
