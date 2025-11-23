import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Builder
export function ReminderListPageBuilder() {
  ReminderListPage()
}

@Builder
function buildText() {
  Column() {
    Text($r('app.string.active_reminders'))
      .fontSize(20)
      .fontWeight(FontWeight.Bolder)
      .fontColor(Color.White)
  }
}

export class Reminder {
  latestTitle: string = ''
  latestContent: string = ''
  latestStatus: string = ''

  constructor(latestTitle: string, latestContent: string, latestStatus: string) {
    this.latestTitle = latestTitle;
    this.latestContent = latestContent;
    this.latestStatus = latestStatus;
  }
}

@Entry
@Component
struct ReminderListPage {
  @State reminders: reminderAgentManager.ReminderRequest[] = []
  @State errorMsg: string = ''
  header: ComponentContent<Object> = new ComponentContent(this.getUIContext(), wrapBuilder(buildText));
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  pathStack: NavPathStack = new NavPathStack()
  @State params: Reminder = new Reminder('', '', '');

  aboutToAppear() {
    this.loadReminders();
  }

  build() {
    NavDestination() {
      ArcList({
        initialIndex: 0, header: this.header
      }) {
        ArcListItem() {
          if (this.params.latestStatus) {

            Text(this.context.resourceManager
              .getStringSync($r('app.string.last_action').id) + ' :' + this.params.latestStatus)
              .fontSize(13)
              .fontColor(Color.Red)
          }
        }
        .width('85%')
        .margin({ bottom: 10, top: 10 })

        ArcListItem() {
          if (this.params.latestTitle) {
            Text(this.context.resourceManager
              .getStringSync($r('app.string.last_reminder').id) + ' :' + this.params.latestTitle)
              .fontSize(13)
              .fontColor(Color.Yellow)
          }
        }
        .width('85%')
        .margin({ bottom: 10 })

        ArcListItem() {
          if (this.errorMsg) {
            Text(this.errorMsg).fontSize(10).fontColor(Color.Red)
          }
        }
        .width('85%')
        .margin({ bottom: 10 })

        ArcListItem() {
          if (this.reminders.length === 0 && this.errorMsg === '') {
            Text($r('app.string.no_active_reminders'))
              .fontSize(16)
              .fontColor(Color.Gray)
              .margin({ top: 20 })
          }
        }
        .width('85%')
        .margin({ bottom: 10 })

        ForEach(this.reminders, (reminder: reminderAgentManager.ReminderRequest, index: number) => {

          ArcListItem() {
            Column({ space: 4 }) {
              Text($r('app.string.pill', reminder.title))
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(Color.Black)

              Text(reminder.content)
                .fontSize(13)
                .fontColor(Color.Gray)
            }
            .padding(12)
            .backgroundColor(Color.White)
            .backgroundColor(Color.White)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor(Color.Red)
            .width('75%')
          }
          .width('85%')
          .margin({ bottom: 10 })
        }, (reminder: reminderAgentManager.ReminderRequest, index: number) => `${reminder}${index}`)
      }
      .height('100%')
      .width('100%')
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;

      const ids: number[] | undefined = this.pathStack.getIndexByName('ReminderListPage');

      if (Array.isArray(ids) && ids.length > 0) {
        const idx = ids[ids.length - 1];
        this.params = this.pathStack.getParamByIndex(idx) as Reminder;
      } else {
        console.warn('No index found for MailContent in NavPathStack');
      }

    })
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }

  private loadReminders() {
    reminderAgentManager.getValidReminders().then((list) => {
      this.reminders = list
    }).catch((err: BusinessError) => {
      this.errorMsg = `${$r('app.string.error_loading_reminders')} ${err.code}`
    })
  }
}
