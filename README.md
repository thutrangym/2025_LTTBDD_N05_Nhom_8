# 📱 ỨNG DỤNG QUẢN LÝ NĂNG SUẤT CÁ NHÂN

> Ứng dụng giúp người dùng quản lý công việc, mục tiêu, thói quen và thời gian hiệu quả – được xây dựng bằng **Flutter**, hoạt động nhanh và mượt nhờ kiến trúc **Offline-first**.

---

## 🚀 TỔNG QUAN DỰ ÁN

Ứng dụng hỗ trợ người dùng:
- **Lên kế hoạch công việc hàng ngày (To-Do)**
- **Theo dõi mục tiêu (Goal Tracking)**
- **Tạo thói quen buổi sáng & tối (Routine)**
- **Lập lịch và sự kiện cá nhân (Calendar)**
- **Tối ưu hoá thời gian làm việc (Pomodoro Timer)**
- **Thống kê hiệu suất làm việc (Statistics)**
- **Tuỳ chỉnh giao diện & ngôn ngữ (Localization)**

Toàn bộ dữ liệu được lưu **cục bộ** bằng Hive, đảm bảo không mất dữ liệu khi không có mạng.

---

## 🏗️ CÔNG NGHỆ & KIẾN TRÚC

| Thành phần | Công nghệ / Mô tả |
|-------------|--------------------|
| **Framework** | Flutter |
| **Ngôn ngữ** | Dart |
| **Cơ sở dữ liệu** | Hive (Local NoSQL) |
| **State Management** | Provider |
| **Đa ngôn ngữ** | easy_localization |
| **Biểu đồ thống kê** | fl_chart |
| **Offline-first** | Tất cả dữ liệu lưu cục bộ, đồng bộ nền khi có mạng |
| **Pomodoro Service** | Bất đồng bộ (asynchronous) để không chặn UI |

---

## ⚙️ CÀI ĐẶT & CHẠY DỰ ÁN

### 1 Cài đặt môi trường
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio hoặc VS Code
- Thiết bị ảo (emulator) hoặc điện thoại thật

### 2 Clone dự án
```bash
git clone https://github.com/thutrangym/2025_LTTBDD_N05_Nhom_8.git
cd 2025_LTTBDD_N05_Nhom_8
```

### 3 Cài đặt thư viện

```
flutter pub get
```
### 4 Chạy ứng dụng
```
flutter run
```
### CẤU TRÚC THƯ MỤC CHÍNH

### TÍNH NĂNG CHÍNH
✅ **To-Do**

Thêm, sửa, xoá công việc.

Phân loại và đặt thời hạn.

Lưu trữ offline bằng Hive.

🎯 **Goal Tracking**

Tạo mục tiêu lớn và chia nhỏ thành công việc con.

Thanh tiến trình cập nhật tự động khi hoàn thành task.

🔁 **Routine**

Quản lý thói quen buổi sáng & tối.

(Hiện đang cập nhật để cải thiện tính đồng bộ.)

📅 **Calendar**

Xem lịch theo tuần, 2 tuần, tháng.

Thêm / xoá sự kiện nhanh chóng.

⏱ **Pomodoro Timer**

Chọn công việc, đặt thời gian, bắt đầu.

Dịch vụ chạy nền giúp ứng dụng không bị đơ.

Kết quả được ghi nhận cho phần thống kê.

📊 **Statistics**

Tổng hợp dữ liệu từ Todo, Goal, Pomodoro.

Biểu đồ thể hiện tiến độ theo ngày & tháng.

Sử dụng cache để tải nhanh.

🎨 **Cá nhân hóa**

Đổi theme (sáng/tối).

Đổi ngôn ngữ ngay lập tức bằng Easy Localization.

🔧 **ROADMAP**

 Sửa lỗi Routine đồng bộ trạng thái.

 Thêm tính năng đồng bộ cloud (Firebase).

 Tích hợp đăng nhập người dùng.

 Biểu đồ hiệu suất nâng cao.

 Widget màn hình chính (home widget).
