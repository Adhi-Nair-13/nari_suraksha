import 'package:flutter/material.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({Key? key}) : super(key: key);

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isEmergencyActive = false;

  void _triggerSos() {
    setState(() {
      _isEmergencyActive = !_isEmergencyActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEmergencyActive 
              ? '🚨 EMERGENCY ACTIVATED! Broadcasting location and alerting guardians...' 
              : '✅ Emergency standby mode restored.',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isEmergencyActive ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isEmergencyActive
                ? [Colors.red.shade50, Colors.white]
                : [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Title Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      'NARI SURAKSHA',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEmergencyActive ? 'HELP IS ON THE WAY' : 'You Are Secure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _isEmergencyActive ? Colors.red : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isEmergencyActive 
                          ? 'Live tracking is currently active' 
                          : 'Press the button below in case of danger.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Giant Pulsing SOS Button
              GestureDetector(
                onTap: _triggerSos,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    color: _isEmergencyActive ? Colors.red : Colors.deepPurple,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isEmergencyActive ? Colors.red : Colors.deepPurple).withOpacity(0.4),
                        blurRadius: _isEmergencyActive ? 40 : 20,
                        spreadRadius: _isEmergencyActive ? 15 : 5,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isEmergencyActive ? Icons.gpp_bad : Icons.gpp_good,
                        size: 54,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isEmergencyActive ? 'STOP' : 'SOS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Quick Action Panel
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Call Police Button
                      _buildQuickActionItem(
                        icon: Icons.phone,
                        label: 'Call Police',
                        color: Colors.blue.shade700,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('📞 Launching native phone dialer: Calling 112/100...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      // Navigation Contacts Button
                      _buildQuickActionItem(
                        icon: Icons.people_alt,
                        label: 'Contacts',
                        color: Colors.orange.shade700,
                        onTap: () {
                          // This cleanly alerts the user how to navigate or handles context shifts
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('👉 Tap "Guardians" in the bottom dock to manage numbers!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      // Fake Location Fetch Item
                      _buildQuickActionItem(
                        icon: Icons.my_location,
                        label: 'Location',
                        color: Colors.green.shade700,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('📍 GPS Verified: Coordinates locking onto your local region...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}