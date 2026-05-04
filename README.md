# Dự án: Nâng cấp luồng rút tiền qua mã QR - VCB

## 1. Tổng quan dự án
Tài liệu này mô tả yêu cầu nghiệp vụ cho việc cải tiến quy trình rút tiền bằng mã QR tại hệ thống ATM của VCB. Mục tiêu chính là tăng cường tính bảo mật thông qua việc tích hợp hệ thống AI Fraud Detection (Phát hiện gian lận) và eKYC FaceID trong quá trình giao dịch.

## 2. Phạm vi nghiệp vụ
Hệ thống cần xử lý các luồng logic sau khi khách hàng quét mã QR tại cây ATM:

*   **Kiểm tra vị trí (Location Check):** So sánh tọa độ GPS của thiết bị di động (App) và vị trí của cây ATM.
*   **Phân tích hành vi (Behavior Analysis):** Hệ thống AI đánh giá lịch sử chi tiêu gần đây để đưa ra điểm số rủi ro (Risk Score).
*   **Xác thực bổ sung (Step-up Authentication):** Áp dụng eKYC FaceID dựa trên mức độ rủi ro.
*   **Kiểm tra điều kiện rút tiền:** Đảm bảo các điều kiện về hạn mức giao dịch và số dư tiền mặt tại cây ATM.

## 3. Quy trình thực hiện (Rolling Style)
Dự án được triển khai theo phương pháp cuốn chiếu, yêu cầu BA hoàn thành từng phần tài liệu trước khi bước sang giai đoạn tiếp theo:

| Giai đoạn | Nhiệm vụ của BA | Trạng thái |
| :--- | :--- | :--- |
| **Giai đoạn 1** | Vẽ sơ đồ quy trình nghiệp vụ (BPMN) cho luồng rút tiền mới. | Đang chờ |
| **Giai đoạn 2** | Đặc tả User Stories và tiêu chí chấp nhận (Acceptance Criteria). | Đang chờ |
| **Giai đoạn 3** | Thiết kế Wireframe cho các màn hình thông báo rủi ro và eKYC trên App. | Đang chờ |
| **Giai đoạn 4** | Xác định các thông báo lỗi (Error Messages) và các trường hợp ngoại lệ. | Đang chờ |

## 4. Các kịch bản rủi ro (Risk Scoring Logic)
Dựa trên điểm số từ AI Fraud Detection, quy trình sẽ rẽ nhánh như sau:

1.  **Rủi ro Thấp:** Khách hàng được chuyển thẳng đến bước nhập số tiền.
2.  **Rủi ro Trung bình:** Yêu cầu thực hiện eKYC FaceID. AI Face Matcher sẽ so sánh ảnh selfie trực tiếp với ảnh gốc.
3.  **Rủi ro Cao / FaceID không khớp:** Hệ thống tự động khóa giao dịch và gửi thông báo đến bộ phận vận hành.

## 5. Hướng dẫn cho BA (Git Flow)
Để đảm bảo tính chuyên nghiệp trong việc quản lý tài liệu IT, ứng viên cần tuân thủ quy trình sau:
*   Mỗi giai đoạn làm việc trên một branch riêng biệt (Ví dụ: `feature/stage-1-bpmn`).
*   Tài liệu hoàn thiện phải được đẩy lên GitHub thông qua **Pull Request (PR)**.
*   Nội dung trong PR cần mô tả rõ những thay đổi hoặc bổ sung so với đề bài gốc.
