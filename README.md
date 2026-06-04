# 云游助手 - AI旅行规划助手

一款基于Flutter开发的跨平台AI旅行规划应用，采用Material Design 3设计语言，支持亮色/深色模式切换，为用户提供智能化的旅行行程规划服务。

## 📱 功能特性

### 核心页面

1. **启动登录页**
   - 支持游客一键登录
   - 支持账号模拟登录
   - 本地存储登录状态，下次打开直接进首页

2. **首页**
   - 顶部搜索框：支持输入城市名称搜索
   - Banner轮播：展示热门推荐
   - 快捷功能入口：一键生成行程、热门城市选择
   - 热门目的地卡片网格：固定图片，点击跳转生成页

3. **行程生成页**
   - 完整表单：目的地、天数、预算、兴趣、人群
   - AI动态生成：根据参数生成对应行程
   - 表单数据回填：支持从偏好设置读取默认值

4. **行程详情页**
   - 行程概览：目的地、天数、预算
   - 每日行程时间线：展示每日景点安排
   - 完整功能：分享、导出、编辑、收藏

5. **个人中心**
   - 用户信息卡片
   - 动态统计数据：足迹、收藏、优惠券
   - 历史记录Tab：读取Hive存储的历史行程
   - 我的收藏Tab：展示收藏的行程
   - 偏好设置入口
   - 关于应用入口
   - 退出登录功能

## 🛠️ 技术栈

- **Flutter 3.x** - 跨平台UI框架
- **Provider** - 状态管理
- **Hive** - 本地数据持久化
- **Dio** - 网络请求
- **Material Design 3** - 设计语言
- **share_plus** - 分享功能
- **cached_network_image** - 图片缓存

## 📂 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型层
│   ├── user_provider.dart               # 用户状态管理
│   ├── theme_provider.dart              # 主题状态管理
│   ├── travel_plan_provider.dart        # 行程状态管理
│   ├── user_preferences_provider.dart   # 用户偏好状态管理
│   ├── travel_plan.dart                  # 行程数据模型
│   ├── user_preferences.dart            # 用户偏好数据模型
│   └── ...
├── pages/                    # 页面层
│   ├── login_page.dart       # 登录页
│   ├── home_page.dart        # 首页
│   ├── create_page.dart      # 行程生成页
│   ├── detail_page.dart      # 行程详情页
│   ├── mine_page.dart        # 个人中心页
│   ├── preferences_page.dart # 偏好设置页
│   └── about_page.dart       # 关于应用页
└── services/                 # 服务层
    ├── hive_service.dart     # Hive存储服务
    └── ai_service.dart       # AI模拟服务
```

## 🚀 运行步骤

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 运行应用

#### Web版本（推荐）
```bash
flutter run -d chrome
```

#### Android设备
```bash
flutter run -d android
```

#### Android APK构建
```bash
flutter build apk --release
```

APK文件位置：`build/app/outputs/flutter-apk/app-release.apk`

## 🌐 鸿蒙NEXT适配方案

### 方案一：Flutter鸿蒙编译工具

1. 安装Flutter鸿蒙编译工具
```bash
flutter doctor
```

2. 使用鸿蒙构建命令
```bash
flutter build hap
```

3. 生成鸿蒙应用安装包

### 方案二：ArkTS核心页面示例

对于需要原生鸿蒙体验的场景，可将核心页面使用ArkTS/ArkUI重写：

#### 首页示例（ArkTS）

```dart
// ArkTS实现 - 首页结构
@Entry
@Component
struct Index {
  @State message: string = '欢迎使用云游助手'

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      // 搜索框
      TextInput({ placeholder: '搜索目的地' })
        .width('100%')
        .height(40)

      // 快捷功能
      Row() {
        Button('一键生成').onClick(() => {})
        Button('热门城市').onClick(() => {})
      }
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}
```

#### 行程生成页示例（ArkTS）

```dart
// ArkTS实现 - 行程生成页
@Entry
@Component
struct CreatePage {
  @State destination: string = ''
  @State days: number = 3
  @State budget: string = '舒适'

  build() {
    Column() {
      Text('目的地')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)

      TextInput({ placeholder: '请输入目的地' })
        .width('100%')
        .onChange((value: string) => {
          this.destination = value
        })

      Text('出行天数: ' + this.days + '天')
        .fontSize(14)

      Slider({ min: 1, max: 15, value: this.days })
        .onChange((value: number) => {
          this.days = value
        })

      Button('生成AI行程')
        .width('100%')
        .onClick(() => {
          // 调用AI生成逻辑
        })
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}
```

## 📝 代码注释规范

- `// AI生成` - 表示由AI辅助生成的代码
- `// 人工优化` - 表示人工修改或优化的代码

## ⚙️ 数据持久化

应用使用Hive进行本地数据存储：

- **登录状态** - 保存用户登录信息
- **用户偏好** - 保存默认出行参数、深色模式设置
- **历史行程** - 保存生成的行程记录
- **收藏列表** - 保存收藏的行程

所有数据在应用重启后保持不变。

## 🎨 UI设计

- 遵循Material Design 3设计语言
- 支持亮色/深色模式一键切换
- 所有按钮添加点击水波纹反馈
- 页面切换添加淡入淡出过渡动画
- 加载状态显示Loading动画
- 操作结果显示Toast提示

## 📄 许可证

本项目仅供学习交流使用。

## 🤝 贡献

欢迎提交Issue和Pull Request！

---

**版本**: 1.0.0
**开发**: AI辅助开发
**日期**: 2024年
