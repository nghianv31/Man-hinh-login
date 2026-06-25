# 📘 Cẩm nang Kiến trúc & Best Practices (Flutter + GetX)

Tài liệu này tổng hợp lại những kiến thức và nguyên tắc quan trọng mà chúng ta đã cùng nhau đúc kết trong quá trình refactor tính năng Đăng nhập & Khóa tài khoản. Việc áp dụng những kiến thức này giúp source code trở nên **sạch (clean)**, **dễ bảo trì (maintainable)**, và **chống chịu lỗi (robust)** tốt hơn.

---

## 1. Tách biệt trách nhiệm (Separation of Concerns)

Một trong những quy tắc cốt lõi của lập trình là không nên trộn lẫn Logic nghiệp vụ (Business Logic) và Logic giao diện (UI Logic).

*   **❌ Sai lầm (Xây UI trong Controller):** Khởi tạo các Widget phức tạp như `Obx`, `Column`, `Text` trực tiếp bên trong `GetxController`. Điều này khiến Controller bị phình to, phụ thuộc trực tiếp vào framework giao diện (`flutter/material.dart`), phá vỡ kiến trúc MVVM/Clean Architecture.
*   **✅ Giải pháp:** 
    *   Tách phần giao diện đó ra thành một Widget riêng (ví dụ: `LockDialogWidget` nằm ở thư mục `views`).
    *   Controller chỉ đóng vai trò chứa State (`RxInt`, `RxBool`) và ra lệnh hiển thị (`Get.dialog()`) bằng cách truyền Widget đó vào.

---

## 2. Vòng đời Widget & Lỗi `visitChildElements()`

Khi sử dụng GetX (hoặc các State Management khác), việc gọi Dialog, Snackbar hay BottomSheet sai thời điểm sẽ gây lỗi gián đoạn.

*   **Vấn đề:** Lỗi `FlutterError (visitChildElements() called during build)` xảy ra khi cố gắng gọi `Get.dialog()` trong hàm `onInit()` của Controller. Lý do là lúc này Flutter **đang trong quá trình vẽ (build)** Widget Tree, chưa hoàn thiện khung hình đầu tiên.
*   **✅ Giải pháp (Sử dụng `onReady`):** Chuyển các lệnh gọi hiển thị UI (Dialog/Snackbar) sang hàm `onReady()`. Hàm này được GetX đảm bảo sẽ chỉ chạy **sau khi frame giao diện đầu tiên đã render xong**.

---

## 3. Kiến trúc luồng xác thực (Authentication Flow)

Logic kiểm tra đăng nhập không nên nằm ở Controller. Controller chỉ là "người chuyển phát", nhận dữ liệu từ UI, gọi Repo, và trả kết quả về UI. `AuthRepo` mới là "trái tim" của logic này.

*   **Tách biệt các bước kiểm tra (Step-by-step validation):**
    Thay vì gộp việc tìm User và check Mật khẩu vào một lệnh duy nhất (khiến ta không biết do tài khoản không tồn tại hay do sai mật khẩu), ta chia ra:
    1.  **Tìm User** (bằng `taxCode` và `account`).
    2.  **Kiểm tra trạng thái khóa** (Check `lockUntil`).
    3.  **Kiểm tra Mật khẩu** (Check Hash).
*   **Lợi ích:** Xác định được chính xác lý do lỗi để xử lý (chỉ đếm số lần sai khi người dùng thực sự nhập sai mật khẩu, không đếm khi họ nhập sai mã số thuế). Lấy được `userId` từ Bước 1 để thực hiện các thao tác với Database.

---

## 4. Xử lý ngoại lệ với Enum và Custom Exception

Dùng `String` (đặc biệt là chuỗi hiển thị UI) để ném lỗi (`throw`) và kiểm tra logic (`catch`) là một **Bad Practice**.

*   **❌ Tại sao sai:** Chuỗi `String` rất giòn (brittle). Nếu một ngày bạn muốn đổi chữ "Tài khoản bị khóa" thành "Vui lòng thử lại sau", toàn bộ logic kiểm tra `if (e == "Tài khoản bị khóa")` sẽ bị gãy.
*   **✅ Giải pháp (Custom Exception):** 
    Tạo ra một class `AuthException` kết hợp với `Enum`:
    ```dart
    enum AuthErrorType { accountNotExist, wrongPassword, locked, serverError }
    class AuthException implements Exception { ... }
    ```
    *   **Tầng Repo:** Chỉ `throw AuthException(AuthErrorType.locked)`. Repo không quan tâm đến UI sẽ hiển thị chữ gì.
    *   **Tầng Controller:** `catch (AuthException e)` và dùng khối `switch-case` ánh xạ (map) cái `enum` đó ra chuỗi văn bản của UI (`AppStrings.dart`) tương ứng. 

---

## 5. Chiến lược đồng bộ Remote & Local Fallback

Khi thực hiện việc khóa tài khoản (lưu `lockUntil` lên Firebase), bạn phải lường trước tình huống người dùng bị mất kết nối mạng.

*   **Local Fallback (Ưu tiên thiết bị):** Dù mạng có thế nào, hãy lưu trạng thái khóa vào Local (`SettingBox`) ngay lập tức để ứng dụng tự động chặn người dùng cố tình spam nút Đăng nhập.
*   **Fire-and-forget (Bắn và Quên):** Cuộc gọi API lên Firebase nên được bọc trong `try-catch`. Nếu rớt mạng (ném vào `catch`), ta ghi log ra console nhưng **không** để lỗi đó làm gián đoạn việc khóa trên điện thoại (throw exception "LOCKED"). Mặc dù Remote chưa cập nhật, nhưng máy khách (client) đã bị phong tỏa an toàn.
