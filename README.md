# LocalV-StreamLive 🤖🎙️

🌍 Read this in other languages: [English](README.en.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [한국어](README.ko.md)

LocalV-StreamLiveは、あなたのPCで完結する「プライバシー重視・完全オフライン」のAI配信ボット＆アシスタントツール群です。
現在、メインアプリとしてYouTube Liveの配信コメントに自動で反応して会話してくれるAIマスコット **「Stream Companion」** を搭載しています。

## ✨ 特徴 (Features)

*   **🔒 完全ローカル稼働:** Ollama (LLM) と VOICEVOX / Voiceger (音声合成) をバックエンドに使用。外部サーバーへのデータ送信なし、APIキー不要、従量課金なしで利用可能です。
    *   ※OpenAIベースのAPI互換プロバイダにも対応しています（Ollamaが重い環境や、お持ちのAPIキーを使いたい場合向け）。
*   **🌐 5言語対応 (i18n):** 日本語、English、中国語(簡体字/繁体字)、韓国語の多言語表示をサポート。システム言語自動検出＆アプリ内手動切り替えに対応。
*   **🧠 高度な記憶システム:**
    *   **短期記憶:** 会話の直近の文脈を理解し、自然な掛け合いを実現（記憶保持数の調整が可能）。
    *   **視聴者記憶 (SQLite):** 視聴者ごとのコメント回数や特徴をデータベースに記録。常連さんには親しげに反応します。
*   **🎯 インテリジェントなフィルター機能:**
    *   **指名モード:** `!ai` などの特定のトリガーがある時だけAIが反応するように設定可能。
    *   **クイックリプライ:** 定番の挨拶やスパチャコメントには、AIに先行して定型文で高速レスポンス。
    *   **ブラックリスト:** 特定の単語を含むコメントを自動的に無視。
*   **📺 OBS Studio 連携 (オーバーレイ):**
    *   **透過字幕オーバーレイ:** ブラウザソースとして読み込むだけで、配信画面に透過背景の字幕としてAIの返答を表示。
    *   **スキップ非表示:** `[スキップ]` や `[無視]` などのAI思考ログは自動で画面から隠蔽されます。
    *   **デザインカスタマイズ:** 枠の色、フォントサイズ、アニメーション速度などをアプリ内の設定画面から直感的に変更可能。
*   **🎧 オーディオ出力ルーティング:** 音声を仮想オーディオデバイス（VB-Cable等）に送り、OBSで個別にキャプチャ可能。
*   **✨ 新機能・管理機能:**
    *   **Voiceger 連携:** 新たなTTSエンジンとして「Voiceger」を統合。設定切り替えによる自動リソース管理（VRAM解放）や障害時のフォールバック処理を実装しています。
    *   **デバッグログ・UI:** アプリの挙動を可視化。UIから「デバッグログ」トグルをONにすることで、AIのウォームアップやエラー状況などのトラブルシューティング情報をリアルタイムに確認できます。
    *   **🧹 自動メモリ解放:** アプリ終了時や設定変更時にOllamaのLLMモデルやTTSプロセスを自動で解放するメモリ管理機能付き。

## 🏗️ アーキテクチャ

*   **Frontend:** React + TypeScript + Vite
*   **Backend:** Electron + Node.js
*   **Database:** SQLite3 (視聴者データの永続化)
*   **Local AI Engine:** [Ollama](https://ollama.ai/)
*   **Local Voice Engine:** [VOICEVOX](https://voicevox.hiroshiba.jp/)

## 💻 動作確認済み環境

| 項目 | 環境1 (Linux) | 環境2 (Windows) | 環境3 (Mac) |
|---|---|---|---|
| **OS** | Ubuntu 24.04 LTS (x86_64) | Windows 11 | macOS Tahoe 26.3 |
| **CPU** | AMD Ryzen 7 5800X (16スレッド) | AMD Ryzen 7 5800X (16スレッド) | Apple M1 |
| **GPU** | NVIDIA GeForce RTX 2080 (VRAM 8GB) | NVIDIA GeForce RTX 2080 (VRAM 8GB) | Apple M1 (8コア GPU) |
| **RAM** | 48GB | 48GB | 16GB |
| **Node.js** | v25.x | v20.x 以上 | v20.x |
| **Python** | 3.10〜3.14 (Voiceger使用時) | 3.10 (Voiceger使用時) | 3.9.7 |

> [!NOTE]
> - **GPU (NVIDIA)**: Voiceger を使用する場合は CUDA 対応の NVIDIA GPU (VRAM 8GB以上) を強く推奨します。VoiceVox のみの場合は CPU でも動作します。
> - **Node.js / npm**: v20 以上を推奨します。
> - **Python 3.10**: Voiceger のセットアップに必要です（VoiceVox のみ利用する場合は不要）。

## 🚀 インストールと起動 (Getting Started)

### 1. 事前準備 (必須)
1.  **Ollama (LLM)**: [公式HP](https://ollama.ai/)からインストールし、ターミナルで `ollama run llama3.1` 等を実行して事前にAIモデルをダウンロードしておいてください。
2.  **VoiceVox (音声合成 - 推奨1)**: **※VoiceVoxは日本語専用です。他言語の読み上げには不向きです。** [公式HP](https://voicevox.hiroshiba.jp/)からインストールし、アプリを起動してエディタ画面を開いた状態にしておきます（デフォルトでポート `50021` で待機します）。
3.  **Voiceger (音声合成 - 推奨2)**: **※Voicegerは多言語対応です。日本語以外の配信でおすすめします。**別の軽量・高速な選択肢としてVoicegerも利用可能です。[Voiceger公式等]の手順に従ってPython環境・サーバーを構築し、APIサーバーを立ち上げておくか、本アプリ付属のスクリプトで自動起動を設定してください（デフォルトでポート `8000` で待機します）。
4.  **仮想オーディオ（任意）**: 音声をOBSで分けたい場合は [VB-Cable](https://vb-audio.com/Cable/) 等の導入が推奨されます。

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

### 🔊 音声の連携
1. アプリの「設定」＞「音声設定」で、音声出力デバイスに「CABLE Input」等を選択。
2. OBSの「音声入力キャプチャ」で「CABLE Output」を追加。

### 📺 コメントの連携
1. アプリの右下の「🔗 OBS用URLをコピー」をクリックし、コピーしたURL（`http://localhost:25252/`）を使用します。
2. OBSで「ブラウザソース」を追加し、URLを貼り付けます。
3. アプリ内の「設定」タブから「OBSオーバーレイ設定」を開き、フォントサイズ・配色・背景・アニメーション効果などをプレビューしながらカスタマイズできます。

## � 今後の展望 (Roadmap / Future Features)

現在、配信をさらに盛り上げるための以下の新機能を構想・検討中です。

* **配信画面・演出の強化**
  * **アバター連携**: VTube Studio等と連携し、AIの感情に合わせて立ち絵やアバターの表情・モーションを自動切り替え。
  * **効果音 (SE) 連携**: AIのツッコミや特定キーワードに合わせて、自動で効果音を再生。
  * **OBS自動操作**: OBS WebSocket APIを経由した、AI主導のシーン切り替えなどの配信オペレーション補助。

* **インタラクティブ・視聴者参加型機能**
  * **マルチプラットフォーム対応**: YouTubeに加え、Twitch等他プラットフォームのコメントも同時に処理。
  * **AI主導の企画**: コメントが落ち着いている時に、AIからアンケートやミニゲームを自動で振る話題提供機能。
  * **スパチャ特別演出**: 投げ銭の金額に応じた特別なセリフや、音声のテンション自動変化。

* **インテリジェント機能の拡張**
  * **音声認識 (STT) 連携**: 視聴者のコメントだけでなく、配信者のマイク音声も認識し、AIと直接会話（コラボ）できる機能。
  * **RAG (検索拡張生成)**: ローカルのテキストやWikiデータを読み込ませ、AIがより専門的・文脈に沿った的確な発言を行える機能。
  * **ハイライト自動生成**: 配信終了時に、その日のやり取りを自動で要約して見どころをテキスト出力する機能。

## �📜 ライセンス (License)
本プロジェクトは [MIT License](LICENSE) のもとで公開されています。

**クレジット表記 (Credits):**
*   本アプリケーションの音声合成には **VOICEVOX** を使用しています。
*   配信等でご利用の際は、必ず「**VOICEVOX:（キャラクター名）**」等のクレジット表記を行ってください。詳細は [VOICEVOX 利用規約](https://voicevox.hiroshiba.jp/term/) をご確認ください。

**Voiceger サードパーティ ライセンス情報:**
*   本アプリケーションは [Voiceger](https://github.com/zunzun999/voiceger_v2) と連携する機能を含みます。Voiceger 自体のソースコードやモデルを同梱・再配布するものではありません。
*   Voiceger は以下のオープンソースソフトウェアを含みます:
    *   [GPT-SoVITS](https://github.com/RVC-Boss/GPT-SoVITS) (MIT License)
    *   GPT-SoVITS Pretrained Models (MIT License)
    *   [G2PW Model](https://github.com/GitYCC/g2pW) (Apache 2.0 License)
    *   [RVC WebUI](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI) (MIT License)
    *   RMVPE (MIT License)
    *   Faster Whisper Large V3 (MIT License)
*   ずんだもん音声モデルの利用規約: [https://zunko.jp/con_ongen_kiyaku.html](https://zunko.jp/con_ongen_kiyaku.html)

**免責事項:**  
本ソフトウェアは生成AIを使用しています。AIの出力結果に対する責任は負いかねます。また、VOICEVOX・Voiceger等の外部ツールを利用する際は、各ソフトウェアの利用規約を必ず遵守してください。
