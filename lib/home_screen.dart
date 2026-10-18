import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const HomeScreen({super.key, this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = false;
  int _selectedBottomNavIndex = 0;
  bool _isLoadingBalance = false;

  final PageController _bannerPageController = PageController(
    viewportFraction: 0.75,
  );
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  final List<String> _bannerList = [
    'assets/tin-dung-banner.jpeg',
    'assets/dien-nuoc-banner.png',
    'assets/tiet-kiem-banner.jpg',
    'assets/han-muc-banner.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  // Hàm gọi trực tiếp vào Database Supabase để lấy số dư mới nhất
  Future<void> _fetchLatestBalance() async {
    setState(() {
      _isLoadingBalance = true;
    });

    try {
      final accountNumber = widget.userData?['account_number'];
      var query = Supabase.instance.client.from('mb-bank').select();

      final response = accountNumber != null
          ? await query.eq('account_number', accountNumber).maybeSingle()
          : await query.limit(1).maybeSingle();

      if (response != null && mounted) {
        setState(() {
          widget.userData?['balance'] = response['balance']?.toString();
          _isLoadingBalance = false;
        });
      } else {
        setState(() => _isLoadingBalance = false);
      }
    } catch (e) {
      debugPrint('Lỗi fetch số dư từ Supabase: $e');
      if (mounted) {
        setState(() => _isLoadingBalance = false);
      }
    }
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;

      if (_currentBannerIndex < _bannerList.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_bannerPageController.hasClients) {
        _bannerPageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  Widget _buildHeaderIconButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(padding: const EdgeInsets.all(4.0), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    String rawBalance =
        widget.userData?['balance'] ??
        widget.userData?['blance'] ??
        '5,231,092,000';

    return Scaffold(
      backgroundColor: const Color(0xFF0F2B6B),
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Image.asset(
              'assets/background-app.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF0F2B6B)),
            ),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                children: [
                  // HEADER TOP
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 32,
                          child: Image.asset(
                            'assets/logo-app.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text(
                              'MB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _buildHeaderIconButton(
                              onTap: () {},
                              child: Image.asset(
                                'assets/ong.png',
                                width: 32,
                                height: 32,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(
                                  Icons.bug_report,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildHeaderIconButton(
                              onTap: () {},
                              child: Image.asset(
                                'assets/search.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildHeaderIconButton(
                              onTap: () {},
                              child: Image.asset(
                                'assets/bell.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildHeaderIconButton(
                              onTap: () {},
                              child: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // AVATAR & THẺ SỐ DƯ
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/user.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 30),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Image.asset(
                              'assets/basic.png',
                              height: 24,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(width: 34),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF163278).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    12,
                                    4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            'Tổng số dư VND',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (!_isBalanceVisible) {
                                            await _fetchLatestBalance();
                                          }
                                          setState(() {
                                            _isBalanceVisible =
                                                !_isBalanceVisible;
                                          });
                                        },
                                        child: _isLoadingBalance
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF00B2FF),
                                                ),
                                              )
                                            : Icon(
                                                _isBalanceVisible
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: const Color(0xFF00B2FF),
                                                size: 18,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    _isBalanceVisible
                                        ? '$rawBalance VND'
                                        : '*** *** VND',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Divider(
                                  color: Colors.white.withOpacity(0.12),
                                  height: 1,
                                ),
                                InkWell(
                                  onTap: () {},
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(18),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'SINH LỜI MỖI NGÀY',
                                          style: TextStyle(
                                            color: Color(0xFF00B2FF),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: Color(0xFF00B2FF),
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // KHUNG NỀN TRẮNG
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildQuickMenuItem(
                                    title: 'Chuyển tiền',
                                    iconPath: 'assets/transfer.png',
                                    onTap: () {},
                                  ),
                                  _buildQuickMenuItem(
                                    title: 'Nạp tiền\nđiện thoại',
                                    iconPath: 'assets/phone.png',
                                    onTap: () {},
                                  ),
                                  _buildQuickMenuItem(
                                    title: 'Tiền gửi',
                                    iconPath: 'assets/pig.png',
                                    badgeText: 'TÀI LỘC',
                                    badgeColor: const Color(0xFFE53935),
                                    onTap: () {},
                                  ),
                                  _buildQuickMenuItem(
                                    title: 'Vay nhanh',
                                    iconPath: 'assets/money.png',
                                    badgeText: 'NHƯ GIÓ 💨',
                                    badgeColor: const Color(0xFF1E88E5),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -28,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEE2737),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // BANNER SLIDER
                        SizedBox(
                          height: 155,
                          child: PageView.builder(
                            controller: _bannerPageController,
                            onPageChanged: (int index) {
                              setState(() {
                                _currentBannerIndex = index;
                              });
                            },
                            itemCount: _bannerList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    _bannerList[index],
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: const Color(0xFF102A6B),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Banner ${index + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // MUA SẮM - GIẢI TRÍ - ĐẦU TƯ
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mua sắm - Giải trí - Đầu tư',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102A6B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.count(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.88,
                                children: [
                                  _buildDirectIconItem(
                                    title: 'Vua Xổ Số',
                                    iconPath: 'assets/xo-so.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Vé số\nVietlott',
                                    iconPath: 'assets/vietlot.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Data 4G/\nNạp tiền',
                                    iconPath: 'assets/vina.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Vé Máy Bay\nSố',
                                    iconPath: 'assets/may-bay.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Vé máy bay',
                                    iconPath: 'assets/may-bay-2.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Data 4G/Thẻ\nGame',
                                    iconPath: 'assets/4g.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Vận Số',
                                    iconPath: 'assets/van-so.png',
                                    onTap: () {},
                                  ),
                                  _buildDirectIconItem(
                                    title: 'Xem thêm\ndịch vụ',
                                    iconPath: 'assets/xem-them.png',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1652E0),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_rounded,
            label: 'Trang chủ',
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.credit_card_rounded,
            label: 'Thẻ',
          ),
          _buildQRNavItem(),
          _buildNavItem(
            index: 2,
            icon: Icons.card_giftcard_rounded,
            label: 'Ưu đãi',
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.grid_view_rounded,
            label: 'Thêm',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = _selectedBottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNavIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 26,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRNavItem() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          'assets/qr-code.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.qr_code_scanner_rounded,
            color: Color(0xFF1652E0),
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectIconItem({
    required String title,
    required String iconPath,
    String? badgeCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.apps, color: Colors.grey),
                  ),
                ),
              ),
              if (badgeCount != null)
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE2737),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      badgeCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required String title,
    required String iconPath,
    String? badgeText,
    Color? badgeColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Color(0xFF0F2B6B)),
                  ),
                ),
              ),
              if (badgeText != null)
                Positioned(
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF102A6B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}