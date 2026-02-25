# LocalV-StreamLive 🤖🎙️

LocalV-StreamLiveは、あなたのPCローカル環境で完結する「プライバシー重視・完全オフライン」のAI配信ボット＆アシスタントツール群です。
現在、メインアプリとして配信コメントに毒舌でツッコミを入れるAIマスコット **「Stream Companion」** を搭載しています。

## ✨ 特徴 (Features)

*   **🔒 完全ローカル稼働:** Ollama (LLM) と VOICEVOX (音声合成) をバックエンドに使用。外部サーバーへのデータ送信なし、APIキー不要、従量課金なしで利用可能です。
*   **🧠 高度な記憶システム:**
    *   **短期記憶:** 会話の直近の文脈を理解し、自然な掛け合いを実現。
    *   **視聴者記憶 (SQLite):** 視聴者ごとのコメント回数や特徴をデータベースに記録。常連さんには親しげに反応します。
*   **🎯 インテリジェントなフィルター機能:**
    *   **指名モード:** `!ai` などの特定のトリガーがある時だけAIが反応するように設定可能。
    *   **クイックリプライ:** 定番の挨拶や「草」コメントには、AIに先行して定型文で高速レスポンス。
    *   **ブラックリスト:** 特定の単語を含むコメントを自動的に無視。
*   **📺 OBS Studio 連携:**
    *   **透過オーバーレイ:** ブラウザソースとして読み込むだけで、配信画面に透過背景の字幕としてAIの返答を表示。
    *   **オーディオルーティング:** 音声を仮想デバイス（VB-Cable等）に送り、OBSで個別にキャプチャ可能。
*   **🎨 カスタマイズ性:** システムプロンプトや各種設定をGUIから簡単に変更可能。

## 🏗️ アーキテクチャ

*   **Frontend:** React + TypeScript + Vite
*   **Backend:** Electron
*   **Database:** SQLite3 (視聴者データの永続化)
*   **AI Engine:** [Ollama](https://ollama.ai/)
*   **Voice Engine:** [VOICEVOX](https://voicevox.hiroshiba.jp/)

## 🚀 インストールと起動 (Getting Started)

### 1. 事前準備
1.  **Ollama**: [公式HP](https://ollama.ai/)からインストールし、`ollama run llama3.1` 等でモデルを導入してください。
2.  **VOICEVOX**: [公式HP](https://voicevox.hiroshiba.jp/)からインストールし、起動してエディタ画面を開いておいてください（ポート 50021 で待機します）。
3.  **仮想オーディオ（任意）**: 音声をOBSで分けたい場合は [VB-Cable](https://vb-audio.com/Cable/) 等が推奨されます。

### 2. セットアップ
```bash
git clone https://github.com/Ren9618/LocalV-StreamLive.git
cd LocalV-StreamLive/apps/stream-companion/electron-app
npm install
```

### 3. 起動
```bash
npm run dev
```

## 🎥 OBSとの連携方法

### 音声の連携
1. アプリの「設定」＞「音声設定」で、出力デバイスに「CABLE Input」等を選択。
2. OBSの「音声入力キャプチャ」で「CABLE Output」を選択。

### 映像（字幕）の連携
1. アプリ右下の「🔗 OBS用URLをコピー」をクリック。
2. OBSで「ブラウザソース」を追加し、URLを貼り付け。設定で「背景を透過」をチェック。

## 📜 ライセンス
MIT License

**免責事項:**
本ソフトウェアは生成AIを使用しています。AIの出力結果に対する責任は負いかねます。また、VOICEVOX等の外部ツールを利用する際は、各ソフトウェアの利用規約を必ず遵守してください。

