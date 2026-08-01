// import 'package:get/get.dart';
// import '../data/api_repository.dart';
// import '../data/models/task_model.dart';
// import '../modules/inbox/controllers/inbox_controller.dart';
// import '../modules/projects/controllers/projects_controller.dart';

// class TaskService extends GetxService {
//   void toggleTaskCompletion(String taskId, bool isCompleted) {
//     // 1. Check Inbox
//     if (Get.isRegistered<InboxController>()) {
//       final inboxController = Get.find<InboxController>();
//       final index = inboxController.tasks.indexWhere((t) => t.id == taskId);
//       if (index != -1) {
//         inboxController.toggleTaskCompletion(taskId, isCompleted);
//         return;
//       }
//     }

//     // 2. Check Projects
//     if (Get.isRegistered<ProjectsController>()) {
//       final projectsController = Get.find<ProjectsController>();
//       for (int i = 0; i < projectsController.projects.length; i++) {
//         final project = projectsController.projects[i];
//         final updatedPhases = List<Phase>.from(project.phases);
//         bool found = false;

//         for (int j = 0; j < updatedPhases.length; j++) {
//           final phase = updatedPhases[j];
//           final updatedTasks = _updateTaskInList(phase.tasks, taskId, isCompleted);
          
//           if (updatedTasks != null) {
//             updatedPhases[j] = phase.copyWith(tasks: updatedTasks);
//             found = true;
//             break;
//           }
//         }

//         if (found) {
//           projectsController.projects[i] = project.copyWith(phases: updatedPhases);
//           projectsController.projects.refresh();
//           if (int.tryParse(taskId) != null) {
//             ApiRepository.update(
//               resource: 'tasks',
//               id: taskId,
//               body: {'status': isCompleted ? 'Done' : 'In Progress'},
//             );
//           }
//           return;
//         }
//       }
//     }
//   }

//   List<Task>? _updateTaskInList(List<Task> tasks, String taskId, bool isCompleted) {
//     final taskIndex = tasks.indexWhere((t) => t.id == taskId);
    
//     if (taskIndex != -1) {
//       final updatedTasks = List<Task>.from(tasks);
//       final task = tasks[taskIndex];
//       updatedTasks[taskIndex] = task.copyWith(
//         isCompleted: isCompleted,
//         status: isCompleted ? 'Done' : 'In Progress',
//       );
//       return updatedTasks;
//     }

//     // Check subtasks recursively
//     for (int i = 0; i < tasks.length; i++) {
//       final task = tasks[i];
//       if (task.subtasks.isNotEmpty) {
//         final updatedSubtasks = _updateTaskInList(task.subtasks, taskId, isCompleted);
//         if (updatedSubtasks != null) {
//           final updatedTasks = List<Task>.from(tasks);
//           updatedTasks[i] = task.copyWith(subtasks: updatedSubtasks);
//           return updatedTasks;
//         }
//       }
//     }

//     return null;
//   }

//   void updateTaskStatus(String taskId, String newStatus) {
//     final bool isCompleted =
//         newStatus == 'Completed' || newStatus == 'Done';
//     toggleTaskCompletion(taskId, isCompleted);
//   }
// }

