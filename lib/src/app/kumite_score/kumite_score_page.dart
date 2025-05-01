import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kumite_score/src/components/app_button.dart';

class KumiteScorePage extends StatefulWidget {
  const KumiteScorePage({super.key});

  @override
  State<KumiteScorePage> createState() => _KumiteScorePageState();
}

class _KumiteScorePageState extends State<KumiteScorePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = const Duration(minutes: 5);
  bool _isRunning = false;
  Timer? _timer;

  int akaScore = 0;
  int shiroScore = 0;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_duration.inSeconds == 1) {
          await _audioPlayer.play(AssetSource('sounds/boxing-bell.mp3'));
        }

        if (_duration.inSeconds == 0) {
          timer.cancel();
          setState(() => _isRunning = false);
        } else {
          setState(() {
            _duration = _duration - const Duration(seconds: 1);
          });
        }
      });
    }

    setState(() => _isRunning = !_isRunning);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _duration = const Duration(minutes: 5);
      _isRunning = false;
      akaScore = 0;
      shiroScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(size),
                SizedBox(height: 20.h),
                _buildscoreBoardPoints(size),
                SizedBox(height: 20.h),
                _buildTimer(size),
                SizedBox(height: 20.h),
                _buildBottomButtons(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildBottomButtons(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: size.width * 0.3),
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: 'Hajimê | Yamê',
                color: Color(0xFF236AEE),
                width: 368.w,
                onTap: _toggleTimer,
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: 'Reset',
                color: Color(0xFF236AEE),
                onTap: _reset,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimer(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: '-1',
                width: 100.w,
                onTap: _isRunning ? () => setState(() => akaScore -= 1) : null,
              ),
            ],
          ),
        ),
        Container(
          width: size.width * 0.3,
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Timer',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: '-1',
                width: 100.w,
                onTap:
                    _isRunning ? () => setState(() => shiroScore -= 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildscoreBoardPoints(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: 'IPPON',
                width: 300.w,
                onTap: _isRunning ? () => setState(() => akaScore += 3) : null,
              ),
              SizedBox(height: 15),
              AppButton(
                label: 'WAZA-ARI',
                width: 300.w,
                onTap: _isRunning ? () => setState(() => akaScore += 2) : null,
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.4,
          height: 200.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Transform.translate(
                  offset: Offset(0, -20.h),
                  child: Transform.scale(
                    scaleY: 1.5,
                    child: Text(
                      '$akaScore',
                      style: TextStyle(
                        fontSize: 150.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100.w,
                  maxWidth: 300.w,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 20.w),
              FittedBox(
                fit: BoxFit.contain,
                child: Transform.translate(
                  offset: Offset(0, -20.h),
                  child: Transform.scale(
                    scaleY: 1.5,
                    child: Text(
                      '$shiroScore',
                      style: TextStyle(
                        fontSize: 150.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppButton(
                label: 'IPPON',
                width: 300.w,
                onTap:
                    _isRunning ? () => setState(() => shiroScore += 3) : null,
              ),
              SizedBox(height: 15),
              AppButton(
                label: 'WAZA-ARI',
                width: 300.w,
                onTap:
                    _isRunning ? () => setState(() => shiroScore += 2) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: size.width * 0.3,
          child: Center(
            child: Text(
              'AKA',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.black,
            child: Center(
              child: Text(
                'Kumitê',
                style: TextStyle(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: size.width * 0.3,
          child: Center(
            child: Text(
              'SHIRO',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Row(
      children: [
        Expanded(child: Container(color: Colors.red)),
        Expanded(child: Container(color: Colors.white)),
      ],
    );
  }
}
