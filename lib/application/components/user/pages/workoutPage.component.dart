import 'dart:async';

import 'package:FitApp/application/entities/workout.entity.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<Workout> exercises = [
    Workout(name: 'Supino Reto', sets: 3, defaultWeight: 20, defaultReps: 10, videoRef:'https://cdnl.iconscout.com/lottie/premium/preview-watermark/man-doing-sled-leg-press-exercise-for-legs-animation-download-in-lottie-json-gif-static-svg-file-formats--men-workout-male-gym-exercises-pack-fitness-animations-9729963.mp4'),
    Workout(name: 'Rosca Direta', sets: 4, defaultWeight: 15, defaultReps: 12, videoRef:'https://cdnl.iconscout.com/lottie/premium/preview-watermark/man-doing-sled-leg-press-exercise-for-legs-animation-download-in-lottie-json-gif-static-svg-file-formats--men-workout-male-gym-exercises-pack-fitness-animations-9729963.mp4'),
    Workout(name: 'Agachamento', sets: 5, defaultWeight: 30, defaultReps: 8, videoRef:'https://cdnl.iconscout.com/lottie/premium/preview-watermark/man-doing-sled-leg-press-exercise-for-legs-animation-download-in-lottie-json-gif-static-svg-file-formats--men-workout-male-gym-exercises-pack-fitness-animations-9729963.mp4'),
  ];

  int currentExerciseIndex = 0;
  Map<int, Timer?> timers = {};

  void startRestTimer(int setIndex) {
    final currentExercise = exercises[currentExerciseIndex];
    if (currentExercise.restTimes[setIndex] > 0) return;

    setState(() {
      currentExercise.restTimes[setIndex] = 30;
    });

    timers[setIndex]?.cancel();
    timers[setIndex] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentExercise.restTimes[setIndex] > 0) {
        setState(() {
          currentExercise.restTimes[setIndex]--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void playVideo(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return VideoDialog(videoUrl: videoUrl);
      },
    );
  }

  void nextExercise() {
    if (currentExerciseIndex < exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        timers.forEach((_, timer) => timer?.cancel());
        timers.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você concluiu todos os exercícios!')),
      );
    }
  }

  void previousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
        timers.forEach((_, timer) => timer?.cancel());
        timers.clear();
      });
    }
  }

  @override
  void dispose() {
    timers.forEach((_, timer) => timer?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = exercises[currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentExercise.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.play_circle_fill, size: 30),
                      onPressed: () {
                        playVideo(currentExercise.videoRef);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.45, // Altura proporcional para 4 itens.
                ),
                child: ListView.builder(
                  itemCount: currentExercise.sets,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: currentExercise.weight[index]
                                          ?.toString() ??
                                      currentExercise.defaultWeight.toString()),
                              decoration: const InputDecoration(
                                labelText: 'Carga (kg)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  currentExercise.weight[index] =
                                      int.tryParse(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "X",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: currentExercise.reps[index]
                                          ?.toString() ??
                                      currentExercise.defaultReps.toString()),
                              decoration: const InputDecoration(
                                labelText: 'Repetições',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  currentExercise.reps[index] =
                                      int.tryParse(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Checkbox(
                            value: currentExercise.completed[index],
                            onChanged: (value) {
                              setState(() {
                                currentExercise.completed[index] =
                                    value ?? false;
                              });
                              if (currentExercise.completed[index]) {
                                startRestTimer(index);
                              } else {
                                currentExercise.restTimes[index] = 0;
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          if (currentExercise.restTimes[index] > 0)
                            Text(
                              "${currentExercise.restTimes[index]}s",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:
                        currentExerciseIndex > 0 ? previousExercise : null,
                    child: const Text('Anterior'),
                  ),
                  ElevatedButton(
                    onPressed: currentExerciseIndex < exercises.length - 1
                        ? nextExercise
                        : null,
                    child: const Text('Próximo'),
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


class VideoDialog extends StatefulWidget {
  final String videoUrl;

  const VideoDialog({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Atualiza a UI quando o vídeo estiver pronto
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}
