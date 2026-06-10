import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

class KalimatScreen extends StatefulWidget {
  const KalimatScreen({super.key});

  @override
  State<KalimatScreen> createState() => _KalimatScreenState();
}

class _KalimatScreenState extends State<KalimatScreen> with WidgetsBindingObserver {
  String hasilDeteksi = 'Belum ada deteksi.';
  bool isDeteksiBerjalan = false;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _cameraInitialized = false;

  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 4.0;

  FlashMode _currentFlashMode = FlashMode.off;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
        await _cameraController?.dispose();
      } else if (state == AppLifecycleState.resumed) {
        if (_cameras != null && _cameras!.isNotEmpty) {
          await _setupCamera(_cameras![_cameraIndex]);
        }
      }
    } catch (e) {
      debugPrint('Error lifecycle kamera: $e');
      if (mounted) {
        setState(() {
          hasilDeteksi = 'Error lifecycle kamera: $e';
        });
      }
    }
  }

  Future<void> _initCamera() async {
    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          _cameraIndex = 0;
          await _setupCamera(_cameras![_cameraIndex]);
        }
      } else {
        if (mounted) {
          setState(() {
            hasilDeteksi = 'Izin kamera ditolak.';
          });
        }
      }
    } catch (e) {
      debugPrint('Gagal inisialisasi kamera: $e');
    }
  }

  Future<void> _setupCamera(CameraDescription cameraDescription) async {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          _cameraController!.description == cameraDescription) return;

      await _cameraController?.dispose();

      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      _minZoomLevel = await _cameraController!.getMinZoomLevel();
      _maxZoomLevel = await _cameraController!.getMaxZoomLevel();
      _currentZoomLevel = _minZoomLevel;

      if (mounted) {
        setState(() {
          _cameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error saat setup kamera: $e');
      if (mounted) {
        setState(() {
          hasilDeteksi = 'Gagal menginisialisasi kamera.';
          _cameraInitialized = false;
        });
      }
    }
  }

  void mulaiDeteksi() {
    setState(() {
      isDeteksiBerjalan = true;
      hasilDeteksi = 'Mengartikan gesture...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          hasilDeteksi = 'Halo, apa kabar?';
        });
      }
    });
  }

  void berhentiDeteksi() {
    if (mounted) {
      setState(() {
        isDeteksiBerjalan = false;
        hasilDeteksi = 'Deteksi dihentikan.';
      });
    }
  }

  void _toggleFlash() async {
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) return;

      _currentFlashMode =
          _currentFlashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _cameraController!.setFlashMode(_currentFlashMode);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Gagal mengubah flash: $e');
    }
  }

  void _flipCamera() async {
    try {
      if (_cameras == null || _cameras!.isEmpty) return;

      _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
      await _setupCamera(_cameras![_cameraIndex]);
    } catch (e) {
      debugPrint('Gagal flip kamera: $e');
    }
  }

  void _onZoomChanged(double zoom) async {
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) return;

      _currentZoomLevel = zoom;
      await _cameraController!.setZoomLevel(zoom);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Gagal zoom: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Terjemahan Kalimat BISINDO')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: (_cameraController != null && _cameraController!.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: (_cameraIndex == 1)
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: CameraPreview(_cameraController!),
                                )
                              : CameraPreview(_cameraController!),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _currentFlashMode == FlashMode.off
                                      ? Icons.flash_off
                                      : Icons.flash_on,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleFlash,
                              ),
                              IconButton(
                                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                                onPressed: _flipCamera,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
          ),
            if (_cameraInitialized)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_out, color: Colors.white70),
                    Expanded(
                      child: Slider(
                        value: _currentZoomLevel.clamp(_minZoomLevel, _maxZoomLevel),
                        min: _minZoomLevel,
                        max: _maxZoomLevel,
                        onChanged: _onZoomChanged,
                        activeColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        inactiveColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white30
                            : Colors.black26,
                      ),
                    ),
                    const Icon(Icons.zoom_in, color: Colors.white70),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Hasil Terjemahan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hasilDeteksi,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: isDeteksiBerjalan ? null : mulaiDeteksi,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Mulai Deteksi'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: isDeteksiBerjalan ? berhentiDeteksi : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Berhenti'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
