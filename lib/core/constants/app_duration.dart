class AppDuration {
  static const welcomeFloat = Duration(milliseconds: 6000);
  static const welcomeGlow = Duration(milliseconds: 4000);
  static const welcomeFade = Duration(milliseconds: 800);
  static const googleButtonAnim = Duration(milliseconds: 200);
  
  static const loginOrb = Duration(seconds: 6);
  static const loginEntrance = Duration(milliseconds: 1200);
  
  static const otpEntrance = Duration(milliseconds: 900);
  static const otpPulse = Duration(seconds: 3);
  static const otpVerifyPress = Duration(milliseconds: 120);
  static const otpResendPress = Duration(milliseconds: 100);
  
  static const splashDelay = Duration(seconds: 4);
  static const splashEntrance = Duration(seconds: 4); // animationController duration
  
  static const homeOrb = Duration(seconds: 8);
  static const homeEntrance = Duration(milliseconds: 1000);
  
  static const thoughtsEntrance = Duration(milliseconds: 800);
  
  static const coachScroll = Duration(milliseconds: 300);
  static const coachResponseDelay = Duration(milliseconds: 1500);
  static const coachDotAnim = Duration(milliseconds: 600);
  
  static const insightEntrance = Duration(milliseconds: 1500);

  // Inactivity session configurations (for demo: 1 min threshold, 15 sec warnings)
  static const inactivityTimeout = Duration(minutes: 1);
  static const countdownDuration = Duration(seconds: 15);
}
