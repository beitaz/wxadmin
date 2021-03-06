# README

## 新建项目
```SHELL
$ rails new wxadmin -T --skip-spring -C -M -d mysql --api -B
```
* `-T` 跳过内建的测试框架
* `--skip-spring` 跳过 Spring 预编译(提升开发环境速度)
* `-C` 跳过 Action Cable
* `-M` 跳过 Action Mailer
* `-d` 指定使用的数据库 mysql
* `--api` 指定 Rails 应用程序为 API-only
* `-B` 跳过创建项目后立即执行的 bundle install

**注意:** 删除以下文件可以提升性能, **前提是确定它们的作用**
* `app/jobs` 自定义任务
* `config/initializers/inflections.rb` 自定义单复数变形规则
* `config/initializers/application_controller_renderer.rb` 帮助开发环境重新渲染页面
* `config/initializers/backtrace_silencers.rb` 开发环境出错时回溯第三方库
* `config/initializers/mime_types.rb` 扩展文件类型

## 开发流程

* 获取代码

* 运行复制 task
  ```SHELL
  $ rake config:copy
  >  rm -f config/application.yml
  >  cp config/application.example.yml config/application.yml
  ```
* bundle install
* rails server

## 配置跨域

* 取消 `Gemfile` 中 `rakc-cors` 注释并执行 `bundle install` 安装依赖

* 取消 `config/initializers/cors.rb` 中的相关注释
  ```RUBY
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
  ```

## 登录授权 [jwt](https://github.com/jwt/ruby-jwt) + [knock](https://github.com/nsarno/knock)
任何可以解析 JSON 的终端都可以使用 API 程序,导致正常的 Cookie 授权无法使用,使用 [JSON Web Token](https://en.wikipedia.org/wiki/JSON_Web_Token) 进行登录授权.

* 修改 `Gemfile`
  ```RUBY
  gem 'bcrypt'
  gem 'jwt'
  gem 'knock'
  ```
* 生成 `config/initializers/knock.rb` 配置文件
  ```SHELL
  $ rails g knock:install
  > create config/initializers/knock.rb
  ```
* 生成用户验证器 `app/controllers/user_token_controller.rb`
  ```SHELL
  $ rails g knock:token_controller user
  > create  app/controllers/user_token_controller.rb
  >  route  post 'user_token' => 'user_token#create'
  ```
* 修改生成的 `app/models/user.rb`
  ```RUBY
  class User < ApplicationRecord
    has_secure_password
    validates :account, presence: true, exclusion: { in: %w[admin superuser] }
  end
  ```
* Postman 测试接口(授权)
  - 选择请求类型为 POST 并输入 URL 地址 http://localhost:3000/user_token
  - 设置 Headers 类型
    ```TEXT
    Content-Type: Application/json
    ```
  - 设置 body 数据类型为 raw JSON(application/json) 并输入
    ```JSON
    {
      "auth": {
        "username": "admin",
        "password": "123abc.."
      }
    }
    ```
  - 发送请求获取 token
    ```JSON
    {
      "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MjIyNDQ2ODYsInN1YiI6MX0.reh2pIMFbKUp-IN_8vrOLErICRxjmpBOXFNX5_EyGh0"
    }
    ```
* Postman 测试接口(获取数据)
  - 选择请求类型为 GET 并输入 URL 地址 http://localhost:3000/users
  - 设置 Headers 类型 **注意格式 `Bearer <jwt_key>`**
    ```TEXT
    Content-Type: Application/json
    Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1MjIyNDQ2ODYsInN1YiI6MX0.reh2pIMFbKUp-IN_8vrOLErICRxjmpBOXFNX5_EyGh0
    ```
  - 发送请求获取用户列表 (可修改 user_serializer 暴露字段)
    ```JSON
    [
      {
        "id": 1,
        "username": "beitaz",
        "phone": null,
        "email": null,
        "nick": null,
        "role": "normal",
        "last_login": null,
        "deleted": false
      }
    ]
    ```

## 添加支持类型

* 编辑修改 `config/initializers/mime_types.rb` 中的定义 [ MIME types ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Complete_list_of_MIME_types)
  ```RUBY
  Mime::Type.register 'text/csv', :csv
  ```

## 自定义序列化
* 对象序列化时间默认样式为 `2015-04-21T00:00:00.000Z` ,在 ModelSerializer 中添加如下方法改变此特性:
  ```RUBY
  def publication_date
    object.publication_date.strftime "%Y-%m-%d"
  end
  ```
## 开发技巧
* 代码中添加 `# TODO: 注释内容` 后,可通过 `rake notes:todo` 或 `grep -rn "# TODO" .` 显示所有任务.

## Grape 配置(选用)

* 设置返回格式 `format :json` 会导致其他请求(GET /hello.xml)失败.

* [Content-Type 格式支持](http://tool.oschina.net/commons)
  ```RUBY
  clsss V1:Base < Grape::API
    default_format :json # 修改默认格式 :txt => :json
    content_type :img, 'application/x-img'  # 添加 content_type 支持 image, 默认为 XML, JSON, BINARY, TXT
  end
  ```
  **注意:** 添加 `content_type` 定义会覆盖 Grape 默认值,必须手动添加所有需要支持的 `content_type` 类型;同时还要注意 `default_format` 值必须为所支持类型中的一种.
