# Màn hình Đăng nhập (Flutter)

Ứng dụng Flutter cơ bản tập trung vào quản lý luồng đăng nhập, bảo mật và lưu trữ dữ liệu người dùng.

## Demo
<p align="center">
  <video src="https://github.com/user-attachments/assets/f32b7b00-5a17-4066-8aa2-da833585faa8" width="400" controls></video>
</p>

---

## 1. Mục tiêu tuần

### Mục tiêu chính
- **Xây dựng hoàn chỉnh luồng Đăng nhập/Đăng xuất:** Quản lý vòng đời phiên làm việc của người dùng.
- **Triển khai kiến trúc ứng dụng chuẩn:** Phân chia rõ ràng các layer để code dễ bảo trì và mở rộng.

### Mở rộng & Nâng cao
- **State Management & Routing:** Ứng dụng GetX để quản lý trạng thái, điều hướng (Navigation) và tiêm phụ thuộc (Dependency Injection - Bindings).
- **Lưu trữ dữ liệu (Local & Remote Storage):**
  - Sử dụng **Hive** và **Secure Storage** để lưu trữ cấu hình, trạng thái phiên đăng nhập một cách an toàn.
  - Tích hợp **Firebase** để làm mock server/database xác thực và lưu dữ liệu.
- **Giới hạn số lần đăng nhập sai**
   - Khi user nhập sai **5 lần liên tiếp** → khóa tài khoản **5 phút**.
   - Hiển thị thông báo: *“Tài khoản của bạn đã bị tạm khoá trong 5 phút do nhập sai nhiều lần.”*
   - Sau thời gian này có thể thử lại.
- **Auto fill**
   - Trên Android/iOS: khi user bấm vào field, hệ thống gợi ý tài khoản & mật khẩu đã lưu.
- **Animation khi nhập sai**
   - Hiển thị shake animation cho cả form khi user nhập sai.
---

## 2. Kiến trúc (Architecture)

Dự án áp dụng mô hình kiến trúc phân lớp (Layered Architecture) kết hợp với **GetX** nhằm tách biệt Logic và UI. Cấu trúc thư mục cốt lõi gồm:

- **`lib/presentation/` (UI & State):**
  - **Views (`views/`):** Các màn hình hiển thị (`HomeScreen`, `LoginScreen`) và các component UI (`widgets/`).
  - **Controllers (`controller/`):** Xử lý logic nghiệp vụ, quản lý trạng thái hiển thị (`login_controller`, `user_controller`).
  - **Bindings (`binding/`):** Nơi khai báo và khởi tạo Controller để tiêm (inject) vào View, giúp tối ưu bộ nhớ.

- **`lib/repo/` & `lib/data/` (Data Layer):**
  - **Data Sources:** `local/` (xử lý Hive/Secure Storage qua `setting_box`, `user_box`) và `remote/` (xử lý `firebase_firestore`).
  - **Repositories:** (`AuthRepo`, `UserRepo`) Cung cấp các API trừu tượng hóa việc truy cập dữ liệu, áp dụng mẫu **Singleton & Factory** để tiết kiệm tài nguyên bộ nhớ.

- **`lib/core/` (Core Framework):** Chứa các định nghĩa chung như routing (`app_pages`, `app_routes`), giao diện (`theme`), xử lý lỗi (`exceptions`), hằng số chữ (`AppStrings`).

- **`lib/models/` (Data Models):** Các Entity object định hình dữ liệu (`UserModel`, `session_login`).

---

## 3. Hướng dẫn chạy dự án

### Yêu cầu môi trường (Prerequisites)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Khuyến nghị phiên bản Stable mới nhất).
- CocoaPods (Nếu bạn build ứng dụng trên iOS/macOS).

### Cấu hình Firebase
- Liên hệ lấy file `google-services.json` đặt vào `android/app/`.
- Lấy file `GoogleService-Info.plist` đặt vào `ios/Runner/` và `macos/Runner/`.
- File cấu hình Dart `firebase_options.dart` đặt trong thư mục `lib/`.

### Chạy ứng dụng & Dữ liệu mẫu (Sample Data)
- **Cài đặt thư viện:** Chạy lệnh `flutter pub get`.
- **Chạy ứng dụng:** `flutter run` hoặc dùng công cụ Run của VS Code/Android Studio.
- **Tài khoản Test:** Do dữ liệu được lấy từ Firebase kết hợp Hash Password, bạn có thể tự đăng ký một tài khoản mới trực tiếp từ giao diện (nếu có tính năng Đăng ký) hoặc sử dụng bộ Credentials test (do team cung cấp) nhập vào màn hình Đăng nhập để verify luồng.

---

## 4. Flow chính (Luồng Hoạt Động)

1. **Khởi động ứng dụng (`main.dart`):**
   - Khởi tạo các services thiết yếu: Hive, Firebase, Secure Storage.
   - Đọc trạng thái `isFirstLogin` / Session từ Hive box hoặc Secure Storage.
   - **Routing:** 
     - Nếu chưa đăng nhập / đã đăng xuất: Hiển thị `LoginScreen`.
     - Nếu đã đăng nhập hợp lệ: Lấy thông tin user hiện tại và điều hướng thẳng vào `HomeScreen`.

2. **Đăng nhập (`LoginScreen`):**
   - Người dùng nhập thông tin. Form sẽ tự động gợi ý / điền sẵn thông tin phiên làm việc trước nếu đã được lưu.
   - Gọi `LoginController` để gửi dữ liệu xuống `AuthRepo` xác thực (kết hợp với `hash_password` để tăng tính bảo mật).
   - Nếu **Thành công**: Lưu thông tin Session vào Hive, cập nhật `isFirstLogin = false` và chuyển hướng tới `HomeScreen`.
   - Nếu **Thất bại**: Hiển thị Error Dialog thông báo lỗi rõ ràng.

3. **Đăng xuất (`HomeScreen`):**
   - Nhấn nút Đăng xuất qua `UserController`.
   - Đánh dấu trạng thái `isLoginned = false`, xóa cache thông tin Session ở Local Storage.
   - Cập nhật trạng thái và điều hướng trở về `LoginScreen`.
