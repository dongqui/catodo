import 'package:flutter/material.dart';
import 'package:catodo/features/audio/presentation/viewmodels/audio_state.dart';
import 'package:catodo/features/audio/presentation/viewmodels/audio_controller.dart';

final List<AudioType> audioList = [
  AudioType.rain,
  AudioType.birds,
];

class AudioBox extends StatefulWidget {
  const AudioBox({super.key});

  @override
  State<AudioBox> createState() => _AudioBoxState();
}

class _AudioBoxState extends State<AudioBox> {
  final AudioController audioController = AudioController();

  @override
  void initState() {
    super.initState();
    initAudioList();
  }

  @override
  void dispose() {
    super.dispose();

    audioController.dispose();
  }

  bool isMusicOn = false;

  initAudioList() async {
    await AudioManager.instance.getAudioList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 음악 선택 토글 버튼
        SwitchListTile(
          title: Text('음악 켜기/끄기'),
          value: isMusicOn,
          onChanged: (bool value) {
            setState(() {
              isMusicOn = value;
            });
          },
        ),
        // 백색 소음 체크박스
        ...audioList.map((AudioType type) {
          return CheckboxListTile(
            title: Text(type.name),
            value: AudioManager.instance.state.whiteNoise.contains(type.name),
            onChanged: (bool? value) {
              setState(() {
                AudioManager.instance
                    .updateWhiteNoise(type.name, value ?? false);

                if (value == true) {
                  audioController.play(type);
                } else {
                  audioController.stop(type);
                }
              });
            },
          );
        }),
      ],
    );
  }
}
