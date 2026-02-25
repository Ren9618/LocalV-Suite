import { useState, useEffect } from 'react';
import './Overlay.css';

interface LogEntry {
    id: number;
    timestamp: string;
    userComment: string;
    aiReply: string;
    source: 'ai' | 'filter' | 'error';
    processingMs: number;
}

function Overlay() {
    const [currentMessage, setCurrentMessage] = useState<LogEntry | null>(null);
    const [fade, setFade] = useState(false);

    useEffect(() => {
        // ログエントリの受信
        window.electron.onLogEntry((entry: LogEntry) => {
            if (entry.source === 'error') return; // エラーは表示しない

            setCurrentMessage(entry);
            setFade(false); // 即座に表示

            // 10秒後にフェードアウトを開始するタイマー
            const timer = setTimeout(() => {
                setFade(true);
            }, 10000);

            return () => clearTimeout(timer);
        });
    }, []);

    if (!currentMessage) {
        return null; // メッセージがない場合は何も表示しない（完全な透過）
    }

    return (
        <div className={`overlay-container ${fade ? 'fade-out' : 'fade-in'}`}>
            <div className="overlay-content">
                <div className="overlay-user">{currentMessage.userComment}</div>
                <div className="overlay-reply">{currentMessage.aiReply}</div>
            </div>
        </div>
    );
}

export default Overlay;
