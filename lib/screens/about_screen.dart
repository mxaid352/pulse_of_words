import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("❌ Could not launch $url");
    }
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required String url,
    required String label,
    required Color textColor,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'About',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const POFDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
              Color(0xFF1F4068),
              Color(0xFF5C258D),
              Color(0xFF4389A2),
            ]
                : const [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kToolbarHeight + 16),
              Text(
                '📚 About Pulse of Words',
                style: textTheme.titleLarge?.copyWith(color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Pulse of Words is a beautiful and inspiring quotes app built using Flutter. '
                    'It delivers motivational quotes to brighten your day, and allows you to save your favorites, '
                    'explore by categories, and share them with friends.\n\n'
                    '✨ Features:\n'
                    '• View a wide range of motivational quotes\n'
                    '• Favorite & unfavorite quotes\n'
                    '• Clean and elegant design\n'
                    '• Offline support & persistent storage\n'
                    '• Smooth animations and dark theme',
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
              ),
              const SizedBox(height: 24),
              Text(
                '👨‍💻 About the Developer',
                style: textTheme.titleLarge?.copyWith(color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Developed by Muhammad Zaid, a passionate Flutter and Python developer from Pakistan. '
                    'This app is part of his learning journey to build meaningful and beautiful mobile experiences.',
                style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
              ),
              const Divider(color: Colors.white24),
              const SizedBox(height: 24),
              Text(
                '📬 Connect with Me',
                style: textTheme.headlineSmall?.copyWith(color: textColor),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSocialIcon(
                    icon: Icons.email,
                    color: Colors.redAccent,
                    url: 'mailto:mxaid352@gmail.com',
                    label: 'Email',
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    color: Colors.blue,
                    url: 'https://www.linkedin.com/in/muhammad-zaid-6a6109182',
                    label: 'LinkedIn',
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialIcon(
                    icon: FontAwesomeIcons.github,
                    color: Colors.white,
                    url: 'https://github.com/mxaid352',
                    label: 'GitHub',
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialIcon(
                    icon: FontAwesomeIcons.instagram,
                    color: Colors.purple,
                    url: 'https://instagram.com/im_zaid897',
                    label: 'Instagram',
                    textColor: textColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
