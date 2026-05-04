-- ==========================================================
-- SETUP SCHEMA CHO VCB DIGIBANK - FRAUD DETECTION LAB
-- ==========================================================

-- 1. Bảng thông tin người dùng
CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100),
    customer_segment VARCHAR(20), -- VIP, Normal, Student
    daily_limit DECIMAL(15, 2) DEFAULT 50000000
);

INSERT INTO users (user_id, full_name, customer_segment, daily_limit) VALUES
('U001', 'Nguyen Van Khang', 'VIP', 200000000),
('U002', 'Le Thi Chi', 'Student', 5000000),
('U003', 'Tran Minh Tam', 'Normal', 50000000);

-- 2. Bảng Danh mục vị trí ATM
CREATE TABLE atm_locations (
    atm_id VARCHAR(10) PRIMARY KEY,
    address TEXT,
    city VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(10, 8)
);

INSERT INTO atm_locations (atm_id, address, city, is_active) VALUES
('ATM_HN_01', '198 Tran Quang Khai', 'Ha Noi', TRUE),
('ATM_HCM_01', 'VCB Tower, Dist 1', 'Ho Chi Minh', TRUE),
('ATM_DN_01', 'Nguyen Van Linh St', 'Da Nang', FALSE); -- ATM đang bảo trì cho Edge Case

-- 3. Bảng thiết bị người dùng (Đã từng đăng nhập thành công)
CREATE TABLE user_devices (
    device_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(20) REFERENCES users(user_id),
    device_name VARCHAR(100),
    last_used TIMESTAMP
);

INSERT INTO user_devices (device_id, user_id, device_name) VALUES
('DEVICE_TRUSTED_0', 'U003', 'iPhone 15 Pro Max'),
('DEVICE_TRUSTED_1', 'U001', 'Macbook Pro M3'),
('DEVICE_TRUSTED_2', 'U002', 'Samsung Galaxy S24');

-- 4. Bảng danh sách đen IP (Từ phòng an ninh mạng)
CREATE TABLE blacklist_ips (
    ip_address VARCHAR(20) PRIMARY KEY,
    reason TEXT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO blacklist_ips (ip_address, reason) VALUES
('45.12.33.1', 'Nghi van tan cong tu choi dich vu (DDoS)'),
('103.22.11.5', 'IP thuoc mang botnet da xac nhan');

-- 5. Bảng Giao dịch (Dữ liệu thô từ hệ thống Core)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id VARCHAR(20) REFERENCES users(user_id),
    atm_id VARCHAR(10) REFERENCES atm_locations(atm_id),
    amount DECIMAL(15, 2),
    transaction_time TIMESTAMP,
    device_id VARCHAR(50),
    ip_address VARCHAR(20),
    status VARCHAR(20) -- SUCCESS, FAILED, PENDING
);