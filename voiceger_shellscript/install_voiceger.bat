@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM =============================================================================
REM Voiceger インストールスクリプト (Windows)
REM
REM このスクリプトは Voiceger (https://github.com/zunzun999/voiceger_v2) の
REM セットアップを自動化するものです。Voiceger のソースコードやモデルを
REM 同梱・再配布するものではなく、公式リポジトリからのクローンおよび
REM 必要な依存関係のインストールを行います。
REM
REM --- サードパーティ ライセンス情報 ---
REM Voiceger は以下のオープンソースソフトウェアを含みます:
REM   - GPT-SoVITS (MIT License) : https://github.com/RVC-Boss/GPT-SoVITS
REM   - GPT-SoVITS Pretrained Models (MIT License)
REM   - G2PW Model (Apache 2.0 License) : https://github.com/GitYCC/g2pW
REM   - RVC WebUI (MIT License) : https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI
REM   - RMVPE (MIT License)
REM   - Faster Whisper Large V3 (MIT License)
REM
REM ずんだもん音声モデルの利用規約:
REM   https://zunko.jp/con_ongen_kiyaku.html
REM =============================================================================

echo Starting Voiceger Installation for Windows...

:: 設置場所の決定（LocalV-StreamLiveディレクトリ内）
set "TARGET_DIR=%~dp0..\"
cd /d "%TARGET_DIR%"

:: 依存ツールの確認と自動インストール (winget使用)
set "PREREQ_INSTALLED=0"

where git >nul 2>&1
if !errorlevel! neq 0 (
    echo Git がインストールされていません。wingetを使用して自動インストールを試みます...
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    set "PREREQ_INSTALLED=1"
)

where python >nul 2>&1
if !errorlevel! neq 0 (
    echo Python がインストールされていません。wingetを使用してPython 3.12の自動インストールを試みます...
    winget install --id Python.Python.3.12 -e --source winget --accept-package-agreements --accept-source-agreements
    set "PREREQ_INSTALLED=1"
)

where git-lfs >nul 2>&1
if !errorlevel! neq 0 (
    echo Git LFS がインストールされていません。wingetを使用して自動インストールを試みます...
    winget install --id GitHub.GitLFS -e --source winget --accept-package-agreements --accept-source-agreements
    set "PREREQ_INSTALLED=1"
)

if "!PREREQ_INSTALLED!"=="1" (
    echo.
    echo ======================================================================
    echo 必要な依存ツール^(Python / Git / Git LFS等^)の自動インストールを行いました。
    echo これらをシステムに認識させるため、一度このウィンドウを閉じ、
    echo 新しいターミナルを開いてから再度実行してください。
    echo ======================================================================
    pause
    exit /b 0
)

:: 引数の解析
set "ACTION=default"
:parse_args
if "%~1"=="" goto after_args
if /i "%~1"=="--clean" set "ACTION=clean"
if /i "%~1"=="--resume" set "ACTION=resume"
if /i "%~1"=="-y" set "ACTION=resume"
if /i "%~1"=="--yes" set "ACTION=resume"
if /i "%~1"=="--uninstall" set "ACTION=uninstall"
shift
goto parse_args
:after_args

if "%ACTION%"=="uninstall" (
    echo Uninstalling Voiceger...
    if exist "voiceger_v2" (
        rmdir /s /q "voiceger_v2"
        echo Voiceger uninstalled successfully.
    ) else (
        echo Voiceger is not installed.
    )
    exit /b 0
)

:: Git LFSの有効化（モデルダウンロードに必須）
git lfs install

:: 再インストール確認
if exist "voiceger_v2" (
    echo Voiceger is already installed in %cd%\voiceger_v2
    if "%ACTION%"=="clean" (
        echo Clean installation requested. Removing existing directory...
        rmdir /s /q "voiceger_v2"
    ) else if "%ACTION%"=="resume" (
        echo Resume installation requested. Existing directory will be updated/resumed.
        cd voiceger_v2
        git pull
        cd ..
    ) else (
        set /p REINSTALL="Do you want to clean reinstall (c) or resume (r)? (c/R): "
        if /i "!REINSTALL!"=="c" (
            echo Removing existing installation...
            rmdir /s /q "voiceger_v2"
        ) else (
            echo Resuming installation in existing directory...
            cd voiceger_v2
            git pull
            cd ..
        )
    )
)

if not exist "voiceger_v2" (
    echo Cloning voiceger_v2...
    git clone https://github.com/zunzun999/voiceger_v2.git
    if !errorlevel! neq 0 (
        echo Error: Failed to clone repository.
        pause
        exit /b 1
    )
)

cd voiceger_v2

echo Creating python venv...
python -m venv venv
if !errorlevel! neq 0 (
    echo Error: Failed to create venv.
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

echo Patching requirements.txt for Windows compatibility (including Python 3.12 support)...
python -c "import os, re; req='requirements.txt'; prob={'llvmlite':'','numba':'','numpy':'<2.0.0','av':'','mkl-service':'','mkl_fft':'','mkl_random':'','starlette':'>=0.40.0','huggingface-hub':'>=0.33.5','fastapi':'>=0.115.2'}; f=lambda l: l if not l.strip() or l.startswith('#') else None if 'LangSegment' in l or 'fairseq' in l else re.split(r'[=<>!~\[@ ]', l.strip())[0].strip() + prob[re.split(r'[=<>!~\[@ ]', l.strip())[0].strip()] if re.split(r'[=<>!~\[@ ]', l.strip())[0].strip() in prob else l; os.path.exists(req) and open(req,'w',encoding='utf-8').write('\n'.join([x for x in (f(l) for l in open(req,'r',encoding='utf-8').read().split('\n')) if x is not None]))"

echo Patching voiceger_api.py for cross-platform support and FFmpeg error fix...
python -c "import os; a='example/voiceger_api.py'; d=open(a,'r',encoding='utf-8').read() if os.path.exists(a) else ''; os.path.exists(a) and '@app.get(\"/speakers\")' not in d and open(a,'w',encoding='utf-8').write(d.replace('    \"endpoints\": [\"/tts\", \"/vc/single\"]\n    }', '    \"endpoints\": [\"/tts\", \"/vc/single\", \"/speakers\"]\n    }').replace('if os.path.exists(os.path.join(ffmpeg_dir, \"ffmpeg.exe\")):', 'if os.name != \"nt\":\\n    pass\\nelif os.path.exists(os.path.join(ffmpeg_dir, \"ffmpeg.exe\")):').replace('@app.post(\"/tts\")', '\\n@app.get(\"/speakers\")\\ndef get_speakers():\\n    return {\"speakers\": [{\"id\": f, \"name\": f.replace(\".wav\", \"\")} for f in os.listdir(REFERENCE_DIR) if f.endswith(\".wav\")] if os.path.exists(REFERENCE_DIR) and [f for f in os.listdir(REFERENCE_DIR) if f.endswith(\".wav\")] else [{\"id\": \"default\", \"name\": \"Default Speaker\"}]}\\n\\n@app.post(\"/tts\")').replace('else:\\n    raise FileNotFoundError(f\"FFmpeg directory not found: {ffmpeg_dir}\")', 'else:\\n    import shutil\\n    if shutil.which(\"ffmpeg\"):\\n        print(f\"✓ FFmpeg found in system PATH\")\\n    else:\\n        print(f\"⚠ Warning: FFmpeg not found. Some features may not work. Please install FFmpeg and add it to PATH.\")'))"

echo Installing build tools...
python -m pip install "pip<24.1"
python -m pip install "setuptools==69.5.1" wheel Cython "numpy<2.0.0"

echo Installing legacy dependencies (openai-whisper, eunjeon, LangSegment)...
python -m pip install --no-build-isolation openai-whisper==20240930 eunjeon==0.4.0 ./LangSegment-0.3.5

echo Upgrading build tools...
python -m pip install --upgrade setuptools

echo Installing remaining requirements...
python -m pip install -r requirements.txt

echo Reverting setuptools to ^< 70.0.0 to fix pkg_resources error...
python -m pip install "setuptools<70.0.0"

echo Installing fairseq forcibly without dependencies...
python -m pip install fairseq==0.12.2 --no-deps

:: GPU環境の自動判別と適切な PyTorch のインストール
where nvidia-smi >nul 2>&1
if !errorlevel! equ 0 (
    echo NVIDIA GPU detected. Installing PyTorch with CUDA 12.1 support...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --force-reinstall --no-deps
) else (
    echo No NVIDIA GPU detected. Installing PyTorch CPU version...
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --force-reinstall --no-deps
)

echo Downloading GPT-SoVITS pretrained models...
cd GPT-SoVITS\GPT_SoVITS
if not exist "pretrained_models" mkdir pretrained_models
cd pretrained_models

if not exist "chinese-hubert-base" (
    git clone https://huggingface.co/lj1995/GPT-SoVITS temp_pretrained
    xcopy /E /Y temp_pretrained\* .
    rmdir /s /q temp_pretrained
)

echo Downloading G2PW models (from HuggingFace mirror)...
cd ..\text
if not exist "G2PWModel" (
    curl.exe -L -o G2PWModel_1.1.zip https://huggingface.co/L-jasmine/GPT_Sovits/resolve/main/G2PWModel_1.1.zip
    powershell -command "Expand-Archive -Path 'G2PWModel_1.1.zip' -DestinationPath '.' -Force"
    ren G2PWModel_1.1 G2PWModel
    del G2PWModel_1.1.zip
)

echo Downloading Zundamon Fine-Tuned Models...
cd ..\..\
if not exist "GPT_weights_v2" (
    git clone https://huggingface.co/zunzunpj/zundamon_GPT-SoVITS temp_zundamon
    xcopy /E /Y temp_zundamon\GPT_weights_v2 .\GPT_weights_v2\
    xcopy /E /Y temp_zundamon\SoVITS_weights_v2 .\SoVITS_weights_v2\
    rmdir /s /q temp_zundamon
)

echo Downloading RVC Models ^& Assets...
cd Retrieval-based-Voice-Conversion-WebUI\assets
if not exist "weights" mkdir weights
if not exist "indices" mkdir indices
if not exist "rmvpe" mkdir rmvpe
if not exist "hubert" mkdir hubert

if not exist "rmvpe\rmvpe.pt" (
    curl.exe -L -o rmvpe\rmvpe.pt https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt
)
if not exist "hubert\hubert_base.pt" (
    curl.exe -L -o hubert\hubert_base.pt https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt
)

if not exist "weights\train-0814-2.pth" (
    curl.exe -L -o weights\train-0814-2.pth https://huggingface.co/zunzunpj/zundamon_RVC/resolve/main/zumdaon_rvc_indices_weights/train-0814-2.pth
)

if not exist "indices\train-0814-2_IVF256_Flat_nprobe_1_train-0814-2_v2.index" (
    curl.exe -L -o indices\train-0814-2_IVF256_Flat_nprobe_1_train-0814-2_v2.index https://huggingface.co/zunzunpj/zundamon_RVC/resolve/main/zumdaon_rvc_indices_weights/train-0814-2_IVF256_Flat_nprobe_1_train-0814-2_v2.index
)

echo Installation complete!
pause
