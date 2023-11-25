-- Masterlist of University Stakeholders
SELECT 'student' AS stakeholder, s.student_id as "ID", s.first_name, s.last_name, s.middle_initial, s.permanent_address, s.current_address, s.contact_number, s.contact_email, s.birthdate, s.program, s.enrollment_year AS "Year"
FROM student s
UNION 
SELECT 'instructor' AS stakeholder, i.instructor_id as "ID", i.first_name, i.last_name, i.middle_initial, i.permanent_address, i.current_address, i.contact_number, i.contact_email, i.birthdate, i.department, i.service_commencement AS "Year"
FROM instructor i;

-- Masterlist of University Services
SELECT 'book' AS Service, bk.book_id as "ID", bk.book_title AS "Name", CONCAT(bk.Book_author_last_name, ', ', bk.Book_author_first_name) AS "Description"
FROM book bk
UNION
SELECT 'equipment' AS Service, e.equipment_id AS "ID", e.equipment_type AS "Name", e.total_quantity AS "Description"
FROM equipment e
UNION
SELECT 'room' AS Service, r.room_id AS "ID", r.room_type AS "Name", r.max_capacity AS "Description"
FROM room r;

-- Report of Borrowed Items (per month)
SELECT 
	MONTH,
    _id,
    AVG(amount) as Avg,
    NAME
    FROM
    (SELECT 
			MONTH(br.start_date) AS MONTH,
			YEAR (br.start_date) AS YEAR,
			br.item_id AS _id, 
			COUNT(br.item_id) AS amount, 
			CASE WHEN e.equipment_id IS NOT NULL then e.equipment_type
				WHEN bk.book_id IS NOT NULL then bk.book_title
				WHEN rm.room_id IS NOT NULL then rm.room_type
			END AS NAME
		FROM borrow br
		LEFT JOIN equipment e ON br.item_id = e.equipment_id
		LEFT JOIN book bk ON br.item_id = bk.book_id
		LEFT JOIN room rm ON br.item_id = rm.room_id
		GROUP BY MONTH, YEAR, br.item_id, NAME) AS SUBQ
	GROUP BY SUBQ.MONTH, SUBQ._id, SUBQ.NAME;
    
    
-- Report of Borrowed Items (per month and department)
    SELECT 
	MONTH,
    _id,
    department,
    AVG(amount) as Avg,
    SUBQ.NAME
    FROM
    (SELECT 
			MONTH(br.start_date) AS MONTH,
			YEAR (br.start_date) AS YEAR,
			br.item_id AS _id, 
            i.department AS department,
			COUNT(br.item_id) AS amount, 
			CASE WHEN e.equipment_id IS NOT NULL then e.equipment_type
				WHEN bk.book_id IS NOT NULL then bk.book_title
				WHEN rm.room_id IS NOT NULL then rm.room_type
			END AS NAME
		FROM borrow br
	    LEFT JOIN instructor i ON br.borrower_id = i.instructor_id
		LEFT JOIN equipment e ON br.item_id = e.equipment_id
		LEFT JOIN book bk ON br.item_id = bk.book_id
		LEFT JOIN room rm ON br.item_id = rm.room_id
        WHERE i.department IS NOT NULL
		GROUP BY MONTH, YEAR, br.item_id, NAME, department) AS SUBQ
	GROUP BY SUBQ.MONTH, SUBQ._id, SUBQ.NAME, SUBQ.department;
    
    