# my_first_flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
┣ core/
┃ ┣ constants/
┃ ┃ ┣ app_colors.dart // Màu sắc chuẩn của app
┃ ┃ ┣ app_strings.dart // Các chuỗi hằng số
┃ ┃ ┗ app_text_styles.dart // Các kiểu chữ chuẩn
┃ ┣ utils/
┃ ┃ ┣ chart_utils.dart // Hàm tiện ích cho chart
┃ ┃ ┣ date_utils.dart // Hàm tiện ích xử lý ngày tháng
┃ ┃ ┗ notification_utils.dart // Hàm tiện ích thông báo
┃ ┣ widgets/
┃ ┃ ┣ bottom_nav_bar.dart // Widget bottom navigation
┃ ┃ ┣ custom_button.dart // Widget button tuỳ chỉnh
┃ ┃ ┣ custom_card.dart // Widget Card tuỳ chỉnh
┃ ┃ ┗ section_header.dart // Header cho các section UI
┃ ┣ localization.dart // Cấu hình đa ngôn ngữ
┃ ┗ utilities.dart // Các hàm tiện ích chung
┣ data/
┃ ┣ local/
┃ ┃ ┣ hive_manager.dart // Quản lý database Hive
┃ ┃ ┗ local_storage_service.dart // Lưu/đọc dữ liệu local
┃ ┗ repositories/
┃ ┣ goal_repository.dart // Lưu trữ & truy xuất Goal
┃ ┣ routine_repository.dart // Lưu trữ & truy xuất Routine
┃ ┗ todo_repository.dart // Lưu trữ & truy xuất Todo
┣ localization/
┃ ┗ app_localization.dart // Quản lý chuỗi đa ngôn ngữ
┣ models/
┃ ┣ event_model.dart // Model Event
┃ ┣ goal.dart // Model Goal cơ bản
┃ ┣ goal_model.dart // Model Goal cho Hive/JSON
┃ ┣ goal_model.g.dart // File tự sinh Goal
┃ ┣ routine.dart // Model Routine cơ bản
┃ ┣ routine_model.dart // Model Routine cho Hive/JSON
┃ ┣ routine_model.g.dart // File tự sinh Routine
┃ ┣ stats_model.dart // Model thống kê
┃ ┣ todo.dart // Model Todo cơ bản
┃ ┣ todo_model.dart // Model Todo cho Hive/JSON
┃ ┣ todo_model.g.dart // File tự sinh Todo
┃ ┣ user.dart // Model User cơ bản
┃ ┗ user_model.dart // Model User cho Hive/JSON
┣ providers/
┃ ┣ app_state.dart // State tổng quát app
┃ ┣ event_provider.dart // State & logic Event
┃ ┣ goal_provider.dart // State & logic Goal
┃ ┣ pomodoro_provider.dart // State & logic Pomodoro
┃ ┣ routine_provider.dart // State & logic Routine
┃ ┣ stats_provider.dart // State & logic thống kê
┃ ┗ todo_provider.dart // State & logic Todo
┣ screens/
┃ ┣ calendar/
┃ ┃ ┗ calendar_screen.dart // Màn hình lịch
┃ ┣ home/
┃ ┃ ┣ goals_detail_page.dart // Chi tiết Goal
┃ ┃ ┣ goal_detail_screen.dart // Chi tiết Goal
┃ ┃ ┣ goal_dialogs.dart // Dialog thêm/sửa Goal
┃ ┃ ┣ goal_list_widget.dart // Widget danh sách Goal
┃ ┃ ┣ home_screen.dart // Màn hình Home
┃ ┃ ┗ todo_list_widget.dart // Widget danh sách Todo
┃ ┣ pomodoro/
┃ ┃ ┗ pomodoro_screen.dart // Màn hình Pomodoro
┃ ┣ routine/
┃ ┃ ┗ routine_screen.dart // Màn hình Routine
┃ ┣ settings/
┃ ┃ ┗ setting_screen.dart // Màn hình Settings
┃ ┣ stats/
┃ ┃ ┗ stats_screen.dart // Màn hình thống kê
┃ ┗ app_wrapper.dart // Widget bao quanh app
┣ services/
┃ ┣ auth_service.dart // Xử lý đăng nhập/đăng ký
┃ ┣ database_service.dart // Service database
┃ ┣ notification_service.dart // Service thông báo
┃ ┗ pomodoro_service.dart // Service Pomodoro logic
┣ app.dart // Khởi tạo MaterialApp
┗ main.dart // Entry point của app
