import 'package:get/get.dart';

class AIService extends GetxService {
  Future<List<String>> suggestTasks(String context) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock suggestions based on context
    if (context.toLowerCase().contains('move-out')) {
      return [
        'Final cleaning inspection',
        'Verify key return status',
        'Send security deposit refund',
      ];
    }
    return [
      'Check email for maintenance requests',
      'Follow up on late rent payments',
      'Schedule quarterly inspection for Unit 102',
    ];
  }

  Future<List<String>> suggestWorkflowSteps(String workflowName) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      'Initial Assessment',
      'Notify Stakeholders',
      'Execute Primary Tasks',
      'Review & Verify',
      'Final Documentation',
    ];
  }

  Future<String> summarizeWorkflow(String name, List<String> steps) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'This workflow focuses on "$name" with ${steps.length} key steps to ensure compliance and efficiency.';
  }
}

