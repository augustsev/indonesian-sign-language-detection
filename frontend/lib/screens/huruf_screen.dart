import 'dart:async';
import 'dart:io';
import '../api/api_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

class HurufScreen extends StatefulWidget {
  const HurufScreen({Key? key}) : super(key: key);

  @override
  State<HurufScreen> createState() => _HurufScreenState();
}

class _HurufScreenState extends State<HurufScreen> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  int _selectedCameraIndex = 0;
  bool _isFlashOn = false;
  bool _isCameraBusy = false;
  bool _isDetectionActive = true;
  bool _isSoundOn = true;

  String _predictedHuruf = "";
  Timer? _timer;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadCamerasAndStart();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _loadCamerasAndStart() async {
    _cameras = await availableCameras();
    await _initCamera(_selectedCameraIndex);
    _startPredictionTimer();
  }

  Future<void> _initCamera(int cameraIndex) async {
    _isCameraBusy = true;
    _timer?.cancel();

    try {
      if (_controller != null) {
        await _controller!.dispose();
      }

      _controller = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
      } else {
        await _controller!.setFlashMode(FlashMode.off);
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    } finally {
      _isCameraBusy = false;
      _startPredictionTimer();
    }
  }

  void _startPredictionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _captureAndPredict());
  }

  Future<void> _captureAndPredict() async {
    if (!_isDetectionActive || _isCameraBusy || _controller == null) return;
    if (!_controller!.value.isInitialized || _controller!.value.isTakingPicture) return;

    try {
      _isCameraBusy = true;

      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      final file = await _controller!.takePicture();
      final imageFile = File(file.path);

      print("Gambar disimpan sementara di: ${imageFile.path}");

      final predictedList = await ApiService.predictHuruf(imageFile);
      final predicted = predictedList.isNotEmpty ? predictedList[0] : "";

      if (_isSoundOn && predicted != _predictedHuruf && predicted.isNotEmpty) {
        await _flutterTts.speak("$predicted");
      }

      setState(() {
        _predictedHuruf = predicted;
      });

      if (await imageFile.exists()) {
        await imageFile.delete();
        print("Gambar sudah dihapus: ${imageFile.path}");
      }
    } catch (e) {
      print("Prediction error: $e");
    } finally {
      _isCameraBusy = false;
    }
  }

  void _switchCamera() async {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initCamera(_selectedCameraIndex);
  }

  void _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    _isFlashOn = !_isFlashOn;
    await _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isFrontCamera =
        _cameras[_selectedCameraIndex].lensDirection ==
            CameraLensDirection.front;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [

            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // ===== TITLE =====
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Deteksi Gesture AI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // ===== STATUS =====
                  Row(
                    children: [
                      Icon(
                        _isDetectionActive
                            ? Icons.radio_button_checked
                            : Icons.pause_circle,
                        color: _isDetectionActive
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isDetectionActive ? "AI Active" : "Paused",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== CAMERA =====
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: _predictedHuruf.isNotEmpty
                              ? Colors.greenAccent.withOpacity(0.6)
                              : Colors.transparent,
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        Transform(
                          alignment: Alignment.center,
                          transform: isFrontCamera
                              ? Matrix4.rotationY(math.pi)
                              : Matrix4.identity(),
                          child: CameraPreview(_controller!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== RESULT =====
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Column(
                      key: ValueKey(_predictedHuruf),
                      children: [
                        Text(
                          _predictedHuruf.isEmpty
                              ? "Arahkan tangan ke kamera"
                              : "Huruf yang dikenali:",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _predictedHuruf.isEmpty
                              ? "Menunggu..."
                              : _predictedHuruf,
                          style: TextStyle(
                            color: _predictedHuruf.isEmpty
                                ? Colors.white
                                : Colors.greenAccent,
                            fontSize: _predictedHuruf.isEmpty ? 22 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== CONTROL =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _isSoundOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSoundOn = !_isSoundOn;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isDetectionActive ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDetectionActive = !_isDetectionActive;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: _switchCamera,
                ),
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}