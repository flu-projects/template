# template


# 命令使用说明：

### 1、getx 脚手架
// 安装:
pub global activate get_cli 
// 使用本命令需要设置系统环境变量: [FlutterSDK安装目录]\bin\cache\dart-sdk\bin 和 [FlutterSDK安装目录]\.pub-cache\bin

flutter pub global activate get_cli

// 在当前目录创建一个 Flutter 项目:
// 注: 默认使用文件夹名称作为项目名称
// 你可以使用 `get create project:my_project` 给项目命名
// 如果项目名称有空格则使用 `get create project:"my cool project"`
get create project

// 在现有项目中生成所选结构:
get init

// 创建页面:
// (页面包括 controller, view, 和 binding)
// 注: 你可以随便命名, 例如: `get create page:login`
get create page:home

// 在指定文件夹创建新 controller:
// 注: 你无需引用文件夹, Getx 会自动搜索 home 目录,
// 并把你的controller放在那儿
get create controller:dialogcontroller on home

// 在指定文件夹创建新 view:
// 注: 你无需引用文件夹,Getx 会自动搜索 home 目录,
// 并把你的 view 放在那儿
get create view:dialogview on home

// 在指定文件夹创建新 provider:
get create provider:user on home

// 生成国际化文件:
// 注: 你在 'assets/locales' 目录下的翻译文件应该是json格式的
get generate locales assets/locales

// 生成 model 类:
// 注: 'assets/models/' 目录下的模板文件应该是json格式的
// 注: on  == 输出文件夹
// Getx 会自动搜索 home 目录,
// 并把你的 model 放在那儿
get generate model on home with assets/models/user.json

//生成无 provider 的 model
get generate model on home with assets/models/user.json --skipProvider

//注: URL 必须返回json
get generate model on home from "https://api.github.com/users/CpdnCristiano"

// 为你的项目安装依赖:
get install camera

// 为你的项目安装多个依赖:
get install http path camera

// 为你的项目安装依赖(指定版本号):
get install path:1.6.4

// 你可以为多个依赖指定版本号

// 为你的项目安装一个dev依赖(dependencies_dev):
get install flutter_launcher_icons --dev

// 为你的项目移除一个依赖:
get remove http

// 为你的项目移除多个依赖:
get remove http path

// 更新 CLI:
get update
// 或 `get upgrade`

// 显示当前 CLI 版本:
get -v
// 或 `get -version`

// 帮助
get help

// 升级yml中的插件版本
flutter pub upgrade --major-versions


### 2、json_model；

// 快速生成 dart bean 的命令行工具
#### 使用步骤：
a、在yaml文件中添加依赖：
 ```yaml
 dependencies: 
   cupertino_icons: ^1.0.2
   get: 4.6.5
   flutter: 
     sdk: flutter
   dio: ^4.0.6
   retrofit: ^3.0.1+1
 
 dev_dependencies: 
   flutter_lints: 2.0.1
   flutter_test: 
     sdk: flutter
   json_model: ^1.0.0
   json_serializable: ^6.3.1
   json_annotation: ^4.6.0
   build_runner: any
   retrofit_generator: ^4.0.2
```
b、生成命令：https://pub.dev/packages/json_model

