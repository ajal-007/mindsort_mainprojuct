import '../../../core/constants/app_text.dart';

class AiService {
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'coach',
      'text': AppText.coachHello,
      'time': '10:00 AM'
    },
  ];

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    return List.from(_messages);
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    _messages.add(message);
  }

  Future<String> simulateCoachResponse(String userText) async {
    String response = "That sounds fascinating. Let's break that down into three actionable steps. How can we simplify the first hurdle you foresee?";
    
    if (userText.toLowerCase().contains('day')) {
      response = "To structure your day, let's start with your top 3 non-negotiables. What are the three absolute priorities you need to complete today?";
    } else if (userText.toLowerCase().contains('brainstorm') || userText.toLowerCase().contains('project')) {
      response = "Exciting! A new project is a blank canvas. What is the core problem this project solves? Understanding that will define everything else.";
    } else if (userText.toLowerCase().contains('focus') || userText.toLowerCase().contains('habit')) {
      response = "Habit formation starts with friction reduction. To build focus habits, identify one environmental trigger you can remove. What distracts you first?";
    } else if (userText.toLowerCase().contains('stress')) {
      response = "Take a slow deep breath. Let's do a brain dump. Write down everything that is bothering you in a list, without formatting. Let's empty the tank first.";
    }

    return response;
  }
}
