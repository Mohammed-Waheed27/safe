import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';

/// AddCameraPage lets the user scan a QR code to add a new camera
class AddCameraPage extends StatefulWidget {
  const AddCameraPage({super.key});

  @override
  State<AddCameraPage> createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage>
    with WidgetsBindingObserver {
  late MobileScannerController _scannerController;
  bool _hasScanned = false;
  String _scannedCode = '';
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _isScannerInitialized = false;
  bool _hasPermissionError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay initialization to avoid issues with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScanner();
    });
  }

  void _initializeScanner() {
    try {
      _scannerController = MobileScannerController(
        // Simpler initialization to avoid plugin issues
        facing: CameraFacing.back,
        detectionSpeed: DetectionSpeed.normal,
      );

      // Try to start the scanner
      _scannerController
          .start()
          .then((_) {
            if (mounted) {
              setState(() {
                _isScannerInitialized = true;
              });
            }
          })
          .catchError((error) {
            print("Scanner initialization error: $error");
            if (mounted) {
              setState(() {
                _hasPermissionError = true;
                _errorMessage =
                    'Camera permission is required to scan QR codes';
              });
            }
          });
    } catch (e) {
      print("Exception creating scanner controller: $e");
      if (mounted) {
        setState(() {
          _hasPermissionError = true;
          _errorMessage = 'Error initializing camera: $e';
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Handle app lifecycle changes to properly manage camera
    if (state == AppLifecycleState.resumed) {
      if (!_isScannerInitialized && !_hasScanned) {
        _initializeScanner();
      }
    } else if (state == AppLifecycleState.paused) {
      if (_isScannerInitialized) {
        _scannerController.stop();
        _isScannerInitialized = false;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isScannerInitialized) {
      _scannerController.dispose();
    }
    super.dispose();
  }

  void _toggleFlash() {
    if (_isScannerInitialized) {
      setState(() {
        _isFlashOn = !_isFlashOn;
        _scannerController.toggleTorch();
      });
    }
  }

  void _switchCamera() {
    if (_isScannerInitialized) {
      setState(() {
        _isFrontCamera = !_isFrontCamera;
        _scannerController.switchCamera();
      });
    }
  }

  void _copyQRCodeToClipboard() {
    if (_scannedCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _scannedCode));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera ID copied to clipboard'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Add New Camera'),
        actions: [
          if (!_hasScanned && _isScannerInitialized)
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
              tooltip: 'Toggle Flash',
            ),
          if (!_hasScanned && _isScannerInitialized)
            IconButton(
              onPressed: _switchCamera,
              icon: Icon(
                _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
              ),
              tooltip: 'Switch Camera',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                _hasScanned
                    ? 'Camera connected successfully!'
                    : 'Scan the QR code on your camera system to connect it',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),

            // Scanner or success view
            Expanded(
              child:
                  _hasPermissionError
                      ? _buildPermissionErrorView()
                      : _hasScanned
                      ? _buildSuccessView()
                      : _buildScannerView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 2),
    );
  }

  /// Build the permission error view
  Widget _buildPermissionErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64.w),
            SizedBox(height: 20.h),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasPermissionError = false;
                  _initializeScanner();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: Text(
                'Request Permission',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the scanner view
  Widget _buildScannerView() {
    if (!_isScannerInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            SizedBox(height: 16.h),
            Text(
              'Initializing camera...',
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Scanner container with rounded corners
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  if (capture.barcodes.isEmpty || _hasScanned) {
                    return;
                  }

                  final Barcode barcode = capture.barcodes.first;
                  final String code = barcode.rawValue ?? 'Unknown code';

                  setState(() {
                    _hasScanned = true;
                    _scannedCode = code;
                  });

                  // Play haptic feedback for success
                  HapticFeedback.mediumImpact();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Camera connected: $code'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Scanner hint
        Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            'Position the QR code in the scanner area',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  /// Build the success view after scanning
  Widget _buildSuccessView() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80.w,
            ),
          ),

          SizedBox(height: 32.h),

          // Success text
          Text(
            'Camera Connected',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 16.h),

          // Camera ID with copy option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Camera ID: $_scannedCode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.copy,
                  color: AppTheme.primaryColor,
                  size: 20.sp,
                ),
                onPressed: _copyQRCodeToClipboard,
                tooltip: 'Copy ID',
              ),
            ],
          ),

          SizedBox(height: 32.h),

          // Done button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Scan another button
          TextButton(
            onPressed: () {
              setState(() {
                _hasScanned = false;
                _scannedCode = '';
                // Re-initialize scanner if needed
                if (!_isScannerInitialized) {
                  _initializeScanner();
                }
              });
            },
            child: Text(
              'Scan Another Camera',
              style: TextStyle(fontSize: 16.sp, color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom overlay for the QR scanner
class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    Key? key,
    required this.overlayColor,
    required this.borderColor,
    required this.borderLength,
    required this.borderWidth,
    required this.borderRadius,
    required this.cutOutSize,
  }) : super(key: key);

  final Color overlayColor;
  final Color borderColor;
  final double borderLength;
  final double borderWidth;
  final double borderRadius;
  final double cutOutSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(overlayColor, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: cutOutSize,
                  width: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: cutOutSize,
            height: cutOutSize,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                // Top-left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColor,
                  ),
                ),

                // Top-right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColor,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColor,
                  ),
                ),

                // Bottom-left corner
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColor,
                  ),
                ),

                // Bottom-right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
