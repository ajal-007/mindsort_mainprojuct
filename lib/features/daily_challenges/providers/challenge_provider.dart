import 'package:flutter/material.dart';
import '../models/challenge_node_model.dart';

class ChallengeProvider extends ChangeNotifier {
  final int _completedDays = 12;
  final int _totalDays = 30;
  final int _currentStreak = 12;
  final int _nextRewardDay = 15;

  final List<ChallengeNodeModel> _challenges = [
    ChallengeNodeModel(
      dayNumber: 1,
      title: 'Cerebral Entry',
      status: ChallengeStatus.completed,
      reward: '+15 XP',
      isMilestone: false,
      challengeType: 'Brain Dump',
      stars: 3,
      description: 'Record your first thoughts in the dump.',
    ),
    ChallengeNodeModel(
      dayNumber: 2,
      title: 'Mental Clarity',
      status: ChallengeStatus.completed,
      reward: '+20 XP',
      isMilestone: false,
      challengeType: 'Categorization',
      stars: 3,
      description: 'Categorize your captured thoughts.',
    ),
    ChallengeNodeModel(
      dayNumber: 3,
      title: 'Flow Alignment',
      status: ChallengeStatus.completed,
      reward: '+20 XP',
      isMilestone: false,
      challengeType: 'AI Session',
      stars: 3,
      description: 'Consult the AI Coach for action steps.',
    ),
    ChallengeNodeModel(
      dayNumber: 4,
      title: 'Cerebral Sync',
      status: ChallengeStatus.completed,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Cloud Config',
      stars: 3,
      description: 'Configure Cloud Sync on your profile.',
    ),
    ChallengeNodeModel(
      dayNumber: 5,
      title: 'Deep Reflection',
      status: ChallengeStatus.completed,
      reward: '+20 XP',
      isMilestone: false,
      challengeType: 'Graph Review',
      stars: 3,
      description: 'Review your focus levels graph.',
    ),
    ChallengeNodeModel(
      dayNumber: 6,
      title: 'Brain Dump',
      status: ChallengeStatus.today,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Brain Dump',
      stars: 0,
      description: 'Write everything on your mind for 5 minutes.',
    ),
    ChallengeNodeModel(
      dayNumber: 7,
      title: 'First Milestone',
      status: ChallengeStatus.milestone,
      reward: '+50 XP',
      isMilestone: true,
      challengeType: 'Streak Check',
      stars: 0,
      description: 'Maintain a 7-day streak.',
    ),
    ChallengeNodeModel(
      dayNumber: 8,
      title: 'Cerebral Mapping',
      status: ChallengeStatus.locked,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Logs Check',
      stars: 0,
      description: 'Unlock 8 logs.',
    ),
    ChallengeNodeModel(
      dayNumber: 9,
      title: 'Cognitive Flow',
      status: ChallengeStatus.locked,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Logs Check',
      stars: 0,
      description: 'Unlock 9 logs.',
    ),
    ChallengeNodeModel(
      dayNumber: 10,
      title: 'Focus Shift',
      status: ChallengeStatus.locked,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Logs Check',
      stars: 0,
      description: 'Unlock 10 logs.',
    ),
    ChallengeNodeModel(
      dayNumber: 11,
      title: 'Task Cleared',
      status: ChallengeStatus.locked,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Logs Check',
      stars: 0,
      description: 'Unlock 11 logs.',
    ),
    ChallengeNodeModel(
      dayNumber: 12,
      title: 'Intermediate Peak',
      status: ChallengeStatus.milestone,
      reward: '+50 XP',
      isMilestone: true,
      challengeType: 'Streak Check',
      stars: 0,
      description: 'Maintain a 12-day streak.',
    ),
    ChallengeNodeModel(
      dayNumber: 13,
      title: 'Cerebral Rest',
      status: ChallengeStatus.locked,
      reward: '+25 XP',
      isMilestone: false,
      challengeType: 'Logs Check',
      stars: 0,
      description: 'Unlock 13 logs.',
    ),
  ];

  int get completedDays => _completedDays;
  int get totalDays => _totalDays;
  int get currentStreak => _currentStreak;
  int get nextRewardDay => _nextRewardDay;
  List<ChallengeNodeModel> get challenges => _challenges;

  ChallengeNodeModel get todayChallenge => _challenges.firstWhere(
        (node) => node.status == ChallengeStatus.today,
        orElse: () => _challenges[5],
      );

  void completeChallenge(int dayNumber) {
    // TODO: Implement challenge completion logic
    notifyListeners();
  }
}
