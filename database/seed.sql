-- Find all students studying CS101 on campus right now
SELECT 
    s.full_name,
    l.name AS location,
    ss.note,
    ss.started_at
FROM study_sessions ss
JOIN students  s ON ss.student_id  = s.id
JOIN courses   c ON ss.course_id   = c.id
JOIN locations l ON ss.location_id = l.id
WHERE c.course_code = 'CS101'
  AND ss.status = 'active';

-- Find all courses a specific student is enrolled in
SELECT c.course_code, c.course_name
FROM student_courses sc
JOIN courses c ON sc.course_id = c.id
WHERE sc.student_id = 1;

-- Check incoming buddy requests for a student
SELECT 
    s.full_name AS from_student,
    c.course_code,
    br.status,
    br.requested_at
FROM buddy_requests br
JOIN students s ON br.requester_id = s.id
JOIN study_sessions ss ON br.session_id = ss.id
JOIN courses c ON ss.course_id = c.id
WHERE br.receiver_id = 2;
```

---

## 🗃️ Folder Structure for GitHub
```
success-lobby/
├── database/
│   ├── schema.sql          ← All table definitions
│   ├── seed.sql            ← Test data
│   └── migrations/         ← Future changes
├── src/
└── README.md
```

---

## 🔗 How the Tables Relate (Visual)
```
students ──┬── student_courses ── courses
           │
           ├── study_sessions ──── courses
           │         │ └────────── locations
           │         │
           └── buddy_requests ──── study_sessions