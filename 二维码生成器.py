import os
import sys
import json
import qrcode
from qrcode.constants import ERROR_CORRECT_L, ERROR_CORRECT_M, ERROR_CORRECT_Q, ERROR_CORRECT_H
from PIL import Image, ImageTk, ImageDraw, ImageFont
import tkinter as tk
from tkinter import ttk, filedialog, messagebox, colorchooser
import pyperclip

# 扫描解码（可选）
try:
    from pyzbar.pyzbar import decode as zbar_decode
    HAS_ZBAR = True
except ImportError:
    HAS_ZBAR = False

HISTORY_FILE = "qr_history.json"


class QRCodeGenerator:
    def __init__(self, root):
        self.root = root
        self.root.title("二维码生成器 Pro")
        self.root.geometry("1080x680")
        self.root.resizable(False, False)

        self.current_qr_image = None
        self.logo_image = None
        self.dark_mode = False
        self.history = self._load_history()

        self._build_ui()
        self._bind_events()

        # 启动时先刷新一下历史列表
        self._refresh_history_list()

    # ---------------- 历史记录 ----------------
    def _load_history(self):
        if os.path.exists(HISTORY_FILE):
            try:
                with open(HISTORY_FILE, "r", encoding="utf-8") as f:
                    return json.load(f)
            except Exception:
                return []
        return []

    def _save_history(self):
        try:
            with open(HISTORY_FILE, "w", encoding="utf-8") as f:
                json.dump(self.history[-50:], f, ensure_ascii=False, indent=2)
        except Exception:
            pass

    def _add_history(self, content):
        if not content:
            return
        if content in self.history:
            self.history.remove(content)
        self.history.append(content)
        self._save_history()
        self._refresh_history_list()

    def _refresh_history_list(self):
        self.history_list.delete(0, tk.END)
        for item in reversed(self.history):
            self.history_list.insert(tk.END, item)

    # ---------------- UI 构建 ----------------
    def _build_ui(self):
        # 左侧：输入区
        self.left_frame = ttk.LabelFrame(self.root, text="输入内容", padding=10)
        self.left_frame.place(x=10, y=10, width=420, height=660)

        ttk.Label(self.left_frame, text="文本 / 网址 / 数字：").pack(anchor="w")
        self.text_input = tk.Text(self.left_frame, width=48, height=5, wrap="word")
        self.text_input.pack(pady=5)

        # 模板按钮
        tpl_frame = ttk.LabelFrame(self.left_frame, text="快捷模板", padding=5)
        tpl_frame.pack(fill="x", pady=(5, 0))
        ttk.Button(tpl_frame, text="WiFi", width=8, command=self._tpl_wifi).pack(side="left", padx=2)
        ttk.Button(tpl_frame, text="名片", width=8, command=self._tpl_vcard).pack(side="left", padx=2)
        ttk.Button(tpl_frame, text="短信", width=8, command=self._tpl_sms).pack(side="left", padx=2)
        ttk.Button(tpl_frame, text="邮件", width=8, command=self._tpl_email).pack(side="left", padx=2)

        ttk.Label(self.left_frame, text="容错级别：").pack(anchor="w", pady=(10, 0))
        self.error_level = ttk.Combobox(self.left_frame, values=["L (7%)", "M (15%)", "Q (25%)", "H (30%)"],
                                        state="readonly")
        self.error_level.current(1)
        self.error_level.pack(fill="x", pady=3)

        ttk.Label(self.left_frame, text="尺寸（像素）：").pack(anchor="w", pady=(10, 0))
        self.size_scale = ttk.Scale(self.left_frame, from_=100, to=1000, orient="horizontal",
                                    command=self._on_size_change)
        self.size_scale.set(300)
        self.size_scale.pack(fill="x")
        self.size_label = ttk.Label(self.left_frame, text="300 x 300")
        self.size_label.pack(anchor="w")

        ttk.Label(self.left_frame, text="边距（模块数）：").pack(anchor="w", pady=(10, 0))
        self.border_scale = ttk.Scale(self.left_frame, from_=0, to=10, orient="horizontal")
        self.border_scale.set(4)
        self.border_scale.pack(fill="x")

        # 颜色
        color_frame = ttk.Frame(self.left_frame)
        color_frame.pack(fill="x", pady=(10, 0))
        ttk.Label(color_frame, text="前景色：").pack(side="left")
        self.fg_color = "#000000"
        self.fg_btn = tk.Button(color_frame, bg=self.fg_color, width=4, command=self._choose_fg_color)
        self.fg_btn.pack(side="left", padx=5)
        ttk.Label(color_frame, text="背景色：").pack(side="left", padx=(15, 0))
        self.bg_color = "#FFFFFF"
        self.bg_btn = tk.Button(color_frame, bg=self.bg_color, width=4, command=self._choose_bg_color)
        self.bg_btn.pack(side="left", padx=5)

        # Logo
        logo_frame = ttk.Frame(self.left_frame)
        logo_frame.pack(fill="x", pady=(10, 0))
        ttk.Button(logo_frame, text="选择 Logo", command=self._choose_logo).pack(side="left")
        ttk.Button(logo_frame, text="清除 Logo", command=self._clear_logo).pack(side="left", padx=5)
        self.logo_label = ttk.Label(logo_frame, text="未选择")
        self.logo_label.pack(side="left", padx=5)

        # 水印
        ttk.Label(self.left_frame, text="水印文字（可留空）：").pack(anchor="w", pady=(10, 0))
        self.watermark_entry = ttk.Entry(self.left_frame)
        self.watermark_entry.pack(fill="x")

        # 按钮区
        btn_frame = ttk.Frame(self.left_frame)
        btn_frame.pack(fill="x", pady=(15, 0))
        ttk.Button(btn_frame, text="生成", command=self.generate_qr).pack(side="left")
        ttk.Button(btn_frame, text="保存", command=self.save_qr).pack(side="left", padx=5)
        ttk.Button(btn_frame, text="复制", command=self.copy_to_clipboard).pack(side="left", padx=5)
        ttk.Button(btn_frame, text="批量生成", command=self.batch_generate).pack(side="left", padx=5)

        ttk.Button(self.left_frame, text="扫描/解码图片", command=self.scan_qr).pack(fill="x", pady=(10, 0))
        ttk.Button(self.left_frame, text="切换主题", command=self._toggle_theme).pack(fill="x", pady=(5, 0))

        # 中间：预览区
        self.mid_frame = ttk.LabelFrame(self.root, text="预览", padding=10)
        self.mid_frame.place(x=440, y=10, width=400, height=660)
        self.preview_label = ttk.Label(self.mid_frame, text="二维码将在这里显示",
                                       background="#f0f0f0", anchor="center")
        self.preview_label.pack(fill="both", expand=True)

        # 右侧：历史记录
        self.right_frame = ttk.LabelFrame(self.root, text="历史记录", padding=10)
        self.right_frame.place(x=850, y=10, width=220, height=660)
        self.history_list = tk.Listbox(self.right_frame, width=28)
        self.history_list.pack(fill="both", expand=True)
        self.history_list.bind("<<ListboxSelect>>", self._on_history_select)
        ttk.Button(self.right_frame, text="清空历史", command=self._clear_history).pack(fill="x", pady=(5, 0))

    def _bind_events(self):
        self.text_input.bind("<KeyRelease>", lambda e: self.generate_qr())

    # ---------------- 事件处理 ----------------
    def _on_size_change(self, value):
        self.size_label.config(text=f"{int(float(value))} x {int(float(value))}")

    def _choose_fg_color(self):
        color = colorchooser.askcolor(color=self.fg_color, title="选择前景色")[1]
        if color:
            self.fg_color = color
            self.fg_btn.config(bg=color)
            self.generate_qr()

    def _choose_bg_color(self):
        color = colorchooser.askcolor(color=self.bg_color, title="选择背景色")[1]
        if color:
            self.bg_color = color
            self.bg_btn.config(bg=color)
            self.generate_qr()

    def _choose_logo(self):
        path = filedialog.askopenfilename(title="选择 Logo 图片",
                                          filetypes=[("图片", "*.png *.jpg *.jpeg *.bmp")])
        if path:
            self.logo_image = Image.open(path).convert("RGBA")
            self.logo_label.config(text=os.path.basename(path))
            self.generate_qr()

    def _clear_logo(self):
        self.logo_image = None
        self.logo_label.config(text="未选择")
        self.generate_qr()

    def _on_history_select(self, event):
        sel = self.history_list.curselection()
        if sel:
            content = self.history_list.get(sel[0])
            self.text_input.delete("1.0", tk.END)
            self.text_input.insert("1.0", content)
            self.generate_qr()

    def _clear_history(self):
        if messagebox.askyesno("确认", "确定要清空历史记录吗？"):
            self.history = []
            self._save_history()
            self._refresh_history_list()

    def _toggle_theme(self):
        self.dark_mode = not self.dark_mode
        if self.dark_mode:
            self.root.configure(bg="#2b2b2b")
            self.preview_label.configure(background="#3c3c3c", foreground="#ffffff")
        else:
            self.root.configure(bg="#f0f0f0")
            self.preview_label.configure(background="#f0f0f0", foreground="#000000")

    # ---------------- 快捷模板 ----------------
    def _tpl_wifi(self):
        self.text_input.delete("1.0", tk.END)
        self.text_input.insert("1.0", "WIFI:T:WPA;S:网络名;P:密码;;")

    def _tpl_vcard(self):
        self.text_input.delete("1.0", tk.END)
        self.text_input.insert("1.0",
            "BEGIN:VCARD\nVERSION:3.0\nN:姓;名\nFN:全名\nTEL:13800138000\nEMAIL:mail@example.com\nEND:VCARD")

    def _tpl_sms(self):
        self.text_input.delete("1.0", tk.END)
        self.text_input.insert("1.0", "SMSTO:13800138000:你好")

    def _tpl_email(self):
        self.text_input.delete("1.0", tk.END)
        self.text_input.insert("1.0", "mailto:mail@example.com?subject=主题&body=正文")

    # ---------------- 核心生成 ----------------
    def _get_error_level(self):
        mapping = {"L (7%)": ERROR_CORRECT_L, "M (15%)": ERROR_CORRECT_M,
                   "Q (25%)": ERROR_CORRECT_Q, "H (30%)": ERROR_CORRECT_H}
        return mapping.get(self.error_level.get(), ERROR_CORRECT_M)

    def generate_qr(self):
        content = self.text_input.get("1.0", "end-1c")
        if not content.strip():
            self.preview_label.config(image="", text="请输入内容")
            self.current_qr_image = None
            return

        try:
            qr = qrcode.QRCode(error_correction=self._get_error_level(),
                               box_size=10, border=int(self.border_scale.get()))
            qr.add_data(content)
            qr.make(fit=True)
            img = qr.make_image(fill_color=self.fg_color, back_color=self.bg_color).convert("RGB")

            if self.logo_image:
                img = self._embed_logo(img)

            target_size = int(self.size_scale.get())
            img = img.resize((target_size, target_size), Image.LANCZOS)

            # 水印
            watermark = self.watermark_entry.get().strip()
            if watermark:
                img = self._add_watermark(img, watermark)

            self.current_qr_image = img
            preview = img.copy()
            preview.thumbnail((380, 560))
            self.tk_preview = ImageTk.PhotoImage(preview)
            self.preview_label.config(image=self.tk_preview, text="")

            self._add_history(content)

        except Exception as e:
            self.preview_label.config(image="", text=f"生成失败：{e}")
            self.current_qr_image = None

    def _embed_logo(self, qr_img):
        qr_w, qr_h = qr_img.size
        logo_size = int(min(qr_w, qr_h) * 0.22)
        logo = self.logo_image.copy()
        logo.thumbnail((logo_size, logo_size), Image.LANCZOS)
        bg_size = logo_size + 16
        logo_bg = Image.new("RGBA", (bg_size, bg_size), (255, 255, 255, 255))
        pos = ((qr_w - logo.width) // 2, (qr_h - logo.height) // 2)
        bg_pos = ((qr_w - bg_size) // 2, (qr_h - bg_size) // 2)
        qr_img.paste(logo_bg, bg_pos, logo_bg)
        qr_img.paste(logo, pos, logo)
        return qr_img

    def _add_watermark(self, img, text):
        # 在下方增加一块区域显示水印
        w, h = img.size
        bar_height = max(30, h // 15)
        new_img = Image.new("RGB", (w, h + bar_height), self.bg_color)
        new_img.paste(img, (0, 0))
        draw = ImageDraw.Draw(new_img)
        try:
            font = ImageFont.truetype("msyh.ttc", bar_height // 2)
        except Exception:
            font = ImageFont.load_default()
        bbox = draw.textbbox((0, 0), text, font=font)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        draw.text(((w - tw) // 2, h + (bar_height - th) // 2), text,
                  fill=self.fg_color, font=font)
        return new_img

    # ---------------- 保存与复制 ----------------
    def save_qr(self):
        if not self.current_qr_image:
            messagebox.showwarning("提示", "还没有生成二维码")
            return
        path = filedialog.asksaveasfilename(
            defaultextension=".png",
            filetypes=[("PNG", "*.png"), ("JPG", "*.jpg"), ("BMP", "*.bmp")],
            title="保存二维码")
        if path:
            try:
                self.current_qr_image.save(path)
                messagebox.showinfo("成功", f"已保存到：\n{path}")
            except Exception as e:
                messagebox.showerror("错误", f"保存失败：{e}")

    def copy_to_clipboard(self):
        if not self.current_qr_image:
            messagebox.showwarning("提示", "还没有生成二维码")
            return
        try:
            output = os.path.join(os.environ["TEMP"], "temp_qr.png")
            self.current_qr_image.save(output)
            pyperclip.copy(output)
            messagebox.showinfo("提示", f"二维码路径已复制：\n{output}")
        except Exception as e:
            messagebox.showerror("错误", f"复制失败：{e}")

    # ---------------- 批量生成 ----------------
    def batch_generate(self):
        path = filedialog.askopenfilename(title="选择文本文件（每行一条内容）",
                                          filetypes=[("文本文件", "*.txt")])
        if not path:
            return
        out_dir = filedialog.askdirectory(title="选择输出目录")
        if not out_dir:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                lines = [line.strip() for line in f if line.strip()]
            for i, content in enumerate(lines, 1):
                qr = qrcode.QRCode(error_correction=self._get_error_level(),
                                   box_size=10, border=int(self.border_scale.get()))
                qr.add_data(content)
                qr.make(fit=True)
                img = qr.make_image(fill_color=self.fg_color,
                                    back_color=self.bg_color).convert("RGB")
                img = img.resize((int(self.size_scale.get()), int(self.size_scale.get())), Image.LANCZOS)
                img.save(os.path.join(out_dir, f"qr_{i:04d}.png"))
            messagebox.showinfo("成功", f"已批量生成 {len(lines)} 张二维码。")
        except Exception as e:
            messagebox.showerror("错误", f"批量生成失败：{e}")

    # ---------------- 扫描解码 ----------------
    def scan_qr(self):
        if not HAS_ZBAR:
            messagebox.showerror("缺少库", "未安装 pyzbar，无法扫描解码。\n请执行：pip install pyzbar")
            return
        path = filedialog.askopenfilename(title="选择二维码图片",
                                          filetypes=[("图片", "*.png *.jpg *.jpeg *.bmp")])
        if not path:
            return
        try:
            img = Image.open(path)
            results = zbar_decode(img)
            if not results:
                messagebox.showinfo("结果", "未识别到二维码。")
                return
            content = results[0].data.decode("utf-8", errors="replace")
            self.text_input.delete("1.0", tk.END)
            self.text_input.insert("1.0", content)
            self.generate_qr()
            messagebox.showinfo("识别成功", f"内容：\n{content}")
        except Exception as e:
            messagebox.showerror("错误", f"扫描失败：{e}")


if __name__ == "__main__":
    root = tk.Tk()
    app = QRCodeGenerator(root)
    root.mainloop()