# bt1 - Màn hình login

Ứng dụng Flutter quản lý đăng nhập sử dụng cơ sở dữ liệu Hive.

## 1. Workflow (Luồng Hoạt Động)

1. **Khởi động ứng dụng (`main.dart`):**
   - Đọc cờ `isFirstLogin` từ Hive box `'settings'` (mặc định là `true`).
   - Nếu `isFirstLogin` là `true` (chưa đăng nhập hoặc đã đăng xuất), ứng dụng hiển thị `LoginScreen`.
   - Nếu `isFirstLogin` là `false` (đã đăng nhập), ứng dụng lấy thông tin user hiện tại từ DB và điều hướng thẳng vào `HomeScreen`.

2. **Đăng nhập (`LoginScreen.dart`):**
   - Kiểm tra thông tin nhập vào với credentials mẫu.
   - Nếu đúng, lưu thông tin user vào Hive, cập nhật `isFirstLogin = false` trong settings box và chuyển sang `HomeScreen`.
   - Form đăng nhập tự động điền sẵn thông tin của phiên làm việc trước nhờ đọc dữ liệu trực tiếp trong `initState`.

3. **Đăng xuất (`HomeScreen.dart`):**
   - Đánh dấu trạng thái `isLoginned = false` trên Model, lưu lại vào DB.
   - Cập nhật `isFirstLogin = true` trong settings box và điều hướng trở lại `LoginScreen`.

---

## 2. Singleton & Factory trong `UserRepo`

Để tối ưu hóa hiệu năng và tránh lãng phí tài nguyên bộ nhớ, `UserRepo` được thiết kế dưới dạng **Singleton**:

```dart
class UserRepo {
  // 1. Khai báo instance static duy nhất trong bộ nhớ
  static final UserRepo _instance = UserRepo._internal();
  
  // 2. Factory constructor trả về instance static đó mỗi khi gọi UserRepo()
  factory UserRepo() => _instance;
  
  // 3. Constructor private ngăn tạo instance mới từ bên ngoài
  UserRepo._internal();
  
  // ...
}
```

### Tại sao lại tối ưu?
- **Singleton Pattern:** Đảm bảo toàn bộ ứng dụng chỉ sử dụng duy nhất **một** instance của `UserRepo` để tương tác với cơ sở dữ liệu, tránh việc khởi tạo nhiều đối tượng Repository khác nhau làm tốn bộ nhớ RAM.
- **Factory Constructor:** Khi ta gọi `UserRepo()`, thay vì cấp phát vùng nhớ cho một đối tượng mới (như constructor thông thường), factory constructor sẽ trả về ngay đối tượng `_instance` đã được cache sẵn. Điều này giúp code gọn gàng (vẫn gọi `UserRepo()` bình thường) nhưng bên dưới hoàn toàn tối ưu.
