import { router } from '@kit.ArkUI';

class result_class {
  category : string
  image : ResourceStr
  accuracy : number

  constructor(category : string, image: ResourceStr, accuracy: number) {
    this.category = category
    this.image = image
    this.accuracy = accuracy
  }

}

@Entry
@Component
struct Result {
  @State feature: string = '';

  aboutToAppear(): void {
    if (router.getParams() !== undefined && router.getParams() !== null){
      let record = router.getParams() as Record<string, string>;
      if (record !== undefined && record !== null){
        this.feature = record['feature']
     }
   }
  }

  private results : Array<result_class> = [
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
    new result_class('类别一',$r('app.media.frog1'),0.998),
  ]

  build() {

    Column({space: 10}){
      Row({space: 3}){
        Button()
          .backgroundImage($r('app.media.back'))
          .backgroundColor('#FFFACD')
          .width(60)
          .height(60)
          .margin({left: -180})
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/Home'
            })
          })
        Text('返回')
          .height(60)
        Text('结果页面')
      }

      Row(){
        Text('特征依据:  ')
        Text(this.feature)
      }

        List({space: 10}){
          ForEach(this.results,
            (result: result_class)=>{
              ListItem(){
                Row({space: 20}){
                  Image(result.image)
                    .width('30%')

                  Column({space: 5}){
                    Text(result.category)
                    Text('准确率：'+result.accuracy)
                  }
                }
              }
            })
        }.width('100%')
        .padding({left:14, right:14})
        .borderRadius(8)
        .layoutWeight(1)


    }.width('100%')
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