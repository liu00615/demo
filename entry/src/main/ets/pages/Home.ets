import router from '@ohos.router'
import { promptAction, PromptAction } from '@kit.ArkUI'

import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import fileUri from '@ohos.file.fileuri';

@Entry
@Component

struct Home {

  @State menuSelected: boolean = true
  @State feature: string = '选择搜索特征'

  @State profileSrc: Resource = $r('app.media.defaultPic')
  @State profileImage: PixelMap = new Object() as PixelMap
  @State uri: string = ''
  @State flag: number = 0

  // 定义一个函数用于点击头像时拉起用户图库
  async pickProfile() {
    const photoSelectOptions = new picker.PhotoSelectOptions();
    // 设置选择的文件类型为图片类型
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    // 一次只能选择一张图片
    photoSelectOptions.maxSelectNumber = 1;
    const photoViewPicker = new picker.PhotoViewPicker();
    // 拉起图库，获取选中图片的uri,并将选择图片拷贝至应用沙箱指定位置
    photoViewPicker.select(photoSelectOptions)
      .then((photoSelectResult: picker.PhotoSelectResult) => {
        // 获取选中图片的uri
        let imageUri = photoSelectResult.photoUris[0];
        console.info('photoViewPicker.select to file succeed and uris are:' + imageUri);
        let context = getContext()
        //获取应用通用文件路径
        let filesDir = context.filesDir
        let fileName = "userProfileImage"
        //获取沙箱中文件路径
        let path = filesDir + "/" + fileName + "." + imageUri.split(".")[1]
        let file = fs.openSync(imageUri, fs.OpenMode.READ_ONLY)
        let file2 = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
        //完成图片拷贝
        fs.copyFileSync(file.fd, file2.fd)
        fs.closeSync(file.fd)
        fs.closeSync(file2.fd)
        //获取图片沙箱路径对应的uri
        this.uri = fileUri.getUriFromPath(path)
        //获取图片对应的PixelMap
        this.getPixelMap()
      })
      .catch((err: BusinessError) => {
        console.error('MinePage', `Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
      })
  }

  // 获取图片的pixelmap
  getPixelMap(){
    // 通过uri打开图片文件，获取文件fd
    let file = fs.openSync(this.uri, fs.OpenMode.READ_WRITE);
    const imageSourceApi = image.createImageSource(file.fd);
    // 将图片解码为pixelmap
    imageSourceApi.createPixelMap().then(pixelmap => {
      this.profileImage = pixelmap
      console.log('Succeeded in creating pixelmap object through image decoding parameters.');
    }).catch((err:BusinessError) => {
      console.log('Failed to create pixelmap object through image decoding parameters.');
    })
  }


  build() {
    Column({space: 80}){

      Flex({ direction:FlexDirection.Row,justifyContent:FlexAlign.Center}) {
        Text('基于内容的图像搜索系统')
          .fontSize(25)
          .fontColor('#ff110f0f')
          .margin({ top: 10 })
      }

      Column({space: 40}){
        Image($r('app.media.mianpic'))
          .width(80)

        Row({space: 20}){
          Column(){
            Button({ type: ButtonType.Circle, stateEffect: true }){
              Image($r('app.media.camera'))
            }.width(108)
            .height(108)
            .backgroundColor('#FFFACD').onClick(()=>{
              promptAction.showToast(
                {
                  message: '相机按钮被点击了',
                  duration: 1000,
                  bottom: 200
                }
              )
            })
            Text('拍照选择')
              .height(40)
          }

          Column({space: 5}){
            Image(this.profileImage)
              .backgroundColor('#FFFACD')
              .alt($r('app.media.defaultPic'))
              .width(108)
              .height(108)
              .objectFit(ImageFit.Cover)
              .borderRadius(54)
              .onClick(() => {
                this.pickProfile()
                promptAction.showToast(
                  {
                    message: '相册按钮被点击了',
                    duration: 1000,
                    bottom: 200
                  }
                )
              })
            Text('相册选择')
              .height(40)
          }

        }

        Button(this.feature)
          .fontColor('#2F4F4F')
          .bindMenu([
            {
              value: '颜色特征',
              action: ()=>{ this.feature = '颜色' }
            },
            {
              value: '纹理特征',
              action: ()=>{ this.feature = '纹理' }
            },
            {
              value: '形状特征',
              action: ()=>{ this.feature = '形状' }
            },
            {
              value: '关键字特征',
              action: ()=>{ this.feature = '关键字' }
            },
            {
              value: '深度学习',
              action: ()=>{ this.feature = '深度学习' }
            }
          ]).width(180).backgroundColor('#8DEEEE')

        Button('开始搜索')
          .fontColor('#2F4F4F')
          .backgroundColor('#8DEEEE')
          .width(180)
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/Result',
              params: {
                feature: this.feature
              }
            })
          })
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
