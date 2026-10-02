// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jegkxrkqntuajamutmbc.supabase.co',
    anonKey: 'sb_publishable_0xEqdllbOEIp1TgWv_MTfQ_ORrWUT1o',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MB Bank',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _fullName = 'Khách hàng';
  Map<String, dynamic>? _fullUserData;

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNameOnly();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchNameOnly() async {
    try {
      final response = await Supabase.instance.client
          .from('mb-bank')
          .select('full_name, balance, account_number')
          .limit(1)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _fullName = response['full_name'] ?? 'Khách hàng';
          _fullUserData = response;
        });
      }
    } catch (e) {
      debugPrint('Lỗi đọc dữ liệu: $e');
    }
  }

  void _handleLogin() async {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mật khẩu để đăng nhập!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);

    _navigateToHome();
  }

  void _showFaceIDDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MockFaceIDDialog(),
    );

    if (result == true && mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userData: _fullUserData),
      ),
    );
  }

  Widget _buildNameWidget(String fullName) {
    List<String> parts = fullName.trim().split(' ');
    String lastName = parts.isNotEmpty ? parts.first : '';
    String firstName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    const TextStyle nameStyle = TextStyle(
      color: Colors.white,
      fontSize: 26,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lastName, style: nameStyle),
        Text(
          firstName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nameStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background-app.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // --- HEADER VỚI LOGO VÀ CỤM 3 ICON DỌC BÊN PHẢI ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo MB Bank
                      Image.asset(
                        'assets/logo-app.png',
                        height: 38,
                        fit: BoxFit.contain,
                      ),

                      // Cụm 3 Icon nằm dọc
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. Icon Cờ Việt Nam
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/vn.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 2. Icon Chuông
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/bell.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 3. Icon Hỗ trợ
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/ong_ho_tro.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // --- FORM ĐĂNG NHẬP ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B4BB3).withOpacity(0.35),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                20,
                                20,
                                10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/shield.png', // Thay đường dẫn tới file ảnh trong assets của bạn
                                    width: 36, // Kích thước chiều rộng bằng size cũ
                                    height:
                                        36, // Kích thước chiều cao bằng size cũ
                            
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Xin chào,',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _buildNameWidget(_fullName),

                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // Nền trắng mờ trong suốt (giúp icon màu xanh bên trong tương phản cực tốt và nổi bật)
                                            color: Colors.black.withOpacity(
                                              0.18,
                                            ),
                                            // border: Border.all(
                                            //   color: Colors.white.withOpacity(
                                            //     0.25,
                                            //   ),
                                            //   width: 1,
                                            // ),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/face-id.png', // Đường dẫn file ảnh Face ID của bạn
                                              width: 42,
                                              height: 42,
                                              // Dùng màu xanh Cyan/Xanh sáng này để icon sáng rực lên trên nền mờ
                                              color: const Color(0xFF00B2FF),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Mật khẩu',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white38,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'Tài khoản khác',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'Quên mật khẩu?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Nút Đăng nhập
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF52E5FF),
                                  foregroundColor: const Color(0xFF00227B),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(23.0),
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Color(0xFF00227B),
                                        ),
                                      )
                                    : const Text(
                                        'Đăng nhập',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Action Icons
                  Row(
                    children: [
                      _buildBottomAction(
                        imagePath: 'assets/qr.png',
                        label: 'Quét QR',
                        imageSize: 35,
                        onTap: () {},
                      ),
                      _buildBottomAction(
                        icon: Icons.lock_outline_rounded,
                        label: 'Xác thực D-OTP',
                        imageSize: 26,
                        onTap: () {},
                      ),
                      _buildBottomAction(
                        imagePath: 'assets/icon-change.png',
                        label: 'Thay ảnh nền',
                        imageSize: 52,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction({
    IconData? icon,
    String? imagePath,
    required String label,
    bool isCapsuleBackground = false,
    double imageSize = 32,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cố định chiều cao khung chứa và dùng Center để ép tất cả icon/ảnh nằm đúng tâm đường ngang
            SizedBox(
              height: 36,
              child: Center(
                child: isCapsuleBackground
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF00B2FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Image.asset(
                          imagePath!,
                          height: 16,
                          color: Color(0xFF00B2FF),
                          fit: BoxFit.contain,
                        ),
                      )
                    : (imagePath != null
                          ? Image.asset(
                              imagePath,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              icon,
                              color: Color(0xFF00B2FF),
                              size: imageSize,
                            )),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- POPUP FACE ID IOS ---
class MockFaceIDDialog extends StatefulWidget {
  const MockFaceIDDialog({super.key});

  @override
  State<MockFaceIDDialog> createState() => _MockFaceIDDialogState();
}

class _MockFaceIDDialogState extends State<MockFaceIDDialog> {
  bool _isSuccess = false;
  Timer? _timer1;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();

    // Giả lập quét mặt trong 1.8 giây -> Báo thành công
    _timer1 = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isSuccess = true;
        });
      }
    });

    // Sau khi báo thành công 0.8 giây -> Đóng dialog
    _timer2 = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.82),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSuccess
                  ? const Icon(
                      Icons.check_circle_rounded,
                      key: ValueKey('success'),
                      color: Color(0xFF34C759),
                      size: 60,
                    )
                  : Stack(
                      key: const ValueKey('loading'),
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.face_rounded, color: Colors.white, size: 38),
                        SizedBox(
                          width: 58,
                          height: 58,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            Text(
              _isSuccess ? 'Hoàn tất' : 'Face ID',
              style: TextStyle(
                color: _isSuccess ? const Color(0xFF34C759) : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}