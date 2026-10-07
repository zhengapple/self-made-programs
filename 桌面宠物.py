import tkinter as tk
from PIL import Image, ImageTk, ImageDraw
import random
import time

try:
    import winsound
    HAS_SOUND = True
except ImportError:
    HAS_SOUND = False


# ========== 绘制金丝猴 ==========
def create_monkey_frame(state="idle", frame=0):
    img = Image.new("RGBA", (180, 180), (255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    body_color = (200, 160, 100, 255)
    face_color = (240, 220, 190, 255)
    dark = (80, 50, 30, 255)

    # 每个状态不同的浮动
    if state == "dance":
        offset_y = [0, -14, 0, 14, 0, -14, 0, 14][frame % 8]
        offset_x = [0, 4, 0, -4, 0, 4, 0, -4][frame % 8]
    elif state == "sleep":
        offset_y = [0, 2, 4, 2, 0, -1, -2, -1][frame % 8]
        offset_x = 0
    elif state == "hungry":
        offset_y = [0, -3, 0, 3, 0, -3, 0, 3][frame % 8]
        offset_x = [0, 2, 0, -2, 0, 2, 0, -2][frame % 8]
    elif state == "eat":
        offset_y = [0, -2, 0, 2, 0, -2, 0, 2][frame % 8]
        offset_x = 0
    else:
        offset_y = [0, -2, -4, -2, 0, 2, 4, 2][frame % 8]
        offset_x = 0

    base_x = offset_x
    base_y = offset_y

    # 身体
    draw.ellipse([30 + base_x, 70 + base_y, 140 + base_x, 150 + base_y], fill=body_color)

    # 尾巴（根据状态摆动）
    tail_swing = [0, 6, 12, 6, 0, -6, -12, -6][frame % 8]
    draw.arc([130 + base_x, 100 + base_y, 180 + base_x + tail_swing, 150 + base_y],
             start=270, end=90, fill=body_color, width=8)

    # 头
    draw.ellipse([45 + base_x, 25 + base_y, 125 + base_x, 95 + base_y], fill=body_color)

    # 耳朵
    draw.ellipse([35 + base_x, 35 + base_y, 55 + base_x, 60 + base_y], fill=body_color)
    draw.ellipse([115 + base_x, 35 + base_y, 135 + base_x, 60 + base_y], fill=body_color)

    # 脸
    draw.ellipse([58 + base_x, 42 + base_y, 112 + base_x, 88 + base_y], fill=face_color)

    # 眼睛
    if state == "sleep":
        draw.line([(68 + base_x, 62 + base_y), (78 + base_x, 62 + base_y)], fill=dark, width=3)
        draw.line([(92 + base_x, 62 + base_y), (102 + base_x, 62 + base_y)], fill=dark, width=3)
    elif state == "hungry":
        draw.ellipse([68 + base_x, 56 + base_y, 78 + base_x, 68 + base_y], fill=dark)
        draw.ellipse([92 + base_x, 56 + base_y, 102 + base_x, 68 + base_y], fill=dark)
        draw.ellipse([72 + base_x, 70 + base_y, 76 + base_x, 76 + base_y], fill=(100, 180, 255, 255))
    elif state == "dance":
        # 眯眼笑
        draw.arc([68 + base_x, 56 + base_y, 78 + base_x, 66 + base_y], start=0, end=180,
                 fill=dark, width=2)
        draw.arc([92 + base_x, 56 + base_y, 102 + base_x, 66 + base_y], start=0, end=180,
                 fill=dark, width=2)
    else:
        draw.ellipse([68 + base_x, 58 + base_y, 78 + base_x, 68 + base_y], fill=dark)
        draw.ellipse([92 + base_x, 58 + base_y, 102 + base_x, 68 + base_y], fill=dark)

    # 鼻子
    draw.ellipse([80 + base_x, 68 + base_y, 90 + base_x, 78 + base_y],
                 fill=(150, 100, 80, 255))

    # 嘴巴
    if state == "eat":
        # 张嘴
        draw.ellipse([76 + base_x, 76 + base_y, 94 + base_x, 88 + base_y], fill=(100, 30, 30, 255))
    elif state == "sleep":
        draw.arc([78 + base_x, 78 + base_y, 92 + base_x, 86 + base_y], start=180, end=360,
                 fill=dark, width=2)
    elif state == "hungry":
        draw.arc([78 + base_x, 78 + base_y, 92 + base_x, 86 + base_y], start=180, end=360,
                 fill=dark, width=2)
    else:
        draw.arc([78 + base_x, 76 + base_y, 92 + base_x, 84 + base_y], start=0, end=180,
                 fill=dark, width=2)

    # 状态特效
    if state == "poop":
        # 掉落中的粑粑
        drop_y = frame * 10
        draw.ellipse([150, 100 + drop_y, 165, 115 + drop_y], fill=(120, 80, 40, 255))

    if state == "water":
        # 花洒和水珠
        draw.rectangle([20, 10, 40, 25], fill=(150, 150, 150, 255))
        for i in range(6):
            x = 15 + i * 25
            y = 30 + (frame * 8 + i * 5) % 80
            draw.ellipse([x, y, x + 6, y + 10], fill=(100, 180, 255, 200))

    if state == "sleep":
        # 飘浮的 Z
        zy = 10 - (frame % 4) * 5
        draw.text((125, zy), "Z", fill=dark)
        draw.text((140, zy - 10), "Z", fill=dark)
        draw.text((155, zy - 20), "Z", fill=dark)

    if state == "hungry":
        # 感叹号和肚子叫的抖动
        draw.text((140, 20), "!", fill=(255, 0, 0, 255))

    if state == "eat":
        # 食物从上方掉下来
        food_y = 20 + (frame % 8) * 5
        draw.ellipse([70, food_y, 90, food_y + 20], fill=(255, 200, 0, 255))

    if state == "drink":
        # 水滴从上方滴下
        drop_y = 20 + (frame % 8) * 5
        draw.ellipse([85, drop_y, 95, drop_y + 12], fill=(100, 180, 255, 255))

    if state == "dance":
        # 音乐符号
        draw.text((150, 30), "♪", fill=(255, 100, 200, 255))
        draw.text((10, 50), "♫", fill=(255, 100, 200, 255))

    if state == "branch":
        # 树枝
        draw.rectangle([0, 150, 180, 158], fill=(120, 80, 40, 255))
        # 猴子在树枝上跳
        if frame % 4 < 2:
            pass  # 已经在上面

    return img


# ========== 状态条 ==========
class StatusBar:
    def __init__(self, parent, x, y):
        self.canvas = tk.Canvas(parent, width=180, height=34,
                                bg="white", highlightthickness=0)
        self.canvas.place(x=x, y=y)
        self.hunger = 100
        self.mood = 100

    def update(self, hunger, mood):
        self.hunger = hunger
        self.mood = mood
        self.canvas.delete("all")

        # 饥饿条
        self.canvas.create_rectangle(5, 5, 175, 14, outline="black", width=1)
        h_color = "#4CAF50" if hunger > 50 else "#FF9800" if hunger > 20 else "#F44336"
        self.canvas.create_rectangle(6, 6, 6 + int(168 * hunger / 100), 13,
                                     fill=h_color, outline="")

        # 心情条
        self.canvas.create_rectangle(5, 19, 175, 28, outline="black", width=1)
        m_color = "#2196F3" if mood > 50 else "#FF9800" if mood > 20 else "#F44336"
        self.canvas.create_rectangle(6, 20, 6 + int(168 * mood / 100), 27,
                                     fill=m_color, outline="")


class DesktopPet:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("桌面金丝猴")

        self.root.overrideredirect(True)
        self.root.wm_attributes("-topmost", True)
        self.root.wm_attributes("-transparentcolor", "white")
        self.root.config(bg="white")

        self.win_w = 180
        self.win_h = 220
        screen_w = self.root.winfo_screenwidth()
        screen_h = self.root.winfo_screenheight()
        self.x = screen_w - 280
        self.y = screen_h - 340
        self.root.geometry(f"{self.win_w}x{self.win_h}+{self.x}+{self.y}")

        self.state = "idle"
        self.state_timer = 0
        self.current_frame = 0

        self.hunger = 100
        self.mood = 100
        self.last_decay = time.time()

        self.walk_timer = time.time() + random.randint(5, 15)
        self.target_x = self.x
        self.target_y = self.y

        self.frames = {}
        self.load_frames()

        self.status_bar = StatusBar(self.root, 0, 0)

        self.tk_image = ImageTk.PhotoImage(self.frames["idle"][0])
        self.label = tk.Label(self.root, image=self.tk_image, bg="white", bd=0)
        self.label.place(x=0, y=34)

        self.label.bind("<Button-1>", self.start_drag)
        self.label.bind("<B1-Motion>", self.do_drag)

        self.menu = tk.Menu(self.root, tearoff=0)
        self.menu.add_command(label="🍌 喂食", command=self.feed)
        self.menu.add_command(label="💧 喝水", command=lambda: self.set_state("drink", 5))
        self.menu.add_command(label="💩 拉粑粑", command=lambda: self.set_state("poop", 5))
        self.menu.add_command(label="💃 跳舞", command=self.dance)
        self.menu.add_command(label="😴 睡觉", command=lambda: self.set_state("sleep", 10))
        self.menu.add_command(label="🚿 洗澡", command=lambda: self.set_state("water", 6))
        self.menu.add_command(label="🌳 树枝跳跃", command=lambda: self.set_state("branch", 6))
        self.menu.add_separator()
        self.menu.add_command(label="退出", command=self.root.destroy)
        self.label.bind("<Button-3>", self.show_menu)

        self.animate()
        self.game_loop()

    def load_frames(self):
        states = ["idle", "eat", "drink", "poop", "dance", "sleep", "water", "branch", "hungry"]
        for state in states:
            self.frames[state] = []
            for i in range(8):  # 8 帧动画
                img = create_monkey_frame(state, i)
                self.frames[state].append(img)

    def set_state(self, state, duration):
        self.state = state
        self.state_timer = duration
        self.current_frame = 0

    def feed(self):
        self.hunger = min(100, self.hunger + 30)
        self.mood = min(100, self.mood + 10)
        self.set_state("eat", 5)
        self.play_sound("eat")

    def dance(self):
        self.mood = min(100, self.mood + 20)
        self.set_state("dance", 8)
        self.play_sound("dance")

    def play_sound(self, kind):
        if not HAS_SOUND:
            return
        try:
            if kind == "eat":
                winsound.Beep(800, 100)
                winsound.Beep(1000, 100)
            elif kind == "dance":
                for f in [600, 800, 1000, 1200, 1000, 800]:
                    winsound.Beep(f, 80)
            elif kind == "hungry":
                winsound.Beep(400, 300)
        except Exception:
            pass

    def start_drag(self, event):
        self.drag_x = event.x
        self.drag_y = event.y
        self.target_x = self.root.winfo_x()
        self.target_y = self.root.winfo_y()

    def do_drag(self, event):
        new_x = self.root.winfo_x() + event.x - self.drag_x
        new_y = self.root.winfo_y() + event.y - self.drag_y
        self.root.geometry(f"+{new_x}+{new_y}")
        self.target_x = new_x
        self.target_y = new_y

    def show_menu(self, event):
        self.menu.post(event.x_root, event.y_root)

    def animate(self):
        self.current_frame = (self.current_frame + 1) % 8  # 8 帧循环

        if self.state_timer > 0:
            self.state_timer -= 0.2
        else:
            if self.state != "idle":
                self.state = "idle"
                self.state_timer = 0

        if self.state == "idle" and self.hunger < 20:
            img = self.frames["hungry"][self.current_frame]
        else:
            img = self.frames[self.state][self.current_frame]

        self.tk_image = ImageTk.PhotoImage(img)
        self.label.config(image=self.tk_image)

        self.root.after(150, self.animate)  # 150ms 一帧，动画更流畅

    def game_loop(self):
        now = time.time()

        if now - self.last_decay > 5:
            self.hunger = max(0, self.hunger - 2)
            self.mood = max(0, self.mood - 1)
            self.last_decay = now

            if self.hunger < 20 and self.state == "idle":
                self.play_sound("hungry")
                self.set_state("hungry", 3)

            self.status_bar.update(self.hunger, self.mood)

        if now > self.walk_timer:
            screen_w = self.root.winfo_screenwidth()
            screen_h = self.root.winfo_screenheight()
            self.target_x = random.randint(0, screen_w - self.win_w)
            self.target_y = random.randint(0, screen_h - self.win_h)
            self.walk_timer = now + random.randint(8, 20)

        cur_x = self.root.winfo_x()
        cur_y = self.root.winfo_y()
        if abs(cur_x - self.target_x) > 2 or abs(cur_y - self.target_y) > 2:
            step_x = (self.target_x - cur_x) // 20
            step_y = (self.target_y - cur_y) // 20
            new_x = cur_x + step_x
            new_y = cur_y + step_y
            self.root.geometry(f"+{new_x}+{new_y}")

        self.root.after(100, self.game_loop)

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    pet = DesktopPet()
    pet.run()