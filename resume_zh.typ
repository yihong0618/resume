#import "typst_template.typ": *

#show: resume.with(
  author: "伊洪 (yihong0618)",
  location: "辽宁大连",
  email: "zouzou0208@gmail.com",
  phone: "(+86)13149872429",
  github: "gitblog",
  telegram: "yihong0618",
  personal-site: "https://yihong.run",
  blog: "https://github.com/yihong0618/gitblog",
)

== 个人简介

- 微软 MVP, Apache OpenDAL committer, 开源爱好者 (GitHub 6k followers, 3w stars)
- GreptimeDB 社区布道师
- 多个千 Stars 项目作者 / 多个项目核心贡献 (vscode-leetcode, stravalib, autocut, DB-GPT, Dify, OpenDAL...)
- 6 年 Python 开发经验，全栈工程师；擅长后端开发、CI/CD 自动化领域
- 爱好开源，维护多个开源项目；擅长数据可视化，AIGC 开发，xiaogpt 作者
- 参加多个开源活动，有讲师经历

== 工作经历

#work(
  title: "AI(LLM) 项目负责人",
  location: "Xenera",
  date: "2024.11 - 至今",
)[
  - 负责公司 LLM 项目相关技术选型，开发，POC
]

#work(
  title: "数据库开发工程师 (Greenplum / PostgreSQL)",
  location: "VMware",
  date: "2022.3 - 2024.11",
)[
  - 维护和开发多个 Greenplum 的 extensions: pgml, pgvector
  - 主导 pgvector 引入 Greenplum
  - 协助将 pgrx 和 pgml 引入 gpdb
  - 重构 gpdb extensions 的多个 CI/CD, 使其更容易维护
  - 开发多个将 ChatGPT 和 gpdb/postgres 结合的项目
]

#work(
  title: "网络自动化工程师",
  location: "思科",
  date: "2019.10 - 2022.3",
)[
  - 利用 Python 开发多个网络自动化工具
  - Python Django 给网络维护人员编写维护工具
  - 引入 AI 进行网络自动化诊断
]

#work(
  title: "软件开发 / 讲师",
  location: "东软教育科技集团",
  date: "2018.9 - 2019.10",
)[
  - 负责开发教学软件（项目实训，项目实践）
  - 负责校外校内的 Python 培训工作
]

#work(
  title: "数据分析师 / 游戏运营",
  location: "金山（西山居）",
  date: "2015.4 - 2018.4",
)[
  - 负责《小米枪战》的数据设计, 埋点及数据分析
  - 负责《反恐行动》的数据分析，数据报告编写
  - 负责竞品和市场调研，总结调研报告，分析市场，从而指导开发立项多个项目
  - 负责西山居大连 VR 实验室的建立，开发，及游戏预研。
]

== 技术栈

#skills((
  "Python", "Rust", "Go", "DevOps", "React", "Open-source", "AIGC", "市场运营", "数据分析", "数据可视化"
))

== 开源项目

#project(
  name: "running_page",
  url: "https://github.com/yihong0618/running_page",
  description: "Make your own running home page",
)

#project(
  name: "bilingual_book_maker",
  url: "https://github.com/yihong0618/bilingual_book_maker",
  description: "Make bilingual epub books Using AI translate",
)

#project(
  name: "xiaogpt",
  url: "https://github.com/yihong0618/xiaogpt",
  description: "Play ChatGPT and other LLM with Xiaomi AI Speaker",
)

#project(
  name: "Kindle_download_helper",
  url: "https://github.com/yihong0618/Kindle_download_helper",
  description: "Download all your kindle books script.",
)

#project(
  name: "GitHubPoster",
  url: "https://github.com/yihong0618/GitHubPoster",
  description: "Make everything a GitHub svg poster and Skyline!",
)

#project(
  name: "gitblog",
  url: "https://github.com/yihong0618/gitblog",
  description: "My personal blog using issues and GitHub Actions",
)

#project(
  name: "epubhv",
  url: "https://github.com/yihong0618/epubhv",
  description: "Make your epub books vertical or horizontal.",
)

#project(
  name: "vscode-gcores",
  url: "https://github.com/yihong0618/vscode-gcores",
  description: "Play Gcores in VS Code",
)

#project(
  name: "github-readme-stats",
  url: "https://github.com/yihong0618/github-readme-stats",
  description: "generate my_github status using GitHub Actions",
)

#project(
  name: "GreptimeDB",
  url: "https://github.com/GreptimeTeam/greptimedb",
  description: "",
)

#project(
  name: "Dify",
  url: "https://github.com/langgenius/dify",
  description: "",
)

== 教育经历

#education(
  institution: "沈阳工业大学",
  major: "机械工程",
  degree: "工程硕士",
  date: "2012 - 2015",
)

#education(
  institution: "辽宁工业大学",
  major: "机械电子工程",
  degree: "工程学士",
  date: "2008 - 2012",
)
