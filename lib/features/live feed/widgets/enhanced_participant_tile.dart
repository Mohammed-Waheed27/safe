import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';
import '../../../core/theme/appthme.dart';

class EnhancedParticipantTile extends StatefulWidget {
  final Participant participant;
  final bool isLocalParticipant;

  const EnhancedParticipantTile({
    super.key,
    required this.participant,
    this.isLocalParticipant = false,
  });

  @override
  State<EnhancedParticipantTile> createState() =>
      _EnhancedParticipantTileState();
}

class _EnhancedParticipantTileState extends State<EnhancedParticipantTile>
    with TickerProviderStateMixin {
  Stream? videoStream;
  Stream? audioStream;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeStreams();
    _initStreamListeners();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _initializeStreams() {
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        } else if (stream.kind == 'audio') {
          audioStream = stream;
        }
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      debugPrint('🎥 Stream enabled: ${stream.kind}');
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      } else if (stream.kind == 'audio') {
        setState(() => audioStream = stream);
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      debugPrint('🎥 Stream disabled: ${stream.kind}');
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      } else if (stream.kind == 'audio') {
        setState(() => audioStream = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // Main video content
              _buildVideoContent(),

              // Gradient overlay for better text visibility
              _buildGradientOverlay(),

              // Connection status indicator
              _buildConnectionStatus(),

              // Participant info overlay
              _buildParticipantInfo(),

              // Live indicator
              _buildLiveIndicator(),

              // Quality indicator
              _buildQualityIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (videoStream != null) {
      try {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.4),
              width: 2.w,
            ),
          ),
          child: RTCVideoView(
            videoStream?.renderer as RTCVideoRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        );
      } catch (e) {
        debugPrint('Video render error: $e');
        return _buildVideoPlaceholder();
      }
    }
    return _buildVideoPlaceholder();
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
            Colors.grey.shade900,
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2.w,
        ),
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 2.w,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 48.sp,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Camera Off',
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tap camera button to enable video',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Positioned(
      top: 12.h,
      left: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Connected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantInfo() {
    return Positioned(
      bottom: 12.h,
      left: 12.w,
      right: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Live Feed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    videoStream != null ? 'Broadcasting' : 'Camera disabled',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Audio indicator with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color:
                    audioStream != null
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: audioStream != null ? Colors.green : Colors.red,
                  width: 1.w,
                ),
              ),
              child: Icon(
                audioStream != null ? Icons.mic : Icons.mic_off,
                color: audioStream != null ? Colors.green : Colors.red,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Color(0xFFFF5722)],
                ),
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQualityIndicator() {
    return Positioned(
      bottom: 12.h,
      right: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hd, color: Colors.white, size: 14.sp),
            SizedBox(width: 2.w),
            Text(
              'HD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
