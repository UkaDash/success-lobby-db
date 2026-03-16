CREATE DATABASE IF NOT EXISTS success_lobby;
USE success_lobby;

-- =====================
-- 1. STUDENTS
-- =====================
CREATE TABLE IF NOT EXISTS students (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,   -- use school email
    password_hash VARCHAR(255) NOT NULL,
    profile_pic   VARCHAR(255),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================
-- 2. COURSES
-- =====================
CREATE TABLE IF NOT EXISTS courses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20)  NOT NULL UNIQUE,  -- e.g. "CS101"
    course_name VARCHAR(100) NOT NULL,          -- e.g. "Intro to Programming"
    department  VARCHAR(50)
);

-- =====================
-- 3. STUDENT ↔ COURSE ENROLLMENT
-- (A student can be in many courses, a course has many students)
-- =====================
CREATE TABLE IF NOT EXISTS student_courses (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id  INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(id)  ON DELETE CASCADE,
    UNIQUE (student_id, course_id)   -- prevent duplicate enrollments
);

-- =====================
-- 4. CAMPUS LOCATIONS
-- =====================
CREATE TABLE IF NOT EXISTS locations (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,   -- e.g. "Main Library - Floor 2"
    building      VARCHAR(100),
    description   VARCHAR(255)
);

-- =====================
-- 5. STUDY SESSIONS
-- "I am on campus RIGHT NOW and ready to study for this course"
-- =====================
CREATE TABLE IF NOT EXISTS study_sessions (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    course_id   INT NOT NULL,
    location_id INT NOT NULL,
    status      ENUM('active', 'matched', 'closed') DEFAULT 'active',
    note        VARCHAR(255),               -- optional message, e.g. "I have the textbook!"
    started_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at  TIMESTAMP,                  -- auto-close after a few hours
    FOREIGN KEY (student_id)  REFERENCES students(id)  ON DELETE CASCADE,
    FOREIGN KEY (course_id)   REFERENCES courses(id)   ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
);

-- =====================
-- 6. BUDDY REQUESTS
-- When Student A wants to study with Student B
-- =====================
CREATE TABLE IF NOT EXISTS buddy_requests (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    requester_id    INT NOT NULL,              -- student who sent the request
    receiver_id     INT NOT NULL,              -- student who received it
    session_id      INT NOT NULL,              -- which study session this is about
    status          ENUM('pending', 'accepted', 'declined') DEFAULT 'pending',
    requested_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at    TIMESTAMP,
    FOREIGN KEY (requester_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id)  REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id)   REFERENCES study_sessions(id) ON DELETE CASCADE
);