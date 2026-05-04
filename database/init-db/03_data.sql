-- Làm sạch bảng cũ trước khi chèn mới
TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;

-- A. CHÈN 80 DÒNG HAPPY CASES (Giao dịch bình thường)
-- Đặc điểm: Số tiền hợp lý, thiết bị quen thuộc, IP nội bộ, ATM hoạt động.
INSERT INTO transactions (user_id, atm_id, amount, transaction_time, device_id, ip_address, status)
SELECT 
    CASE WHEN (i % 3 = 0) THEN 'U001' WHEN (i % 3 = 1) THEN 'U002' ELSE 'U003' END,
    CASE WHEN (i % 2 = 0) THEN 'ATM_HN_01' ELSE 'ATM_HCM_01' END,
    (random() * 2000000 + 50000)::DECIMAL(15,2), -- Số tiền nhỏ (50k - 2tr)
    NOW() - (i || ' hours')::INTERVAL,
    'DEVICE_TRUSTED_' || (i % 3), -- Thiết bị lặp lại quen thuộc
    '172.16.10.' || i, -- Dải IP sạch
    'SUCCESS'
FROM generate_series(1, 80) s(i);

-- B. CHÈN 20 DÒNG EDGE CASES (Tình huống bất thường/Lỗi hệ thống/Gian lận)
-- 1. Các giao dịch từ IP nằm trong Blacklist (5 dòng)
INSERT INTO transactions (user_id, atm_id, amount, transaction_time, device_id, ip_address, status)
SELECT 'U001', 'ATM_HN_01', 1000000, NOW(), 'PHONE_MYS', '45.12.33.1', 'SUCCESS'
FROM generate_series(1, 5);

-- 2. Các giao dịch tại ATM đang bảo trì (5 dòng)
INSERT INTO transactions (user_id, atm_id, amount, transaction_time, device_id, ip_address, status)
SELECT 'U002', 'ATM_DN_01', 500000, NOW() - (i || ' minutes')::INTERVAL, 'DEVICE_02', '123.45.6.' || i, 'SUCCESS'
FROM generate_series(1, 5) AS s(i);

-- 3. Các giao dịch vượt hạn mức nhưng hệ thống vẫn cho qua (5 dòng)
INSERT INTO transactions (user_id, atm_id, amount, transaction_time, device_id, ip_address, status)
SELECT 'U003', 'ATM_HN_01', 15000000, NOW(), 'DEV_XYZ', '10.20.30.' || i, 'SUCCESS'
FROM generate_series(1, 5) AS s(i);

-- 4. Case "Tốc độ phi lý": Rút ở HN xong 10p sau rút ở HCM (5 dòng cho 2 users)
INSERT INTO transactions (user_id, atm_id, amount, transaction_time, device_id, ip_address, status) VALUES
('U001', 'ATM_HN_01', 1000000, '2024-05-01 14:00:00', 'IPHONE_15', '1.1.1.1', 'SUCCESS'),
('U001', 'ATM_HCM_01', 2000000, '2024-05-01 14:10:00', 'IPHONE_15', '1.1.1.2', 'SUCCESS'),
('U002', 'ATM_HN_01', 500000, '2024-05-01 15:00:00', 'SAM_S24', '2.2.2.1', 'SUCCESS'),
('U002', 'ATM_HCM_01', 500000, '2024-05-01 15:05:00', 'SAM_S24', '2.2.2.2', 'SUCCESS'),
('U001', 'ATM_HN_01', 3000000, '2024-05-01 16:00:00', 'IPHONE_15', '1.1.1.1', 'SUCCESS');