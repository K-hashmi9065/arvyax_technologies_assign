import 'package:arvyax_technologies_assign/features/yoga/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/yoga_pose_entity.dart';
import '../../data/repositories/yoga_repository_impl.dart';
import '../widgets/custom_button.dart';

class CreateYogaPage extends StatefulWidget {
  const CreateYogaPage({super.key});

  @override
  State<CreateYogaPage> createState() => _CreateYogaPageState();
}

class _CreateYogaPageState extends State<CreateYogaPage> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final audioController = TextEditingController();
  final durationController = TextEditingController();
  final YogaRepositoryImpl _repo = YogaRepositoryImpl();

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    audioController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Pose')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'Pose Name',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: imageController,
                hintText: 'Image Path',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: audioController,
                hintText: 'Audio Path',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: durationController,
                hintText: 'Duration (seconds)',
              ),

              const SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  CustomButton(
                    onPressed: () async {
                      final pose = YogaPoseEntity(
                        name: nameController.text,
                        imagePath: imageController.text,
                        audioPath: audioController.text,
                        duration: int.tryParse(durationController.text) ?? 30,
                      );
                      final result = await _repo.createYogaPose(pose);
                      if (!mounted) return;
                      result.fold(
                        (failure) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${failure.message}')),
                        ),
                        (createdPose) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pose added successfully!'),
                            ),
                          );
                        },
                      );
                    },
                    text: 'Save',
                  ),
                  const SizedBox(width: 5),
                  CustomButton(
                    onPressed: () => context.go('/'),
                    text: 'Cancel',
                    bgColor: Colors.red,
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
