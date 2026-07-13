import 'dart:convert';
import 'package:mainsupabase_projuct/features/dashboard/models/ai_insightmodel.dart';
import 'package:mainsupabase_projuct/features/dashboard/models/dashboardata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AiDashboardService {
  final _supabase = Supabase.instance.client;

  Future<AIInsight> generateInsight(
    DashboardData dashboard,
  ) async {
    try {
      final response = await _supabase.functions.invoke(
        'dashboard-ai',
        body: {
          'id': dashboard.id,
          'userId': dashboard.userId,
          'overallClarity': dashboard.overallClarity,
          'mentalStage': dashboard.mentalStage,
          'stressScore': dashboard.stressScore,
          'focusScore': dashboard.focusScore,
          'emotionScore': dashboard.emotionScore,
          'productivityScore': dashboard.productivityScore,
          'assessmentNumber': dashboard.assessmentNumber,
          'assessmentDate': dashboard.assessmentDate.toIso8601String(),
        },
      );

      if (response.data == null) {
        throw Exception('Failed to generate AI insight.');
      }

      return AIInsight.fromJson(response.data);
    } on FunctionException catch (e) {
      String message = 'An error occurred while communicating with the AI service.';
      if (e.details != null) {
        final details = e.details;
        if (details is Map) {
          final err = details['error'];
          if (err != null) {
            if (err is String) {
              String tempMessage = err;
              try {
                final decoded = jsonDecode(err);
                if (decoded is Map) {
                  if (decoded.containsKey('error')) {
                    final innerErr = decoded['error'];
                    if (innerErr is Map && innerErr.containsKey('message')) {
                      tempMessage = innerErr['message']?.toString() ?? tempMessage;
                    } else if (innerErr is String) {
                      tempMessage = innerErr;
                    }
                  } else if (decoded.containsKey('message')) {
                    tempMessage = decoded['message']?.toString() ?? tempMessage;
                  }
                }
              } catch (_) {}
              message = tempMessage;
            } else if (err is Map) {
              if (err.containsKey('message')) {
                message = err['message']?.toString() ?? message;
              } else if (err.containsKey('error')) {
                final innerErr = err['error'];
                if (innerErr is Map && innerErr.containsKey('message')) {
                  message = innerErr['message']?.toString() ?? message;
                } else if (innerErr is String) {
                  message = innerErr;
                }
              } else {
                message = err.toString();
              }
            } else {
              message = err.toString();
            }
          }
        } else {
          message = details.toString();
        }
      }

      // Check if message is quota error
      final lowerMessage = message.toLowerCase();
      if (lowerMessage.contains('quota') ||
          lowerMessage.contains('limit') ||
          lowerMessage.contains('429') ||
          lowerMessage.contains('resource_exhausted')) {
        message = 'AI service quota exceeded. Please check your Gemini API plan or try again later.';
      }

      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}