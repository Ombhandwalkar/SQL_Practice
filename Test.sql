USE omi;

drop table if exists  student_tests;
create table student_tests
(
	test_id		int,
	marks		int
);
insert into student_tests values(100, 55);
insert into student_tests values(101, 55);
insert into student_tests values(102, 60);
insert into student_tests values(103, 58);
insert into student_tests values(104, 40);
insert into student_tests values(105, 50);

select * from student_tests;

--- Solution
SELECT x.test_id, x.marks FROM(
	SELECT *,LAG(marks,1,marks) OVER(ORDER BY test_id) AS lag_marks FROM student_tests)X
WHERE x.marks > x.lag_marks
    

