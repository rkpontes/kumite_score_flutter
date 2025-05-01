import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kumite_score/src/components/app_button.dart';

const int ippon = 2;
const int wazaAri = 1;

class KumiteScorePage extends StatefulWidget {
  const KumiteScorePage({super.key});

  @override
  State<KumiteScorePage> createState() => _KumiteScorePageState();
}

class _KumiteScorePageState extends State<KumiteScorePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _duration = const Duration(minutes: 5);
  bool _isRunning = false;
  int _initialMinutes = 5;
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

  void _setPoint(String player, int point) {
    setState(() {
      if (player == 'aka') {
        akaScore += point;
      } else if (player == 'shiro') {
        shiroScore += point;
      }
    });
  }

  void _removePoint(String player, int point) {
    setState(() {
      if (player == 'aka') {
        akaScore -= point;
      } else if (player == 'shiro') {
        shiroScore -= point;
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _duration = Duration(minutes: _initialMinutes);
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

  Widget _buildBottomButtons(Size size) {
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
                onTap: () => _removePoint('aka', 1),
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
              GestureDetector(
                onTap: _showTimePickerModal,
                child: Text(
                  '${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 80.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                label: '-1',
                width: 100.w,
                onTap: () => _removePoint('shiro', 1),
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
      mainAxisSize: MainAxisSize.min,
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
                onTap: () => _setPoint('aka', ippon),
              ),
              SizedBox(height: 15),
              AppButton(
                label: 'WAZA-ARI',
                width: 300.w,
                onTap: () => _setPoint('aka', wazaAri),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.4,
          height: 300.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$akaScore'.padLeft(2, '0'),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 180.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
              Text(
                '$shiroScore'.padLeft(2, '0'),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 180.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                onTap: () => _setPoint('shiro', ippon),
              ),
              SizedBox(height: 15),
              AppButton(
                label: 'WAZA-ARI',
                width: 300.w,
                onTap: () => _setPoint('shiro', wazaAri),
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

  void _showTimePickerModal() {
    int tempMinutes = _initialMinutes;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Selecione os minutos',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: DropdownButton<int>(
            value: tempMinutes,
            isExpanded: true,
            items: List.generate(10, (index) => index + 1)
                .map((min) => DropdownMenuItem(
                      value: min,
                      child: Text('$min minutos'),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _initialMinutes = value;
                  _duration = Duration(minutes: value);
                });
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
