import { common } from '@kit.AbilityKit'
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { requestNotificationPermission } from '../utils/RequestPermission'
import { MedicineInput } from '../view/MedicineInput'
import { MedicineViewModel } from '../viewmodel/MedicineViewModel'
import { Reminder } from './ReminderListPage'
@Builder
function buildText() {
  Column() {
    Text($r('app.string.pill_dailydose'))
      .fontSize(26)
      .fontWeight(FontWeight.Bold)
  }
}

@Entry
@Component
struct MainPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private reminderId: number = -1;
  @State reminderStatus: string | Resource = $r('app.string.ready');
  @State reminderTitle: string = '';
  @State reminderContent: string = '';
  @State reminderTime: string = '';
  @State tempReminderTitle: string = '';
  @State tempReminderContent: string = '';
  @State tempReminderTime: string = '';
  @State isTime: boolean = false;
  @State notificationId: number = 1000;
  header: ComponentContent<Object> = new ComponentContent(this.getUIContext(), wrapBuilder(buildText));
  medicineViewModel: MedicineViewModel = new MedicineViewModel();
  pathStack: NavPathStack = new NavPathStack()

  aboutToAppear() {
    requestNotificationPermission(this.context)
  }

  build() {
    Navigation(this.pathStack) {
      ArcList({
        initialIndex: 0, header: this.header
      }) {
        ArcListItem() {
          MedicineInput({ reminderAnyText: this.reminderTitle, inputName: $r('app.string.medicine'), isTime: false })
        }
        .margin({ bottom: 10 })

        ArcListItem() {
          MedicineInput({ reminderAnyText: this.reminderContent, inputName: $r('app.string.message'), isTime: false })
        }
        .margin({ bottom: 10 })

        ArcListItem() {
          MedicineInput({ reminderAnyText: this.reminderTime, inputName: $r('app.string.time_seconds'), isTime: true })
        }
        .margin({ bottom: 10 })

        ArcListItem() {
          Button($r('app.string.save_reminder'))
            .onClick(() => {
              this.resetAndBackupReminderFields()
              this.medicineViewModel
                .createReminder(this.tempReminderTime, this.tempReminderTitle, this.tempReminderContent, this.context)
            })
            .buttonsStyle()
        }
        .margin({ bottom: 10 })

        ArcListItem() {
          Button($r('app.string.view_reminder_list'))
            .onClick(() => {
              this.pathStack.pushPathByName(
                'ReminderListPage',
                new Reminder(this.tempReminderTitle, this.tempReminderContent, this.medicineViewModel.reminderStatus)
              )
            })
            .buttonsStyle()
        }
        .margin({ bottom: 10 })

        ArcListItem() {
          Text(this.medicineViewModel.reminderStatus)
            .fontSize(13)
            .fontColor(Color.Gray)
            .margin({ top: 2 })
        }
        .margin({ bottom: 10 })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }

  resetAndBackupReminderFields() {
    this.tempReminderTitle = this.reminderTitle;
    this.tempReminderContent = this.reminderContent;
    this.tempReminderTime = this.reminderTime;

    this.reminderTitle = '';
    this.reminderContent = '';
    this.reminderTime = '';
  }
}

@Extend(Button)
function buttonsStyle() {
  .width('85%')
  .height(32)
  .fontSize(13)
  .borderRadius(8)
  .backgroundColor(Color.Red)
}