import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/views/plant_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PlantDetailViewModel extends ChangeNotifier {
  final Plant plant;
  final PlantRepository plantRepository;

  PlantDetailViewModel({required this.plant, required this.plantRepository}) {
    loadImages();
  }

  List<File> _plantImages = [];
  List<File> get plantImages => _plantImages;

  Future<void> loadImages() async {
    // get the application documents directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    // set the directory for current plant
    final Directory plantDir = Directory('${appDir.path}/plant_${plant.id}');
    if (await plantDir.exists()) {
      // list all images
      final List<FileSystemEntity> files = await plantDir.list().toList();
      _plantImages =
          files
              .where((file) {
                if (file is File) {
                  final String path = file.path.toLowerCase();
                  return path.endsWith('.jpg') ||
                      path.endsWith('.jpeg') ||
                      path.endsWith('.png');
                }
                return false;
              })
              .map((e) => e as File)
              .toList();
    } else {
      _plantImages = [];
    }
    notifyListeners();
  }

  Future<void> addImage(BuildContext context) async {
    // request permissions for both gallery and camera.
    final galleryPermission = await Permission.photos.request();
    final cameraPermission = await Permission.camera.request();

    if (galleryPermission.isGranted && cameraPermission.isGranted) {
      // show the dialog for image source
      final ImageSource? source = await showImageSourceDialog(context);

      if (source != null) {
        final picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(source: source);
        if (pickedImage != null) {
          final File tempFile = File(pickedImage.path);
          // get the application documents directory
          final Directory appDir = await getApplicationDocumentsDirectory();
          // set the directory for current plant
          final Directory plantDir = Directory(
            '${appDir.path}/plant_${plant.id}',
          );
          if (!(await plantDir.exists())) {
            await plantDir.create(recursive: true);
          }
          // generate image name
          final String newFileName =
              '${plant.name}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          // copy the image to directory
          final File savedImage = await tempFile.copy(
            '${plantDir.path}/$newFileName',
          );
          _plantImages.add(savedImage);
          notifyListeners();
        }
      }
    } else {
      debugPrint('Camera or Gallery permission denied.');
    }
  }

  Future<void> removeImage(File imageFile) async {
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
    _plantImages.remove(imageFile);
    notifyListeners();
  }

  Future<void> deletePlant(BuildContext context) async {
    await plantRepository.removePlant(plant.id);
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> manageNotifications(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantNotificationsPage(plant: plant),
      ),
    );
  }
}

Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
  return showDialog<ImageSource>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        title: Text(
          'plant_detail.image_source.dialog'.tr(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'plant_detail.image_source.description'.tr(),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed:
                      () => Navigator.of(dialogContext).pop(ImageSource.camera),
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Text('plant_detail.image_source.camera'.tr()),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed:
                      () =>
                          Navigator.of(dialogContext).pop(ImageSource.gallery),
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Text('plant_detail.image_source.galery'.tr()),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool?> confirmDeleteImage(BuildContext context, File imageFile) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        title: Text(
          'plant_detail.delete_image.dialog'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'plant_detail.delete_image.description'.tr(),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Text('plant_detail.delete_image.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Text('plant_detail.delete_image.confirm'.tr()),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed == true) {
      Provider.of<PlantDetailViewModel>(
        context,
        listen: false,
      ).removeImage(imageFile);
    }
    return confirmed;
  });
}
