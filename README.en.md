# LocalV-Suite 🤖🎙️

🌍 Read this in other languages: [日本語](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [한국어](README.ko.md)

LocalV-Suite is a privacy-focused, entirely offline AI broadcast bot and assistant tool suite designed to run entirely on your PC.
Currently, it features **"Stream Companion"**, an AI mascot that automatically responds to and converses with YouTube Live stream comments.

## ✨ Features

*   **🔒 100% Local Execution:** Utilizes Ollama (LLM) and VOICEVOX (Voice Synthesis) as backends. No data transmission to external servers, no API keys required, and no hidden usage fees.
    *   *Note: OpenAI-compatible API providers are also supported (for environments where Ollama is too heavy or if you prefer using your own API key).*
*   **🌐 5 Supported Languages (i18n):** Supports English, Japanese, Chinese (Simplified/Traditional), and Korean. Features automatic system language detection and manual switching within the app.
*   **🧠 Advanced Memory System:**
    *   **Short-term Memory:** Understands the recent context of the conversation for natural interactions (adjustable memory retention).
    *   **Viewer Memory (SQLite):** Records comment frequency and traits for each viewer. The AI will respond in a friendly manner to regular viewers.
*   **🎯 Intelligent Filtering System:**
    *   **Nominate Mode:** Set the AI to respond only when triggered by specific keywords such as `!ai`.
    *   **Quick Replies:** Fast predefined responses to common greetings or SuperChats, preempting the AI.
    *   **Blacklist:** Automatically ignores comments containing specific words.
*   **📺 OBS Studio Integration (Overlay):**
    *   **Transparent Subtitle Overlay:** Simply load it as a browser source to display AI responses as transparent subtitles on your stream.
    *   **Skip Hiding:** AI thinking logs prefixed with `[Skip]` or `[Ignore]` are automatically hidden from the screen.
    *   **Customizable Design:** Intuitively change border colors, font sizes, animation speeds, etc., from the in-app settings screen.
*   **🎧 Audio Output Routing:** Route audio to a virtual audio device (e.g., VB-Cable) to capture it separately in OBS.
*   **✨ New Features & Management:**
    *   **Voiceger Integration:** Integrated "Voiceger" as a new TTS engine. Implemented automatic resource management (VRAM release) and fallback processing during failures via settings switching.
    *   **Debug Log UI:** Visualize app behavior. Turning on the "Debug Log" toggle from the UI allows real-time viewing of troubleshooting info like AI warmup and error states.
    *   **🧹 Automatic Memory Release:** Includes an automatic memory management feature that unloads Ollama LLM models and TTS processes from VRAM on app exit or settings change.

## 🏗️ Architecture

*   **Frontend:** React + TypeScript + Vite
*   **Backend:** Electron + Node.js
*   **Database:** SQLite3 (Persistent viewer data)
*   **Local AI Engine:** [Ollama](https://ollama.ai/)
*   **Local Voice Engine:** [VOICEVOX](https://voicevox.hiroshiba.jp/)

## 💻 Tested Environments

| Item | Environment 1 (Linux) | Environment 2 (Windows) | Environment 3 (Mac) |
|---|---|---|---|
| **OS** | Ubuntu 24.04 LTS (x86_64) | Windows 11 | macOS Tahoe 26.3 |
| **CPU** | AMD Ryzen 7 5800X (16 threads) | AMD Ryzen 7 5800X (16 threads) | Apple M1 |
| **GPU** | NVIDIA GeForce RTX 2080 (8GB VRAM) | NVIDIA GeForce RTX 2080 (8GB VRAM) | Apple M1 (8-core GPU) |
| **RAM** | 48GB | 48GB | 16GB |
| **Node.js** | v25.x | v20.x or higher | v20.x |
| **Python** | 3.10–3.14 (for Voiceger) | 3.10 (for Voiceger) | 3.9.7 |

> [!NOTE]
> - **GPU (NVIDIA)**: A CUDA-capable NVIDIA GPU with 8GB+ VRAM is strongly recommended when using Voiceger. VoiceVox alone can run on CPU.
> - **Node.js / npm**: v20 or higher is recommended.
> - **Python 3.10**: Required for Voiceger setup (not needed if using VoiceVox only).

## 🚀 Getting Started

### 1. Prerequisites (Required)
1.  **Ollama (LLM)**: Install from the [official website](https://ollama.ai/) and run a model via terminal beforehand, e.g., `ollama run llama3.1`.
2.  **VoiceVox (TTS - Option 1)**: ***VoiceVox is a Japanese-only TTS library. It is not suitable for other languages.*** Install from the [official website](https://voicevox.hiroshiba.jp/), launch the application, and keep the editor window open (it listens on port `50021` by default).
3.  **Voiceger (TTS - Option 2)**: ***Voiceger supports multiple languages. Highly recommended for non-Japanese streams.*** Voiceger is an alternative lightweight and fast option. Follow its setup guide to build the Python environment and start the API server, or use the included scripts for auto-start (it listens on port `8000` by default).
4.  **Virtual Audio (Optional)**: If you want to route and separate audio in OBS, installing [VB-Cable](https://vb-audio.com/Cable/) or similar software is recommended.

### 2. Setup
```bash
git clone https://github.com/Ren9618/LocalV-Suite.git
cd LocalV-Suite/apps/stream-companion/electron-app
npm install
```

### 3. Launch
```bash
npm run dev
```

## 🎥 OBS Integration Guide

### 🔊 Audio Integration
1. In the app's "Settings" > "Audio Settings", select your output device (e.g., "CABLE Input").
2. In OBS, add an "Audio Input Capture" and select "CABLE Output".

### 📺 Comment Integration
1. Click "🔗 Copy URL for OBS" at the bottom right of the app and use the copied URL (`http://localhost:25252/`).
2. Add a "Browser Source" in OBS and paste the URL.
3. Open "OBS Overlay Settings" from the app's "Settings" tab to visually customize font size, colors, background, and animation effects while previewing them.

## 🚀 Roadmap / Future Features

Currently, we are planning and considering the following new features to make your streams even more engaging:

* **Enhancing Stream Visuals & Effects**
  * **Avatar Integration**: Synchronize AI emotions with VTuber avatars or Live2D models (e.g., VTube Studio) for automatic facial expression and motion switching.
  * **Sound Effects (SE)**: Automatically play sound effects tailored to the AI's responses or specific keywords.
  * **OBS Automation**: Streamline broadcasting operations, such as AI-driven scene switching via OBS WebSocket API.

* **Interactive & Viewer Engagement Features**
  * **Multi-Platform Support**: Process comments from Twitch and other platforms simultaneously alongside YouTube.
  * **AI-Led Activities**: Allow the AI to automatically initiate polls or mini-games during quiet moments in the stream.
  * **SuperChat Special Effects**: Introduce custom voice tones or special dialogue based on donation amounts.

* **Expanding Intelligent Capabilities**
  * **Speech-to-Text (STT) Integration**: Recognize the streamer's microphone audio, allowing direct, collaborative voice conversations with the AI.
  * **RAG (Retrieval-Augmented Generation)**: Feed the AI local text or Wiki data so it can provide more accurate, specialized, and context-aware responses.
  * **Automated Highlights**: Generate a text summary of the stream's best moments and interactions when the broadcast ends.

## 📜 License
This project is licensed under the [MIT License](LICENSE).

**Credits:**
*   This application uses **VOICEVOX** for voice synthesis.
*   When using this application for streaming or video creation, you must include a credit notation such as "**VOICEVOX:(Character Name)**". For details, please refer to the [VOICEVOX Terms of Use](https://voicevox.hiroshiba.jp/term/).

**Disclaimer:**  
This software uses generative AI. We are not responsible for the output generated by the AI. When using external tools such as VOICEVOX, ensure you comply with their respective terms of service.
