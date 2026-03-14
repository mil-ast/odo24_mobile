import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MiliageCameraScreen extends StatefulWidget {
  final int currentODO;
  const MiliageCameraScreen({required this.currentODO, super.key});

  @override
  State<MiliageCameraScreen> createState() => _MiliageCameraScreenState();
}

class _MiliageCameraScreenState extends State<MiliageCameraScreen> {
  static const _odoRate = 10000;
  static const _maxFoundNumbers = 3;
  final _numRe = RegExp(r'[^0-9]');
  late final _maxODO = widget.currentODO + _odoRate;
  final _foundNumbers = <int>[];
  Object? _error;

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isDone = false;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      return;
    }
    _controller = CameraController(
      _cameras!.first,
      ResolutionPreset.medium,
      fps: 15,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    try {
      await _controller!.initialize();

      if (!mounted) {
        return;
      }
      setState(() {});
      _startLiveRecognition();
    } catch (e) {
      setState(() {
        print(e);
        _cameraStop();
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraStop();
    _controller?.dispose();
    super.dispose();
  }

  void _cameraStop() {
    _controller?.stopImageStream();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized || _cameras == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Column(children: [Text(_error!.toString())]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: !isDone ? Center(child: CameraPreview(_controller!, child: const Text('Child'))) : const Text('Done'),
      ),
    );
  }

  void _startLiveRecognition() {
    _controller?.startImageStream((CameraImage image) async {
      if (_isProcessing) return; // Пропускаем кадр, если предыдущий еще в работе
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImage(image, _cameras!.first);
        final odo = await _processImage(inputImage);
        if (odo != null) {
          if (mounted) {
            Navigator.of(context).pop(odo);
            return;
          } else {
            setState(() {
              isDone = true;
            });
          }
        }
      } catch (e) {
        setState(() {
          print(e);
          _cameraStop();
          _error = e;
        });
      } finally {
        _isProcessing = false;
      }
    });
  }

  // распознание
  Future<int?> _processImage(InputImage inputImage) async {
    final recognizedText = await _textRecognizer.processImage(inputImage);

    // В цикле обработки:
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        // Работаем только с линиями, где есть числа
        final cleanDigits = line.text.replaceAll(_numRe, '');
        if (cleanDigits.isEmpty) {
          continue;
        }
        final odo = int.tryParse(cleanDigits);
        if (odo == null) {
          continue;
        }

        if (odo > widget.currentODO && odo < _maxODO) {
          _foundNumbers.add(odo);
          if (_foundNumbers.length == _maxFoundNumbers) {
            _cameraStop();
            final odo = _findNearestODO(_foundNumbers, widget.currentODO);
            print('Пробег: $odo');
            return odo;
          }
        }
      }
    }
    return null;
  }

  InputImage _convertCameraImage(CameraImage image, CameraDescription camera) {
    final allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    // Получаем ориентацию
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
    // Формат (обычно nv21 для Android, bgra8888 для iOS)
    final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    // В новых версиях метаданные передаются через InputImageMetadata
    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow, // Берем из первой плоскости
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  int _findNearestODO(List<int> list, int currentODO) {
    return list.reduce((prev, curr) {
      return (curr - currentODO) < (prev - currentODO) ? curr : prev;
    });
  }
}
