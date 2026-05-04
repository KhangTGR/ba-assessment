-- ==========================================================
-- TẠO CÁC VIEW ĐỂ CHI PHÂN TÍCH NHANH
-- ==========================================================

-- View 1: Tổng hợp các giao dịch từ thiết bị lạ (Chưa có trong user_devices)
CREATE VIEW view_untrusted_device_txns AS
SELECT t.*, u.full_name
FROM transactions t
JOIN users u ON t.user_id = u.user_id
LEFT JOIN user_devices ud ON t.device_id = ud.device_id AND t.user_id = ud.user_id
WHERE ud.device_id IS NULL;

-- View 2: Cảnh báo giao dịch từ IP nằm trong danh sách đen
CREATE VIEW view_blacklist_ip_alerts AS
SELECT t.*, b.reason
FROM transactions t
JOIN blacklist_ips b ON t.ip_address = b.ip_address;