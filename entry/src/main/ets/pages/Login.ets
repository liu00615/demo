import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component

struct Login {
  @State message:string = '登录页面'
  @State username:string = ''
  @State password:string = ''


  build() {
    Column() {
      Flex({ direction:FlexDirection.Row,justifyContent:FlexAlign.Center}) {
        Text('基于内容的图像搜索系统')
          .fontSize(25)
          .fontColor('#ff110f0f')
          .margin({ top: 10 })
      }
      .height(50)
      .width('100%')
      .linearGradient( {
        direction:GradientDirection.Bottom,
        repeating:false,
        colors:[[0xC1FFC1,1], [0xFFFACD,0.0]]
      })
      Column() {
        TextInput({placeholder: '用户名'})
          .margin({ top:20 })
          .width(300)
          .height(50)
          .onChange((value : string)=>{
            this.username =  value
          })
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .onChange((value:string) => {
            this.password = value
          })
        TextInput({ placeholder: '密码'})
          .type(InputType.Password)
          .margin({ top:10 })
          .width(300)
          .height(50)
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .onChange((value:string) => {
            this.password = value
          })

      }
      .padding(40)

      Button('登录')
        .width(150)
        .height(40)
        .fontColor('#EEE9E9')
        .backgroundColor('#008B8B')

        .onClick(() => {
          if(this.username==null || this.password==null){
            promptAction.showToast(
              {
                message: '用户名或密码不能为空'
              }
            )
          }

            router.replaceUrl(
              {
                url : 'pages/Home',
              }
            )

        })

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center}) {
        Row() {
          Text('没有注册过用户？')
          Text('请先注册')
            .fontColor('gray')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Register'
              })
            })
        }
      }
    }

    .width('100%')
    .height('100%')
    .sweepGradient({
      center: ['50%', '50%'],
      start: 0,
      end: 359,
      rotation: 45, // 旋转角度
      repeating: true, // 渐变颜色是否重复
      colors: [[0xC1FFC1, 0.0], [0xFFFACD, 1]]
    })
  }
}