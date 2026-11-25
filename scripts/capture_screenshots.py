import base64
import http.server
import json
import os
import socket
import socketserver
import subprocess
import threading
import time
import urllib.request

PORT = 8099
DIRECTORY = 'build/web'

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    def log_message(self, format, *args):
        pass

def capture_url(url, output_path, wait_sec=6, scroll=False):
    chrome_exe = r'C:\Program Files\Google\Chrome\Application\chrome.exe'
    user_data = os.path.abspath('temp_chrome_profile')
    os.makedirs(user_data, exist_ok=True)

    chrome_proc = subprocess.Popen([
        chrome_exe,
        '--headless=new',
        '--remote-debugging-port=9222',
        f'--user-data-dir={user_data}',
        '--window-size=420,920',
        url
    ])

    time.sleep(wait_sec)

    try:
        tabs = json.loads(urllib.request.urlopen('http://localhost:9222/json').read().decode())
        target_tab = [tb for tb in tabs if tb.get('type') == 'page' and 'localhost' in tb.get('url', '')][0]
        ws_url = target_tab['webSocketDebuggerUrl']
        path = ws_url.split('localhost:9222')[1]

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect(('localhost', 9222))
        key = base64.b64encode(os.urandom(16)).decode()
        handshake = (
            f"GET {path} HTTP/1.1\r\n"
            "Host: localhost:9222\r\n"
            "Upgrade: websocket\r\n"
            "Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {key}\r\n"
            "Sec-WebSocket-Version: 13\r\n\r\n"
        )
        s.send(handshake.encode())
        _ = s.recv(4096)

        def send_cdp(method, params=None, req_id=1):
            msg = {'id': req_id, 'method': method}
            if params:
                msg['params'] = params
            payload = json.dumps(msg).encode('utf-8')
            mask = os.urandom(4)
            masked = bytes(b ^ mask[i % 4] for i, b in enumerate(payload))
            length = len(payload)
            if length < 126:
                header = bytes([0x81, 0x80 | length]) + mask
            elif length <= 65535:
                header = bytes([0x81, 0x80 | 126, (length >> 8) & 0xFF, length & 0xFF]) + mask
            else:
                header = bytes([0x81, 0x80 | 127]) + length.to_bytes(8, 'big') + mask
            s.send(header + masked)

        def recv_json(target_id):
            buf = bytearray()
            s.settimeout(12)
            while True:
                chunk = s.recv(65536)
                if not chunk:
                    break
                buf.extend(chunk)
                needle = f'"id":{target_id}'.encode()
                if needle in buf and b'"data":' in buf:
                    idx = buf.find(b'{"id":' + str(target_id).encode())
                    if idx != -1:
                        raw = buf[idx:]
                        last_brace = raw.rfind(b'}')
                        if last_brace != -1:
                            try:
                                return json.loads(raw[:last_brace+1].decode('utf-8', errors='ignore'))
                            except Exception:
                                pass

        if scroll:
            send_cdp("Input.dispatchMouseEvent", {"type": "mouseWheel", "x": 200, "y": 400, "deltaX": 0, "deltaY": 450}, 82)
            time.sleep(1)

        send_cdp("Page.captureScreenshot", req_id=10)
        res = recv_json(10)
        if res and 'result' in res and 'data' in res['result']:
            with open(output_path, 'wb') as f:
                f.write(base64.b64decode(res['result']['data']))
            print(f"Captured {output_path} ({os.path.getsize(output_path)} bytes)")

        s.close()
    except Exception as e:
        print(f"Error capturing {url}:", e)
    finally:
        chrome_proc.terminate()
        time.sleep(1)

def main():
    os.makedirs('screenshots', exist_ok=True)
    httpd = socketserver.TCPServer(('', PORT), Handler)
    t = threading.Thread(target=httpd.serve_forever, daemon=True)
    t.start()
    print(f"HTTP Server started at http://localhost:{PORT}")

    try:
        # 1. Home Screen (top)
        capture_url(f'http://localhost:{PORT}/#/', 'screenshots/1_home_screen.png', wait_sec=7, scroll=False)

        # 2. Home Screen (scrolled down to 7-day forecast)
        capture_url(f'http://localhost:{PORT}/#/', 'screenshots/2_forecast_scroll.png', wait_sec=7, scroll=True)

        # 3. Search Screen with live query "Bandung"
        capture_url(f'http://localhost:{PORT}/#/search', 'screenshots/3_search_screen.png', wait_sec=7, scroll=False)

        # 4. Favorites Screen
        capture_url(f'http://localhost:{PORT}/#/favorites', 'screenshots/4_favorites_screen.png', wait_sec=5, scroll=False)

    finally:
        httpd.shutdown()

if __name__ == '__main__':
    main()
