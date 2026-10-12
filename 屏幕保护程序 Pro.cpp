// ScreenFX.cpp —— 屏幕特效演示程序（动态适应屏幕尺寸 + 高DPI适配）
#define _CRT_SECURE_NO_WARNINGS
#define UNICODE
#define _UNICODE
#include <windows.h>
#include <wincrypt.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <cwchar>

#pragma comment(lib, "user32.lib")
#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "crypt32.lib")

// ============================================================
// 辅助 / 基础设施
// ============================================================
HCRYPTPROV prov = 0;

int myrandom(int max) {
    if (max <= 0) return 0;
    if (prov == 0) {
        CryptAcquireContext(&prov, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT);
    }
    unsigned int v = 0;
    if (prov) CryptGenRandom(prov, sizeof(v), (BYTE*)&v);
    else v = (unsigned)rand();
    return (int)(v % max);
}
#define random(x) myrandom(x)

POINT mkp(int x, int y) { POINT p; p.x = x; p.y = y; return p; }

#define thread(fn, arg) CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)(fn), (LPVOID)(arg), 0, NULL)

volatile bool g_running = true;

// 屏幕尺寸（用 volatile 保证多线程读到的是一致的）
volatile LONG g_sw = 0;
volatile LONG g_sh = 0;

void updateScreenSize() {
    g_sw = GetSystemMetrics(SM_CXSCREEN);
    g_sh = GetSystemMetrics(SM_CYSCREEN);
}

// ============================================================
// 一、屏幕绘制 / 破坏类
// ============================================================

DWORD WINAPI pat(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        int x = random(sw), y = random(sh);
        int w = sw / 20 + random(sw / 5);
        int h = sh / 20 + random(sh / 5);

        HBRUSH br = CreateSolidBrush(RGB(random(256), random(256), random(256)));
        HBRUSH old = (HBRUSH)SelectObject(hdc, br);
        PatBlt(hdc, x, y, w, h, PATINVERT);
        PatBlt(hdc, x + 5, y + 5, w - 10, h - 10, PATINVERT);
        SelectObject(hdc, old);
        DeleteObject(br);
        Sleep(30);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI wave(LPVOID) {
    HDC hdcScreen = GetDC(NULL);
    HDC hdcMem = CreateCompatibleDC(hdcScreen);

    int maxW = g_sw, maxH = g_sh;
    HBITMAP hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
    HBITMAP old = (HBITMAP)SelectObject(hdcMem, hbm);

    double t = 0;
    while (g_running) {
        int sw = g_sw, sh = g_sh;

        if (sw > maxW || sh > maxH) {
            SelectObject(hdcMem, old);
            DeleteObject(hbm);
            maxW = sw; maxH = sh;
            hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
            old = (HBITMAP)SelectObject(hdcMem, hbm);
        }

        BitBlt(hdcMem, 0, 0, sw, sh, hdcScreen, 0, 0, SRCCOPY);

        int amp = sh / 70;
        double freq = 20.0 / sh;

        for (int y = 0; y < sh; y += 2) {
            int dx = (int)(amp * sin(y * freq + t));
            StretchBlt(hdcScreen, dx, y, sw - dx, 1, hdcMem, 0, y, sw, 1, SRCCOPY);
            StretchBlt(hdcScreen, 0, y, sw + dx, 1, hdcMem, 0, y, sw, 1, SRCCOPY);
        }
        t += 0.15;
        Sleep(15);
    }
    SelectObject(hdcMem, old);
    DeleteObject(hbm);
    DeleteDC(hdcMem);
    ReleaseDC(NULL, hdcScreen);
    return 0;
}

DWORD WINAPI _Ellipse(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        HBRUSH br = CreateSolidBrush(RGB(random(256), random(256), random(256)));
        HBRUSH old = (HBRUSH)SelectObject(hdc, br);

        int x = random(sw), y = random(sh);
        int w = sw / 50 + random(sw / 7);
        int h = sh / 50 + random(sh / 7);
        Ellipse(hdc, x, y, x + w, y + h);

        SelectObject(hdc, old);
        DeleteObject(br);
        Sleep(40);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI Stretch(LPVOID) {
    HDC hdcScreen = GetDC(NULL);
    HDC hdcMem = CreateCompatibleDC(hdcScreen);
    int maxW = g_sw, maxH = g_sh;
    HBITMAP hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
    HBITMAP old = (HBITMAP)SelectObject(hdcMem, hbm);

    while (g_running) {
        int sw = g_sw, sh = g_sh;
        if (sw > maxW || sh > maxH) {
            SelectObject(hdcMem, old);
            DeleteObject(hbm);
            maxW = sw; maxH = sh;
            hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
            old = (HBITMAP)SelectObject(hdcMem, hbm);
        }

        BitBlt(hdcMem, 0, 0, sw, sh, hdcScreen, 0, 0, SRCCOPY);

        int count = 8 + (sw * sh) / 500000;
        if (count > 20) count = 20;

        for (int i = 0; i < count; i++) {
            int x = random(sw), y = random(sh);
            int w = sw / 10 + random(sw / 3);
            int h = sh / 10 + random(sh / 3);
            int nx = x + random(sw / 5) - sw / 10;
            int ny = y + random(sh / 5) - sh / 10;
            StretchBlt(hdcScreen, nx, ny, w, h, hdcMem, x, y, w, h, SRCCOPY);
        }
        Sleep(50);
    }
    SelectObject(hdcMem, old);
    DeleteObject(hbm);
    DeleteDC(hdcMem);
    ReleaseDC(NULL, hdcScreen);
    return 0;
}

DWORD WINAPI gray(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        int step = 1 + (sw * sh) / 2000000;
        if (step < 1) step = 1;
        if (step > 8) step = 8;

        for (int y = 0; y < sh; y += step) {
            for (int x = 0; x < sw; x += step) {
                COLORREF c = GetPixel(hdc, x, y);
                BYTE r = GetRValue(c), g = GetGValue(c), b = GetBValue(c);
                BYTE gray = (BYTE)((r * 30 + g * 59 + b * 11) / 100);
                SetPixel(hdc, x, y, RGB(gray, gray, gray));
            }
            if (!g_running) break;
        }
        Sleep(200);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI triangle(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        for (int i = 0; i < 12; i++) {
            POINT pts[3];
            pts[0] = mkp(random(sw), random(sh));
            pts[1] = mkp(random(sw), random(sh));
            pts[2] = mkp(random(sw), random(sh));
            HBRUSH br = CreateSolidBrush(RGB(random(256), random(256), random(256)));
            HBRUSH old = (HBRUSH)SelectObject(hdc, br);
            Polygon(hdc, pts, 3);
            SelectObject(hdc, old);
            DeleteObject(br);
        }
        Beep(200 + random(800), 30);
        Sleep(80);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI Square(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        int x = random(sw), y = random(sh);
        int w = sw / 20 + random(sw / 3);
        int h = sh / 20 + random(sh / 3);
        HBRUSH br = CreateSolidBrush(RGB(random(256), random(256), random(256)));
        RECT rc = { x, y, x + w, y + h };
        FillRect(hdc, &rc, br);
        DeleteObject(br);
        Sleep(20);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

// ============================================================
// 二、图标 / 光标干扰类
// ============================================================

DWORD WINAPI _DrawError(LPVOID) {
    HDC hdc = GetDC(NULL);
    HICON hErr = LoadIcon(NULL, IDI_ERROR);

    int x = 0, y = 0;
    int dx = 0, dy = 0;

    {
        int sw = g_sw, sh = g_sh;
        x = random(sw); y = random(sh);
        dx = (random(2) ? 1 : -1) * (5 + random(15));
        dy = (random(2) ? 1 : -1) * (5 + random(15));
    }

    while (g_running) {
        int sw = g_sw, sh = g_sh;

        if (x < 0) x = 0;
        if (x > sw) x = sw;
        if (y < 0) y = 0;
        if (y > sh) y = sh;

        DrawIcon(hdc, x, y, hErr);
        x += dx; y += dy;
        if (x < 0 || x > sw) dx = -dx;
        if (y < 0 || y > sh) dy = -dy;
        Sleep(10);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI DrawError(LPVOID) {
    HDC hdc = GetDC(NULL);
    HICON hErr = LoadIcon(NULL, IDI_ERROR);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        for (int i = 0; i < 6; i++) {
            int x = random(sw), y = random(sh);
            DrawIcon(hdc, x, y, hErr);
        }
        Sleep(60);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

DWORD WINAPI CopyCur(LPVOID) {
    HDC hdc = GetDC(NULL);
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        CURSORINFO ci = { 0 };
        ci.cbSize = sizeof(ci);
        if (GetCursorInfo(&ci) && (ci.flags & CURSOR_SHOWING)) {
            int x = random(sw), y = random(sh);
            DrawIcon(hdc, x, y, ci.hCursor);
        }
        Sleep(60);
    }
    ReleaseDC(NULL, hdc);
    return 0;
}

// ============================================================
// 三、窗口 / 消息框干扰类
// ============================================================

HHOOK g_hook = NULL;

LRESULT CALLBACK CBTProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (nCode == HCBT_ACTIVATE) {
        int sw = g_sw, sh = g_sh;
        HWND hwnd = (HWND)wParam;
        int x = random(sw > 300 ? sw - 300 : 100);
        int y = random(sh > 200 ? sh - 200 : 100);
        SetWindowPos(hwnd, NULL, x, y, 0, 0, SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
    }
    return CallNextHookEx(g_hook, nCode, wParam, lParam);
}

DWORD WINAPI msgBoxHook(LPVOID) {
    g_hook = SetWindowsHookEx(WH_CBT, CBTProc, NULL, GetCurrentThreadId());
    for (int i = 0; i < 3 && g_running; i++) {
        MessageBox(NULL, L"HOOKED", L"msgBoxHook", MB_OK | MB_SYSTEMMODAL);
        Sleep(500);
    }
    if (g_hook) UnhookWindowsHookEx(g_hook);
    return 0;
}

DWORD WINAPI MessageThread(LPVOID) {
    WCHAR title[64] = { 0 };
    WCHAR text[64] = { 0 };
    for (int i = 0; i < 8; i++) {
        title[i] = L'A' + random(26);
        text[i] = L'a' + random(26);
    }
    MessageBox(NULL, text, title, MB_OK | MB_SYSTEMMODAL | MB_ICONWARNING);
    return 0;
}

DWORD WINAPI MSGBX(LPVOID) {
    int n = 0;
    while (g_running) {
        WCHAR text[64];
        _snwprintf(text, 64, L"MSG #%d", n++);
        MessageBox(NULL, text, L"MSGBX", MB_OK | MB_SYSTEMMODAL | MB_ICONERROR);
    }
    return 0;
}

DWORD WINAPI _MSG(LPVOID) {
    MessageBox(NULL, L"TOO LATE", L"_MSG", MB_OK | MB_SYSTEMMODAL | MB_ICONHAND);
    return 0;
}

// ============================================================
// 四、输入劫持类
// ============================================================

DWORD WINAPI Click(LPVOID) {
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        int x = random(sw), y = random(sh);
        SetCursorPos(x, y);
        Sleep(20);
        mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
        Sleep(10);
        mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
        keybd_event(VK_SHIFT, 0, 0, 0);
        Sleep(10);
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        BYTE vk = (BYTE)('A' + random(26));
        keybd_event(vk, 0, 0, 0);
        keybd_event(vk, 0, KEYEVENTF_KEYUP, 0);
        Sleep(300);
    }
    return 0;
}

DWORD WINAPI MoveDesk(LPVOID) {
    HDC hdcScreen = GetDC(NULL);
    HDC hdcMem = CreateCompatibleDC(hdcScreen);
    int maxW = g_sw, maxH = g_sh;
    HBITMAP hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
    HBITMAP old = (HBITMAP)SelectObject(hdcMem, hbm);

    while (g_running) {
        int sw = g_sw, sh = g_sh;
        if (sw > maxW || sh > maxH) {
            SelectObject(hdcMem, old);
            DeleteObject(hbm);
            maxW = sw; maxH = sh;
            hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
            old = (HBITMAP)SelectObject(hdcMem, hbm);
        }

        int dx = sw / 300; if (dx < 1) dx = 1;
        int dy = sh / 300; if (dy < 1) dy = 1;

        BitBlt(hdcMem, 0, 0, sw, sh, hdcScreen, 0, 0, SRCCOPY);
        BitBlt(hdcScreen, dx, dy, sw - dx, sh - dy, hdcMem, 0, 0, SRCCOPY);
        BitBlt(hdcScreen, 0, 0, dx, sh, hdcMem, sw - dx, 0, SRCCOPY);
        BitBlt(hdcScreen, 0, 0, sw, dy, hdcMem, 0, sh - dy, SRCCOPY);
        Sleep(20);
    }
    SelectObject(hdcMem, old);
    DeleteObject(hbm);
    DeleteDC(hdcMem);
    ReleaseDC(NULL, hdcScreen);
    return 0;
}

// ============================================================
// 五、桌面 / 窗口变形类
// ============================================================

DWORD WINAPI Tunnel(LPVOID) {
    HDC hdcScreen = GetDC(NULL);
    HDC hdcMem = CreateCompatibleDC(hdcScreen);
    int maxW = g_sw, maxH = g_sh;
    HBITMAP hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
    HBITMAP old = (HBITMAP)SelectObject(hdcMem, hbm);

    double t = 0;
    while (g_running) {
        int sw = g_sw, sh = g_sh;
        if (sw > maxW || sh > maxH) {
            SelectObject(hdcMem, old);
            DeleteObject(hbm);
            maxW = sw; maxH = sh;
            hbm = CreateCompatibleBitmap(hdcScreen, maxW, maxH);
            old = (HBITMAP)SelectObject(hdcMem, hbm);
        }

        BitBlt(hdcMem, 0, 0, sw, sh, hdcScreen, 0, 0, SRCCOPY);

        int amp = sw / 50;

        POINT pts[3];
        int off = (int)(amp * sin(t));
        pts[0] = mkp(off, 0);
        pts[1] = mkp(sw + off, off / 2);
        pts[2] = mkp(0, sh);
        PlgBlt(hdcScreen, pts, hdcMem, 0, 0, sw, sh, NULL, 0, 0);
        t += 0.1;
        Sleep(25);
    }
    SelectObject(hdcMem, old);
    DeleteObject(hbm);
    DeleteDC(hdcMem);
    ReleaseDC(NULL, hdcScreen);
    return 0;
}

// 动态调用 SetProcessDPIAware，解决 MinGW 老版本链接不到的问题
void EnableDPIAware() {
    typedef BOOL (WINAPI *SetProcessDPIAwareFunc)(void);
    HMODULE hUser32 = LoadLibraryA("user32.dll");
    if (hUser32) {
        SetProcessDPIAwareFunc func = (SetProcessDPIAwareFunc)GetProcAddress(hUser32, "SetProcessDPIAware");
        if (func) func();
        FreeLibrary(hUser32);
    }
}
// ============================================================
// 主程序
// ============================================================
int main() {
    // ★ 关键：让程序感知高DPI，拿到真实物理像素
    EnableDPIAware();

    ShowWindow(GetConsoleWindow(), SW_HIDE);
    srand((unsigned)time(NULL));

    // === 第一步：识别屏幕尺寸 ===
    updateScreenSize();

    // === 第二步：启动所有特效线程 ===
    thread(pat, NULL);
    thread(wave, NULL);
    thread(_Ellipse, NULL);
    thread(Stretch, NULL);
    thread(gray, NULL);
    thread(triangle, NULL);
    thread(Square, NULL);
    thread(_DrawError, NULL);
    thread(DrawError, NULL);
    thread(CopyCur, NULL);
    thread(msgBoxHook, NULL);
    thread(MessageThread, NULL);
    thread(MSGBX, NULL);
    thread(_MSG, NULL);
    thread(Click, NULL);
    thread(MoveDesk, NULL);
    thread(Tunnel, NULL);

    // === 第三步：主循环：等待 ESC + 动态检测屏幕尺寸变化 ===
    int last_sw = g_sw, last_sh = g_sh;
    while (g_running) {
        if (GetAsyncKeyState(VK_ESCAPE) & 0x8000) {
            g_running = false;
        }

        static DWORD lastCheck = 0;
        DWORD now = GetTickCount();
        if (now - lastCheck > 3000) {
            updateScreenSize();
            if (g_sw != last_sw || g_sh != last_sh) {
                last_sw = g_sw;
                last_sh = g_sh;
            }
            lastCheck = now;
        }

        Sleep(50);
    }

    Sleep(500);
    if (prov) CryptReleaseContext(prov, 0);
    return 0;
}
