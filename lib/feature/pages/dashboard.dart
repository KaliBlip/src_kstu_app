import 'package:src_kstu_app/components/side_menu.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/notice_board_provider.dart';
import 'package:src_kstu_app/providers/trending_news_provider.dart';
import 'package:src_kstu_app/feature/pages/news_details.dart';
import 'package:src_kstu_app/feature/pages/notice_board_shimmer.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/feature/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:src_kstu_app/utils/announcement_sort.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var name;
  var index;
  var image;
  var id;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  bool isLoading = false;

  @override
  initState() {
    _checkConnectivity();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getUser();
        requestNotificationPermission(context);
        listenForPushNotifications(context);
      }
    });

    super.initState();
  }

  Future<void> _checkConnectivity() async {}

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isSideBarClosed = true;
  bool isSideMenuClosed = true;
  bool _hasRequestedPermission = false;
  static bool _pushListenerRegistered = false;

  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        name = localStorage.getString('name');
        index = localStorage.getInt('index');
        image = localStorage.getString('user_img');
        id = localStorage.getInt('id');
      });
    }
  }

  Future<bool?> _showPrePermissionDialog(BuildContext context) async {
    if (!context.mounted) return false;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Stay Updated!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We need your permission to send you important updates and notifications.'),
                Text('Would you like to enable notifications?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Not now'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void requestNotificationPermission(BuildContext context) async {
    if (_hasRequestedPermission) return;
    _hasRequestedPermission = true;

    // Already granted at the OS level – nothing to ask.
    if (OneSignal.Notifications.permission) return;

    // Only show our pre-permission dialog once, ever. After the user has
    // answered it we respect their choice instead of nagging on every visit.
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('asked_notification_permission') == true) return;

    if (!context.mounted) return;
    final shouldRequest = await _showPrePermissionDialog(context);
    await prefs.setBool('asked_notification_permission', true);
    if (shouldRequest == true) {
      await OneSignal.Notifications.requestPermission(true);
    }
  }

  void listenForPushNotifications(BuildContext context) {
    // Guard against registering a duplicate listener each time a new Dashboard
    // instance is pushed (which would navigate once per stale listener).
    if (_pushListenerRegistered) return;
    _pushListenerRegistered = true;

    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      if (data != null && data['announcemet_id'] != null) {
        final announcementId = data['announcemet_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNews(title: announcementId),
          ),
        );
      }
    });
  }

  void _openAnnouncement(int announcementId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailNews(title: announcementId)),
    );
  }

  String _formatDate(String formatted) {
    if (formatted.isEmpty) return '';
    final parts = formatted.split(', ');
    return parts.length > 1 ? parts[1] : formatted;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: topColor,
      resizeToAvoidBottomInset: false,
      drawer: SideMenu(),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  _sectionTitle('Notice Board'),
                  _noticeBoardSection(),
                  const SizedBox(height: 6),
                  _sectionTitle("What's trending?"),
                  _trendingSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: bottomColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu, color: topColor, size: 26),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$name",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: bottomColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$index",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            HeadPicture(image: image),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: topColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _noticeBoardSection() {
    final noticesStream = ref.watch(noticeBoardAutoRefreshProvider(1));
    return noticesStream.when(
      data: (notices) {
        if (notices.isEmpty) {
          return _emptyState('No notices yet');
        }
        final sorted = sortAnnouncementsByNewest(notices);
        final cardWidth = MediaQuery.of(context).size.width * 0.44;
        return SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: sorted.length,
            itemBuilder: (context, i) => _noticeCard(sorted[i], cardWidth),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: NoticeBoardShimmer(),
      ),
      error: (error, stack) => _emptyState('Could not load notices'),
    );
  }

  Widget _noticeCard(Announcement notice, double width) {
    return GestureDetector(
      onTap: () => _openAnnouncement(notice.id),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 14, top: 4, bottom: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: topColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: _netImage(
                "$announcement_imgUri${notice.featuredImage}",
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color:  Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatDate(notice.createdAtFormatted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trendingSection() {
    final trendsStream = ref.watch(trendingNewsAutoRefreshProvider(1));
    return trendsStream.when(
      data: (trends) {
        if (trends.isEmpty) {
          return _emptyState('Nothing trending right now');
        }
        final sorted = sortAnnouncementsByNewest(trends);
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
          itemCount: sorted.length,
          itemBuilder: (context, i) => _trendingCard(
            sorted[i],
            isLast: i == sorted.length - 1,
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TrendingShimmer(),
      ),
      error: (error, stack) => _emptyState('Could not load trending news'),
    );
  }

  Widget _trendingCard(Announcement trend, {required bool isLast}) {
    return GestureDetector(
      onTap: () => _openAnnouncement(trend.id),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _netImage(
              "$announcement_imgUri${trend.featuredImage}",
              height: 240,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            trend.title.trim(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.clock, color: headColor, size: 18),
              const SizedBox(width: 8),
              Text(
                _formatDate(trend.createdAtFormatted),
                style: GoogleFonts.poppins(
                  color: headColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const FaIcon(FontAwesomeIcons.eye, color: headColor, size: 18),
              const SizedBox(width: 8),
              Text(
                trend.viewsCountFormatted,
                style: GoogleFonts.poppins(
                  color: headColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (!isLast)
            Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
        ],
      ),
    );
  }

  Widget _netImage(String url, {required double height}) {
    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: height,
          width: double.infinity,
          color: const Color(0xFFEDEDED),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: topColor),
          ),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFEDEDED),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey.shade400,
          size: 32,
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      child: Text(
        message,
        style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }
}

class HeadPicture extends StatelessWidget {
  const HeadPicture({Key? key, this.image}) : super(key: key);

  /// The stored `user_img` value (filename). `null`, empty, `"1"` or `"null"`
  /// all mean "no photo uploaded".
  final String? image;

  bool get _hasImage {
    final img = image;
    return img != null && img.isNotEmpty && img != "1" && img != "null";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
      },
      child: Stack(
        children: [
          CircleAvatar(
            maxRadius: 24,
            minRadius: 24,
            backgroundColor: bottomColor,
            // Static asset stays as the fallback layer; the network photo is
            // drawn on top and, if it fails to load, the asset shows through.
            backgroundImage:
                const AssetImage("assets/images/student_profile.jpeg"),
            foregroundImage: _hasImage
                ? NetworkImage("$user_img_uri$image")
                : null,
            onForegroundImageError: _hasImage ? (_, __) {} : null,
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              minRadius: 7,
              maxRadius: 7,
              backgroundColor: Color(0xFFFF3B30),
            ),
          ),
        ],
      ),
    );
  }
}
