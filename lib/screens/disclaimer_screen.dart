import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulse_of_words/widgets/drawer.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Disclaimer'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const POFDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.8)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.blueGrey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📌 Pulse of Words Disclaimer',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.tealAccent
                              : Colors.indigo.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildParagraph(
                        context,
                        'Pulse of Words is intended to inspire and motivate through curated quotes. While we strive for accuracy, the content may not always reflect verified sources.',
                      ),
                      const SizedBox(height: 16),
                      _buildParagraph(
                        context,
                        'We do not guarantee the correctness, attribution, or authenticity of the quotes. Use this app for personal inspiration, not academic reference.',
                      ),
                      const SizedBox(height: 16),
                      _buildParagraph(
                        context,
                        'By using Pulse of Words, you agree that the developer holds no responsibility for any misinterpretation or reliance on the content presented.',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '🙏 Thank you for being part of Pulse of Words!',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.tealAccent : Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Made by Muhammad Zaid',
                  style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 16,
        height: 1.6,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }
}
