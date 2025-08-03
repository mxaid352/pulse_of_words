import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screens/about_screen.dart';
import '../screens/disclaimer_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/home_screen.dart';

class POFDrawer extends StatelessWidget {
  const POFDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
                Color(0xFF1F4068),
                Color(0xFF5C258D),
                Color(0xFF4389A2),
              ]
                  : [
                Color(0xFFE0F7FA),
                Color(0xFFB2EBF2),
                Color(0xFF80DEEA),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.format_quote,
                        color: isDark ? Colors.white : Colors.black, size: 28),
                    SizedBox(height: 10),
                    Text(
                      'Pulse of Words',
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quote App',
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.brightness_6,
                    color: isDark ? Colors.white : Colors.black),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black),
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) => themeProvider.toggleTheme(val),
                ),
              ),
              Divider(color: isDark ? Colors.white38 : Colors.black),

              _buildTile(
                context,
                icon: Icons.home,
                color: isDark ? Colors.white70 : Colors.black,
                label: 'Home',
                screen: const HomeScreen(),
              ),
              _buildTile(
                context,
                icon: Icons.favorite,
                color: isDark ? Colors.white70 : Colors.black,
                label: 'Favourites',
                screen: const FavoritesScreen(),
              ),
              _buildTile(
                context,
                icon: Icons.warning,
                color: isDark ? Colors.white70 : Colors.black,
                label: 'Disclaimer',
                screen: const DisclaimerScreen(),
              ),
              _buildTile(
                context,
                icon: Icons.info_outline,
                color: isDark ? Colors.white70 : Colors.black,
                label: 'About Us',
                screen: const AboutScreen(),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '❤️ Made by Zaid',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String label,
        required Widget screen,
      }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: GoogleFonts.montserrat(fontSize: 13, color: color)),
      onTap: () {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        });
      },
    );
  }
}
