import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';

export function requestNotificationPermission(context: common.UIAbilityContext) {
  notificationManager.requestEnableNotification(context).then(() => {
    console.info('Notification permission granted');
  }).catch((err: Error) => {
    console.error('Permission request failed: ' + JSON.stringify(err));
  });
}