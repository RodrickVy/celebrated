import 'package:bremind/support/models/dev.progress/dev.progress.category.dart';
import 'package:bremind/support/models/dev.progress/dev.progress.dart';
import 'package:bremind/support/models/dev.progress/dev.task.dart';
import 'package:bremind/support/models/dev.progress/task.progress.dart';
import 'package:get/get.dart';

class DevProgressController extends GetxController {
  final DevProgress devProgress = DevProgress(
      title: "Celebrated 0.0.1",
      image:  "assets/intro/plan.png",
      description:
          "This is the first early version of the app, with the least features, and is currently under testing & development.",
      categories: [
        DevProgressCategory(
          name: "Platforms",
          description: "Planning to launch on web,IOS, Android and Linux",
          devTasks: [
            DevTask(description: "App available on web", progress: TaskProgress.done),
            DevTask(description: "Launch on google play-store", progress: TaskProgress.doing),
            DevTask(description: "Launch on IOS app store", progress: TaskProgress.backlogged),
            DevTask(description: "Launch on Linux as a snapcraft and flatpack", progress: TaskProgress.backlogged),
          ],
        ),
        DevProgressCategory(
          name: "Reminder Features",
          description: "features that make remembering and tracking your loved one's birthdays easier.",
          devTasks: [
            DevTask(description: "Organize birthdays into different lists ", progress: TaskProgress.done),
            DevTask(description: "Invite others to add their birthday to your list", progress: TaskProgress.done),
            DevTask(description: "Share a reminder link to others, to subscribe to the list of birthdays notifications", progress: TaskProgress.doing),
            DevTask(description: "Create a birthday from contacts lists", progress: TaskProgress.backlogged),
            DevTask(description: "Can import birthdays from Google calendar ", progress: TaskProgress.backlogged),
            DevTask(description: "List notifications settings", progress: TaskProgress.backlogged),
            DevTask(description: "Sync list to google calendar ", progress: TaskProgress.backlogged),
            DevTask(description: "Notifications Settings  ", progress: TaskProgress.backlogged),
          ],
        ),
        DevProgressCategory(
          name: "Plan",
          description: "Plan birthdays stress-free to focus on what really matters!",
          devTasks: [
            DevTask(description: "Birthday guests invite links  ", progress: TaskProgress.backlogged),
            DevTask(description: "Create a birthday group cards ", progress: TaskProgress.backlogged),
            DevTask(description: "Create and share virtual gifts ", progress: TaskProgress.backlogged),
          ],
        ),
        DevProgressCategory(
          name: "Celebrate",
          description: "Plan birthdays stress-free to focus on what really matters!",
          devTasks: [
            DevTask(description: "Virtual Candles", progress: TaskProgress.backlogged),
          ],
        )
      ]);
}
