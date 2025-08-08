import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, router, ComponentContent } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Builder
function buildText() {
  Column() {
    Text($r('app.string.active_reminders'))
      .fontSize(20)
      .fontWeight(FontWeight.Bolder)
      .fontColor(Color.White)
  }
}

@Entry
@Component
struct ReminderListPage {
  @State reminders: reminderAgentManager.ReminderRequest[] = []
  @State errorMsg: string = ''
  @State latestTitle: string = ''
  @State latestContent: string = ''
  @State latestStatus: string = ''
  header: ComponentContent<Object> = new ComponentContent(this.getUIContext(), wrapBuilder(buildText));
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.latestTitle = params.latestTitle;
    this.latestContent = params.latestContent;
    this.latestStatus = params.latestStatus;
    this.loadReminders();
  }

  build() {
        ArcList({ initialIndex: 0, header: this.header
        }) {
          ArcListItem() {
            if (this.latestStatus) {

              Text(this.context.resourceManager
                .getStringSync($r('app.string.last_action').id) +' :'+ this.latestStatus)
                .fontSize(13)
                .fontColor(Color.Red)
            }
          }
          .width('85%')
          .margin({bottom: 10, top: 10})

          ArcListItem() {
            if (this.latestTitle) {
              Text(this.context.resourceManager
                .getStringSync($r('app.string.last_reminder').id) +' :'+ this.latestTitle)
                .fontSize(13)
                .fontColor(Color.Yellow)
            }
          }
          .width('85%')
          .margin({bottom: 10})

          ArcListItem() {
            if (this.errorMsg) {
              Text(this.errorMsg).fontSize(10).fontColor(Color.Red)
            }
          }
          .width('85%')
          .margin({bottom: 10})

          ArcListItem() {
            if (this.reminders.length === 0 && this.errorMsg === '') {
              Text($r('app.string.no_active_reminders'))
                .fontSize(16)
                .fontColor(Color.Gray)
                .margin({ top: 20 })
            }
          }
          .width('85%')
          .margin({bottom: 10})

          ForEach(this.reminders, (reminder: reminderAgentManager.ReminderRequest, index: number) => {

            ArcListItem(){
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
              .borderRadius(10)
              .borderWidth(1)
              .borderColor(Color.Red)
              .width('75%')
            }
            .width('85%')
            .margin({bottom: 10})
          })
        }
        .height('100%')
        .width('100%')
  }

  private loadReminders() {
    reminderAgentManager.getValidReminders().then((list) => {
      this.reminders = list
    }).catch((err: BusinessError) => {
      this.errorMsg = `${$r('app.string.error_loading_reminders')} ${err.code}`
    })
  }
}
