import { BusinessError } from '@kit.BasicServicesKit';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { vibrator } from '@kit.SensorServiceKit';
import { common } from '@kit.AbilityKit';

@ObservedV2
export class MedicineViewModel {
  @Trace reminderStatus : string = 'Ready';
  @Trace notificationId : number = 1000
  @Trace reminderId: number = -1;

   async createReminder( tempReminderTime: string, tempReminderTitle: string, tempReminderContent: string, context: common.UIAbilityContext) {
    const timeInSeconds = parseInt(tempReminderTime);
    if (isNaN(timeInSeconds) || timeInSeconds <= 0) {
      this.reminderStatus = context.resourceManager
        .getStringSync($r('app.string.invalid_time_in_seconds').id)
    }

    if (!tempReminderTitle || !tempReminderContent) {
      this.reminderStatus = context.resourceManager
        .getStringSync($r('app.string.invalid_time_in_seconds').id)
    }

    let reminder: reminderAgentManager.ReminderRequestTimer = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER,
      triggerTimeInSeconds: timeInSeconds,
      title: tempReminderTitle,
      content: tempReminderContent,
      notificationId: ++this.notificationId
    };

    reminderAgentManager.publishReminder(reminder).then((id: number) => {
      this.reminderId = id;
      this.reminderStatus = context.resourceManager
        .getStringSync($r('app.string.reminder_created').id)
      vibrator.startVibration({ type: 'time', duration: 800 }, { id: 1, usage: 'alarm' });
    }).catch((err: BusinessError) => {
      this.reminderStatus = `${$r('app.string.failed')} ${err.code} - ${err.message}`;
    });
  }
}