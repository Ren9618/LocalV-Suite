# LocalV-Suite 🤖🎙️

🌍 Read this in other languages: [日本語](README.md) | [English](README.en.md) | [繁體中文](README.zh-TW.md) | [한국어](README.ko.md)

LocalV-Suite 是一款专注于隐私、完全离线运行于您的 PC 上的 AI 直播辅助机器人应用套件。
目前，主推的应用 **"Stream Companion"** 是一位能自动对 YouTube 直播评论做出反应并与观众对话的 AI 吉祥物。

## ✨ 特性 (Features)

*   **🔒 完全本地运行:** 后端采用 Ollama (LLM) 和 VOICEVOX (语音合成)。数据不会上传到任何外部服务器，无需 API 密钥，且无需按量付费。
    *   *注：同时也支持兼容 OpenAI API 格式的提供商（适用于 Ollama 运行吃力，或希望使用自有 API 密钥的情况）。*
*   **🌐 5 种语言支持 (i18n):** 支持中文（简体/繁体）、英语、日语和韩语。应用支持自动检测系统语言，并可在应用内手动切换。
*   **🧠 高级记忆系统:**
    *   **短期记忆:** 理解对话的上下文，实现自然的互动（可调整记忆保留轮数）。
    *   **观众记忆 (SQLite):** 在数据库中记录每位观众的评论次数及特点。AI 会对常客做出更亲切的反应。
*   **🎯 智能过滤系统:**
    *   **点名模式:** 可设置仅当评论包含特定触发词（如 `!ai`）时，AI 才做出反应。
    *   **快速回复:** 对常见的打招呼或 SuperChat 进行快速的预设回复，先于 AI 响应。
    *   **黑名单:** 自动化过滤并忽略包含特定词汇的评论。
*   **📺 OBS Studio 联动 (画面叠加):**
    *   **透明字幕覆盖:** 只需将其作为浏览器源加载，即可在直播画面上以透明背景显示 AI 的回复字幕。
    *   **隐藏跳过内容:** 自动隐藏前缀为 `[跳过]` 或 `[忽略]` 的 AI 思考日志，保持画面整洁。
    *   **自定义设计:** 可在应用设置界面直观地调整边框颜色、字体大小、动画速度等。
*   **🎧 音频输出路由:** 将音频输出路由至虚拟音频设备（如 VB-Cable），以便在 OBS 中单独捕获声音。
*   **✨ 新功能与管理:**
    *   **Voiceger 联动:** 集成了全新的 TTS 引擎 “Voiceger”。实现了通过切换设置进行自动资源管理（释放 VRAM）以及故障时的容错处理。
    *   **调试日志 UI:** 应用行为可视化。在 UI 中开启“调试日志”开关，即可实时查看 AI 预热、错误状态等故障排查信息。
    *   **🧹 自动释放内存:** 包含内存管理功能，在应用退出或设置变更时，自动从 VRAM 卸载 Ollama LLM 模型和 TTS 进程。

## 🏗️ 架构

*   **Frontend:** React + TypeScript + Vite
*   **Backend:** Electron + Node.js
*   **Database:** SQLite3 (持久化观众数据)
*   **Local AI Engine:** [Ollama](https://ollama.ai/)
*   **Local Voice Engine:** [VOICEVOX](https://voicevox.hiroshiba.jp/)

## 💻 已验证的运行环境

| 项目 | 环境1 (Linux) | 环境2 (Windows) | 环境3 (Mac) |
|---|---|---|---|
| **操作系统** | Ubuntu 24.04 LTS (x86_64) | Windows 11 | macOS Tahoe 26.3 |
| **CPU** | AMD Ryzen 7 5800X (16线程) | AMD Ryzen 7 5800X (16线程) | Apple M1 |
| **GPU** | NVIDIA GeForce RTX 2080 (8GB显存) | NVIDIA GeForce RTX 2080 (8GB显存) | Apple M1 (8核 GPU) |
| **内存** | 48GB | 48GB | 16GB |
| **Node.js** | v25.x | v20.x 以上 | v20.x |
| **Python** | 3.10〜3.14 (使用Voiceger时) | 3.10 (使用Voiceger时) | 3.9.7 |

> [!NOTE]
> - **GPU (NVIDIA)**: 使用 Voiceger 时强烈推荐具有 CUDA 功能的 NVIDIA GPU（8GB以上显存）。仅使用 VoiceVox 时可在 CPU 上运行。
> - **Node.js / npm**: 推荐 v20 以上。
> - **Python 3.10**: Voiceger 安装时需要（仅使用 VoiceVox 时不需要）。

## 🚀 安装与启动 (Getting Started)

### 1. 准备工作 (必选)
1.  **Ollama (LLM)**: 从[官网](https://ollama.ai/)安装，在终端运行 `ollama run llama3.1` 等命令提前下载并加载 AI 模型。
2.  **VoiceVox (语音合成 - 选项1)**: **※注意：VoiceVox是日语专用的语音引擎，不适合用于朗读其他语言。** 从[官网](https://voicevox.hiroshiba.jp/)安装并启动应用，保持编辑器窗口打开（默认监听 `50021` 端口）。
3.  **Voiceger (语音合成 - 选项2)**: **※注意：Voiceger支持多语言。如果在非日语直播中使用，强烈推荐此选项。** 作为轻量且高速的替代方案，你也可以使用 Voiceger。请按照其教程构建 Python 环境并启动 API 服务器，或使用本应用附带的脚本进行自动启动配置（默认监听 `8000` 端口）。
4.  **虚拟音频线（可选）**: 如果想在 OBS 中分离音频，推荐安装 [VB-Cable](https://vb-audio.com/Cable/)。

### 2. 初始化
```bash
git clone https://github.com/Ren9618/LocalV-Suite.git
cd LocalV-Suite/apps/stream-companion/electron-app
npm install
```

### 3. 启动
```bash
npm run dev
```

## 🎥 OBS 联动指南

### 🔊 音频联动
1. 在应用的“设置” > “音频设置”中，选择输出设备（例如 "CABLE Input"）。
2. 在 OBS 中，添加一个“音频输入采集”项，并选择 "CABLE Output"。

### 📺 评论联动
1. 点击应用右下角的 “🔗 复制 OBS 用 URL”，使用复制的链接（`http://localhost:25252/`）。
2. 在 OBS 中添加一个“浏览器”来源，并粘贴该链接。
3. 从应用的“设置”标签中打开“OBS 叠加设置”，可一边预览一边直观地自定义字体大小、颜色、背景和动画效果。

## 🚀 发展路线与未来设想 (Roadmap / Future Features)

目前，为了让直播更加生动有趣，我们正在构思并计划添加以下新功能：

* **丰富直播画面与表现力**
  * **虚拟形象联动**: 结合 VTube Studio 等工具，根据 AI 的情绪自动切换立绘或虚拟形象的面部表情与动作。
  * **自动播放音效 (SE)**: 当 AI 吐槽或检测到特定关键词时，自动播放相对应的音效（如鼓掌声、提示音等）。
  * **OBS 自动管控**: 通过 OBS WebSocket API 实现自动化导播，例如由 AI 发号施令进行场景切换。

* **强化互动与观众参与感**
  * **多平台兼容**: 除了 YouTube 外，也能同时接入 Twitch 等其他平台的弹幕，让 AI 都能一一应对。
  * **AI 主导的互动环节**: 在弹幕较少时，AI 会主动发起投票调查或迷你小游戏，活跃直播间气氛。
  * **SuperChat 专属特效**: 根据打赏金额的不同，AI 会做出特殊语音语调的回应或弹出专属对话。

* **提升智能与辅助能力**
  * **语音识别 (STT) 融合**: 不仅读取观众评论，还能识别主播的麦克风声音，实现与 AI 的实时语音对话与“联动直播”。
  * **RAG (检索增强生成)**: 将本地文本或维基资料投喂给 AI，使其能说出更具专业性、更贴合上下文的准确发言。
  * **自动生成高光时刻**: 在直播结束时，由 AI 自动摘要当天的精彩互动，输出可供发布或回顾的文本记录。

## 📜 许可证
本项目采用 [MIT 许可证](LICENSE) 授权。

**鸣谢 (Credits):**
*   本应用程序使用了 **VOICEVOX** 进行语音合成。
*   在直播或制作视频使用时，请务必标注版权信息，例如 "**VOICEVOX:(角色名)**"。详细信息请参考 [VOICEVOX 使用条款](https://voicevox.hiroshiba.jp/term/)。

**免责声明:**  
本软件使用了生成式 AI。我们对 AI 生成的输出内容不承担任何责任。在使用外部工具（如 VOICEVOX）时，请务必遵守其相应的服务条款。
