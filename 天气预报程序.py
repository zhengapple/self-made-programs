import tkinter as tk
from tkinter import ttk, messagebox
import requests
import threading
from datetime import datetime

# ========== 城市经纬度表（常用城市） ==========
CITY_COORDS = {
    "北京": (39.9042, 116.4074),
    "上海": (31.2304, 121.4737),
    "广州": (23.1291, 113.2644),
    "深圳": (22.5431, 114.0579),
    "天津": (39.3434, 117.3616),
    "重庆": (29.5630, 106.5516),
    "杭州": (30.2741, 120.1551),
    "南京": (32.0603, 118.7969),
    "武汉": (30.5928, 114.3055),
    "成都": (30.5728, 104.0668),
    "西安": (34.3416, 108.9398),
    "长沙": (28.2282, 112.9388),
    "郑州": (34.7466, 113.6254),
    "济南": (36.6512, 117.1201),
    "青岛": (36.0671, 120.3826),
    "沈阳": (41.8057, 123.4315),
    "哈尔滨": (45.8038, 126.5349),
    "长春": (43.8171, 125.3235),
    "石家庄": (38.0428, 114.5149),
    "太原": (37.8706, 112.5489),
    "合肥": (31.8206, 117.2272),
    "福州": (26.0745, 119.2965),
    "厦门": (24.4798, 118.0894),
    "南昌": (28.6820, 115.8579),
    "昆明": (24.8801, 102.8329),
    "贵阳": (26.6470, 106.6302),
    "南宁": (22.8170, 108.3665),
    "海口": (20.0444, 110.1999),
    "兰州": (36.0611, 103.8343),
    "西宁": (36.6171, 101.7782),
    "银川": (38.4872, 106.2309),
    "乌鲁木齐": (43.8256, 87.6168),
    "拉萨": (29.6500, 91.1000),
    "呼和浩特": (40.8414, 111.7519),
}

# 天气代码 -> 中文描述
WEATHER_CODES = {
    0: "晴", 1: "多云", 2: "多云", 3: "阴",
    45: "雾", 48: "雾凇",
    51: "毛毛雨", 53: "小雨", 55: "中雨",
    61: "小雨", 63: "中雨", 65: "大雨",
    71: "小雪", 73: "中雪", 75: "大雪",
    80: "阵雨", 81: "强阵雨", 82: "暴雨",
    95: "雷阵雨", 96: "雷阵雨伴冰雹", 99: "强雷暴",
}


class WeatherApp:
    def __init__(self, root):
        self.root = root
        self.root.title("天气预报 - Open-Meteo")
        self.root.geometry("620x640")
        self.root.resizable(False, False)
        self._build_ui()

    def _build_ui(self):
        # 顶部：城市选择 + 查询按钮
        top = ttk.Frame(self.root, padding=10)
        top.pack(fill="x")

        ttk.Label(top, text="选择城市：").pack(side="left")
        self.city_var = tk.StringVar(value="北京")
        self.city_combo = ttk.Combobox(top, textvariable=self.city_var,
                                       values=list(CITY_COORDS.keys()),
                                       state="readonly", width=12)
        self.city_combo.pack(side="left", padx=5)

        ttk.Button(top, text="查询", command=self.query_weather).pack(side="left", padx=5)
        ttk.Button(top, text="刷新", command=self.query_weather).pack(side="left")

        # 当前天气
        self.current_frame = ttk.LabelFrame(self.root, text="当前天气", padding=10)
        self.current_frame.pack(fill="x", padx=10, pady=5)

        self.current_label = ttk.Label(self.current_frame, text="点击查询获取天气",
                                       font=("微软雅黑", 12), justify="left")
        self.current_label.pack(anchor="w")

        # 未来几天
        self.forecast_frame = ttk.LabelFrame(self.root, text="未来 7 天", padding=10)
        self.forecast_frame.pack(fill="both", expand=True, padx=10, pady=5)

        columns = ("date", "weather", "temp_max", "temp_min", "rain")
        self.tree = ttk.Treeview(self.forecast_frame, columns=columns,
                                 show="headings", height=8)
        self.tree.heading("date", text="日期")
        self.tree.heading("weather", text="天气")
        self.tree.heading("temp_max", text="最高温")
        self.tree.heading("temp_min", text="最低温")
        self.tree.heading("rain", text="降水概率")
        self.tree.column("date", width=100, anchor="center")
        self.tree.column("weather", width=120, anchor="center")
        self.tree.column("temp_max", width=90, anchor="center")
        self.tree.column("temp_min", width=90, anchor="center")
        self.tree.column("rain", width=100, anchor="center")
        self.tree.pack(fill="both", expand=True)

        # 状态栏
        self.status = ttk.Label(self.root, text="就绪", relief="sunken", anchor="w")
        self.status.pack(fill="x", side="bottom")

    def set_status(self, text):
        self.status.config(text=text)
        self.root.update_idletasks()

    def query_weather(self):
        city = self.city_var.get()
        coords = CITY_COORDS.get(city)
        if not coords:
            messagebox.showerror("错误", "未找到该城市")
            return
        threading.Thread(target=self._fetch_weather,
                         args=(city, coords[0], coords[1]), daemon=True).start()

    def _fetch_weather(self, city, lat, lon):
        self.root.after(0, lambda: self.set_status(f"正在查询 {city} 的天气..."))

        try:
            url = "https://api.open-meteo.com/v1/forecast"
            params = {
                "latitude": lat,
                "longitude": lon,
                "current": "temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code",
                "daily": "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max",
                "timezone": "Asia/Shanghai",
                "forecast_days": 7,
            }
            r = requests.get(url, params=params, timeout=15)
            r.raise_for_status()
            data = r.json()

            self.root.after(0, self._update_ui, city, data)

        except Exception as e:
            err_msg = str(e)
            self.root.after(0, lambda msg=err_msg: self.set_status(f"查询失败：{msg}"))
            self.root.after(0, lambda msg=err_msg: messagebox.showerror("错误", f"查询失败：\n{msg}"))

    def _update_ui(self, city, data):
        current = data.get("current", {})
        daily = data.get("daily", {})

        # 当前天气
        code = current.get("weather_code", -1)
        weather_text = WEATHER_CODES.get(code, f"未知({code})")
        text = f"城市：{city}\n"
        text += f"温度：{current.get('temperature_2m', 'N/A')}°C\n"
        text += f"天气：{weather_text}\n"
        text += f"湿度：{current.get('relative_humidity_2m', 'N/A')}%\n"
        text += f"风速：{current.get('wind_speed_10m', 'N/A')} km/h\n"
        text += f"更新时间：{current.get('time', 'N/A')}"
        self.current_label.config(text=text)

        # 清空表格
        for row in self.tree.get_children():
            self.tree.delete(row)

        # 7 天预报
        dates = daily.get("time", [])
        codes = daily.get("weather_code", [])
        t_max = daily.get("temperature_2m_max", [])
        t_min = daily.get("temperature_2m_min", [])
        rains = daily.get("precipitation_probability_max", [])

        for i in range(len(dates)):
            date = dates[i]
            code = codes[i] if i < len(codes) else -1
            weather = WEATHER_CODES.get(code, f"未知({code})")
            tmax = t_max[i] if i < len(t_max) else "N/A"
            tmin = t_min[i] if i < len(t_min) else "N/A"
            rain = rains[i] if i < len(rains) else "N/A"
            self.tree.insert("", "end",
                             values=(date, weather, f"{tmax}°C", f"{tmin}°C", f"{rain}%"))

        self.set_status(f"查询完成 - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


if __name__ == "__main__":
    root = tk.Tk()
    app = WeatherApp(root)
    root.mainloop()