--registrasi-- FIN
CREATE PROCEDURE Registrasi @inputemail nvarchar(100), @inputpass nvarchar(100), @Pos nvarchar(100), @name nvarchar(100), @id nvarchar(20), @status nvarchar(100)
AS
IF EXISTS(SELECT Email FROM Pass p WHERE Email=@inputemail)
BEGIN
	PRINT'Email already exists'
END
ELSE
BEGIN
	INSERT INTO Pass (Email, Pass)
	VALUES (@inputemail, @inputpass)
	IF(@Pos LIKE'User')
		INSERT INTO Users (Users_email, Users_name, Users_status, Users_ID)
		VALUES (@inputemail, @name, @status, @id)
	IF(@Pos LIKE'Expert')
		INSERT INTO Experts (Experts_email, Experts_name, Experts_role, Experts_ID)
		VALUES (@inputemail, @name, @status, @id)
END

EXEC Registrasi @inputemail ='dread0@gmail.com' , @inputpass = '1222', @Pos='User', @name='Alex Jones', @id='U001', @status='SMA'
EXEC Registrasi @inputemail ='dread1@gmail.com' , @inputpass = '1222', @Pos='User', @name='Jean Paul', @id='U002', @status='SMA'
EXEC Registrasi @inputemail ='dread2@gmail.com' , @inputpass = '1222', @Pos='User', @name='X', @id='U003', @status='SMA'
EXEC Registrasi @inputemail ='dread3@gmail.com' , @inputpass = '1222', @Pos='User', @name='Ashley', @id='U004', @status='SMA'
EXEC Registrasi @inputemail ='dread4@gmail.com' , @inputpass = '1222', @Pos='User', @name='Margaret', @id='U005', @status='SMA'
EXEC Registrasi @inputemail ='dread5@gmail.com' , @inputpass = '1222', @Pos='User', @name='Jack Holmes', @id='U006', @status='SMA'

EXEC Registrasi @inputemail ='Helbertian@gmail.com' , @inputpass = 'rtyuio', @Pos='Expert', @name='Helbert Gregorian', @id='E001', @status='S.Kom'
EXEC Registrasi @inputemail ='Helber@gmail.com' , @inputpass = 'JDJYT', @Pos='Expert', @name='Gregori', @id='E002', @status='S.Kom'
EXEC Registrasi @inputemail ='Henry12@gmail.com' , @inputpass = 'yuiop', @Pos='Expert', @name='Henry', @id='E003', @status='S.Kom'
EXEC Registrasi @inputemail ='JonAle@gmail.com' , @inputpass = 'goggle', @Pos='Expert', @name='Jonathan Ale', @id='E004', @status='S.Kom'
DROP PROC Registrasi


--login-- FIN
CREATE PROCEDURE Log_in @inputemail nvarchar(100), @inputpass nvarchar(100)
AS
IF EXISTS(SELECT Users_email, Pass FROM Users u, Pass p WHERE u.Users_email=p.Email AND @inputemail=u.Users_email AND @inputpass=p.Pass)
BEGIN	
	SELECT * FROM Users
	WHERE(Users_email=@inputemail)
END
IF EXISTS(SELECT Experts_email, Pass FROM Experts e, Pass p WHERE e.Experts_email=p.Email AND @inputemail=e.Experts_email AND @inputpass=p.Pass)
BEGIN	
	SELECT * FROM Experts 
	WHERE(Experts_email=@inputemail)
END
ELSE 
BEGIN
	PRINT'Email or Password is wrong'
END
	

EXEC Log_in @inputemail ='dread@gmail.com' , @inputpass = '1234'
EXEC Log_in @inputemail ='dread0@gmail.com' , @inputpass = '1222'
EXEC Log_in @inputemail ='Helbertian@gmail.com' , @inputpass = 'rtyuio'
DROP PROC Log_in

--delete user dan expt Acc-- FIN
CREATE PROCEDURE delete_akun @email nvarchar(100)
AS
IF NOT EXISTS(SELECT Email From Pass p WHERE p.Email=@email)
BEGIN	
	PRINT'Email doesnt exist or wrong input'
END
IF EXISTS(SELECT Users_ID FROM Users WHERE @email=Users.Users_email)
BEGIN	
	DELETE u
	FROM Users u
	WHERE(u.Users_email=@email)
	DELETE p
	FROM Pass p
	WHERE(p.Email=@email)
END
IF EXISTS(SELECT Experts_ID FROM Experts WHERE @email=Experts.Experts_email)
BEGIN	
	UPDATE Classroom_content
	SET Classroom_content.Experts_ID=''
	FROM Experts e
	WHERE(Classroom_content.Experts_ID=e.Experts_ID AND Experts_email=@email)

	UPDATE course_assigned
	SET course_assigned.Experts_ID=''
	FROM Experts e
	WHERE(course_assigned.Experts_ID=e.Experts_ID AND Experts_email=@email)

	DELETE e
	FROM Experts e
	WHERE(e.Experts_email=@email)

	DELETE p
	FROM Pass p
	WHERE(p.Email=@email)
END

EXEC delete_akun @email='dread0@gmail.com'
EXEC delete_akun @email='Helber@gmail.com'
DROP PROC delete_akun


--update data akun-- FIN
CREATE PROCEDURE update_akun @address nvarchar(50), @dob nvarchar(10), @curr_id nvarchar(10), @name nvarchar(50), @status nvarchar(30)
AS
IF EXISTS(SELECT Users_ID FROM Users WHERE @curr_id=Users_ID)
BEGIN	
	UPDATE Users
	SET Users_address=@address, Users_dob=@dob, Users_name=@name, Users_status=@status
	WHERE(Users_ID=@curr_id)
END
IF EXISTS(SELECT Experts_ID FROM Experts WHERE @curr_id=Experts_ID)
BEGIN
	UPDATE Experts
	SET Experts_address=@address, Experts_dob=@dob, Experts_name=@name, Experts_role=@status
	WHERE(Experts_ID=@curr_id)
END

EXEC update_akun @curr_id='U001',@address='Test data',@dob='12-12-2002',@name='Alex Johanes',@status='bachelor'
EXEC update_akun @curr_id='E001',@address='Test data',@dob='10-6-1990',@name='Helbert Gregorian',@status='S.Kom'

DROP PROC update_akun




--VIEWABLE AS ACC-- FIN
CREATE PROCEDURE View_content @curr_id nvarchar(10), @course_Id nvarchar(10), @class_id nvarchar(10)
AS
IF EXISTS(SELECT Users_ID FROM Users WHERE @curr_id=Users_ID)
BEGIN
	SELECT * FROM Users u WHERE(u.Users_ID=@curr_id)

	SELECT cc.Users_ID,u.Users_name
	FROM Users u,Classroom_content cc,Classroom c
	WHERE(u.Users_ID=cc.Users_ID AND cc.Course_ID=c.Course_ID AND c.Course_ID=@course_Id AND c.Class_ID=@class_id
		AND EXISTS(SELECT cc.Users_ID FROM Classroom_content cc WHERE(@curr_id=cc.Users_ID AND cc.Course_ID=@course_Id)))

	SELECT c.Class_ID,c.Class_name,c.Class_link,c.Course_ID,co.Course_name,Course_type,cc.Experts_ID,e.Experts_name,e.Experts_role 
	FROM Classroom c, Classroom_content cc, Experts e,Course co
	WHERE(cc.Course_ID=c.Course_ID AND c.Course_ID=@course_Id AND cc.Users_ID=@curr_id 
		AND cc.Experts_ID=e.Experts_ID AND c.Class_ID=@class_id AND c.Course_ID=co.Course_ID)
END
IF EXISTS(SELECT Experts_ID FROM Experts WHERE(@curr_id=Experts_ID))
BEGIN
	SELECT * FROM Experts e WHERE(e.Experts_ID=@curr_id)
	SELECT Users_name,cc.Users_ID FROM Users u, Classroom c,Classroom_content cc 
	WHERE(u.Users_ID=cc.Users_ID AND cc.Experts_ID=@curr_id AND cc.Course_ID=c.Course_ID AND c.Course_ID=@course_Id AND c.Class_ID=@class_id)

	SELECT c.Class_ID,c.Class_name,c.Class_link,c.Course_ID,co.Course_name,Course_type,e.Experts_ID,e.Experts_name,e.Experts_role 
	FROM Classroom c, Experts e,Course co, Classroom_content cc
	WHERE(cc.Experts_ID=e.Experts_ID AND cc.Course_ID=c.Course_ID AND c.Course_ID=@course_Id AND co.Course_ID=c.Course_ID
		AND c.Class_ID=@class_id)
	GROUP BY Class_ID,Class_name,Class_link,c.Course_ID,Course_name,Course_type,e.Experts_ID,Experts_name,Experts_role
END


EXEC View_content @curr_id='E001',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='E001',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='E002',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='E003',@course_Id='C003', @class_id='12348'
EXEC View_content @curr_id='E004',@course_Id='C004', @class_id='12345'

EXEC View_content @curr_id='U001',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U001',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U001',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U001',@course_Id='C003', @class_id='12348'

EXEC View_content @curr_id='U002',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U002',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U002',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U002',@course_Id='C003', @class_id='12348'

EXEC View_content @curr_id='U003',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U003',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U003',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U003',@course_Id='C003', @class_id='12348'

EXEC View_content @curr_id='U004',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U004',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U004',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U004',@course_Id='C003', @class_id='12348'

EXEC View_content @curr_id='U005',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U005',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U005',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U005',@course_Id='C003', @class_id='12348'

EXEC View_content @curr_id='U006',@course_Id='C001', @class_id='12345'
EXEC View_content @curr_id='U006',@course_Id='C002', @class_id='12346'
EXEC View_content @curr_id='U006',@course_Id='C001', @class_id='12347'
EXEC View_content @curr_id='U006',@course_Id='C003', @class_id='12348'
DROP PROC View_content


--ADD COURSE-- FIN
CREATE PROCEDURE add_course @add_id nvarchar(10), @add_name nvarchar(100), @add_type nvarchar(50) 
AS
INSERT INTO Course (Course_ID,Course_name,Course_type)
VALUES (@add_id,@add_name,@add_type)

EXEC add_course @add_id='C001',@add_name='Database',@add_type='LEC'
EXEC add_course @add_id='C002',@add_name='Database',@add_type='LAB'
EXEC add_course @add_id='C003',@add_name='Computer',@add_type='LEC'
DROP PROC add_course


--EDIT COURSE-- FIN
CREATE PROCEDURE edit_course @target_id nvarchar(10), @new_name nvarchar(100), @new_type nvarchar(50)
AS
UPDATE Course
SET Course_name=@new_name, Course_type=@new_type
WHERE(Course_ID=@target_id)

EXEC edit_course @target_id='C001', @new_name='DATABASE', @new_type='LAB'
DROP PROC edit_course


--DELETE COURSE-- FIN
CREATE PROCEDURE delete_course @id nvarchar(10)
AS
DELETE Course
WHERE(Course_ID=@id)

EXEC delete_course @id='C001'
EXEC delete_course @id='C002'
EXEC delete_course @id='C003'


DROP PROC delete_course


--CREATE CLASSROOM-- FIN
CREATE PROCEDURE create_class @class_id nvarchar(10), @name nvarchar(100), @link nvarchar(100), @course_id nvarchar(10)
AS
IF EXISTS(SELECT Class_ID FROM Classroom WHERE(Class_ID=@class_id))
BEGIN
	PRINT'Class already exists'
END
ELSE
BEGIN
	INSERT INTO Classroom(Class_ID,Class_link,Class_name,Course_ID)
	VALUES(@class_id,@link,@name,@course_id)
END

EXEC create_class @class_id='12345',@name='DA20',@link='LONGGGG',@course_id='C001'
EXEC create_class @class_id='12346',@name='DL20',@link='LONGGGG',@course_id='C002'
EXEC create_class @class_id='12347',@name='DB20',@link='LONGGGG',@course_id='C001'
EXEC create_class @class_id='12348',@name='CC20',@link='LONGGGG',@course_id='C003'

DROP PROC create_class


--DELETE CLASSROOM-- FIN
CREATE PROCEDURE del_class @class_id nvarchar(10)
AS
DELETE Classroom_content
FROM Classroom
WHERE(Classroom_content.Course_ID=Classroom.Course_ID AND Classroom.Class_ID=@class_id)
DELETE Classroom
WHERE (Classroom.Class_ID=@class_id)

EXEC del_class @class_id='12347'
DROP PROC del_class


--UPDATE CLASS--FIN
CREATE PROCEDURE up_class @class_id nvarchar(10), @name nvarchar(100), @link nvarchar(100)
AS
UPDATE Classroom
SET Class_link=@link, Class_name=@name
WHERE (Classroom.Class_ID=@class_id)

EXEC up_class @class_id='12346', @name='class 1', @link='google.com'
DROP PROC up_class


--add topic--FIN
CREATE PROCEDURE add_topic @topic_id nvarchar(10), @title nvarchar(100), @session nvarchar(50), @course_id nvarchar(10)
AS
IF EXISTS(SELECT Topic_ID FROM topics WHERE Topic_ID=@topic_id)
BEGIN
	PRINT'Topic Already Exists'
END
ELSE
BEGIN
	INSERT INTO topics(Topic_ID, Title, SessionNumber, Course_ID)
	VALUES(@topic_id,@title,@session,@course_id)
END

EXEC add_topic @topic_id='T001', @title='how to....', @session='12', @course_id='C001'
EXEC add_topic @topic_id='T002', @title='how to....', @session='10', @course_id='C001'
EXEC add_topic @topic_id='T003', @title='how to....', @session='11', @course_id='C002'
EXEC add_topic @topic_id='T004', @title='how to....', @session='9', @course_id='C001'
EXEC add_topic @topic_id='T045', @title='how to....', @session='8', @course_id='C002'
DROP PROC add_topic

--UPDATE TOPIC--FIN
CREATE PROCEDURE up_topic @id nvarchar (10), @name nvarchar(100), @session nvarchar(100), @course_id nvarchar (10)
AS
UPDATE topics
SET Title=@name, SessionNumber=@session, Course_ID=@course_id
WHERE (Topic_ID=@id)

EXEC up_topic @id='T001', @name='when to...', @session='2', @course_id='C003'

--DELETE TOPIC--FIN
CREATE PROCEDURE del_topic @id nvarchar(10)
AS
DELETE topics
WHERE(topics.Topic_ID=@id)

EXEC del_topic @id='T045'
DROP PROC del_topic

--view topic--FIN
CREATE PROCEDURE view_topic @curr_id nvarchar(10), @course_id nvarchar(10)
AS
IF EXISTS(SELECT Users_ID FROM Users WHERE Users_ID=@curr_id)
BEGIN
	SELECT Topic_ID,Title,SessionNumber FROM topics t, Classroom_content cc
	WHERE (t.Course_ID=cc.Course_ID AND cc.Users_ID=@curr_id AND t.Course_ID=@course_id)
END

IF EXISTS(SELECT Experts_ID FROM Experts WHERE Experts_ID=@curr_id)
BEGIN
	SELECT Topic_ID,Title,SessionNumber FROM topics t, Classroom_content cc
	WHERE (t.Course_ID=cc.Course_ID AND cc.Experts_ID=@curr_id AND t.Course_ID=@course_id)
	GROUP BY Topic_ID,Title,SessionNumber
END

EXEC view_topic @curr_id='E001', @course_id='C002'
EXEC view_topic @curr_id='U001', @course_id='C002'
DROP PROC view_topic

--CREATE QUIZ--
CREATE PROCEDURE add_quiz @id nvarchar(10), @question nvarchar(500), @topic_id nvarchar(10)
AS
IF EXISTS(SELECT Question_ID FROM quiz WHERE(Question_ID=@id))
BEGIN
	PRINT' A question already exists'
END
ELSE
BEGIN
	INSERT INTO quiz(Question_ID, Question, Topic_ID)
	VALUES (@id,@question,@topic_id)
END

EXEC add_quiz @id='Q001', @question='How to code good?', @topic_id='T045'
EXEC add_quiz @id='Q002', @question='Can you code good?', @topic_id='T045'
EXEC add_quiz @id='Q003', @question='What is Computer network?', @topic_id='T001'
EXEC add_quiz @id='Q004', @question='What is programming?', @topic_id='T002'
EXEC add_quiz @id='Q005', @question='What software to use?', @topic_id='T003'
EXEC add_quiz @id='Q006', @question='What is Database?', @topic_id='T004'

DROP PROC add_quiz

--EDIT QUIZ

CREATE PROCEDURE edit_quiz @id nvarchar(10), @question nvarchar(500), @topic_id nvarchar(10)
AS
UPDATE quiz
SET Question_ID=@id, Question=@question, Topic_ID=@topic_id
WHERE(Question_ID=@id)

EXEC edit_quiz @id='Q001', @question='What code language is the best?', @topic_id='T045'
DROP PROC edit_quiz

--DELETE A QUIZ--
CREATE PROCEDURE del_quiz @id nvarchar(10)
AS
DELETE quiz
WHERE(Question_ID=@id)

EXEC del_quiz @id='Q003'
DROP PROC edit_quiz

--VIEW QUIZ--
CREATE PROCEDURE see_quiz @curr_id nvarchar(10), @topic_id nvarchar(10)
AS
IF EXISTS(SELECT Experts_ID FROM Experts WHERE Experts_ID=@curr_id)
BEGIN
	SELECT Question_ID,Question 
	FROM quiz q, topics t, course_assigned ca
	WHERE(q.Topic_ID=t.Topic_ID AND t.Course_ID=ca.Course_ID 
		AND t.Topic_ID=@topic_id AND ca.Experts_ID=@curr_id)
		GROUP BY Question,Question_ID
END
IF EXISTS(SELECT Users_ID FROM Users WHERE Users_ID=@curr_id)
BEGIN
	SELECT Question_ID,Question
	FROM quiz q, topics t, Classroom_content cc
	WHERE(q.Topic_ID=t.Topic_ID AND t.Course_ID=cc.Course_ID 
		AND cc.Users_ID=@curr_id AND q.Topic_ID=@topic_id)
END

EXEC see_quiz @curr_id='U001', @topic_id='T045'
EXEC see_quiz @curr_id='U002', @topic_id='T045'
EXEC see_quiz @curr_id='U006', @topic_id='T001'

EXEC see_quiz @curr_id='E001', @topic_id='T045'
EXEC see_quiz @curr_id='E002', @topic_id='T045'
EXEC see_quiz @curr_id='E002', @topic_id='T004'
EXEC see_quiz @curr_id='E001', @topic_id='T004'

DROP PROC see_quiz

--ADD ANSWER--
CREATE PROCEDURE answer @id nvarchar(10), @ans nvarchar(500), @quest_id nvarchar(10), @curr_id nvarchar(10)
AS
IF EXISTS(SELECT Answers_ID FROM answers WHERE Answers_ID=@ans)
BEGIN
	PRINT'Can only edit, not add more...'
END
ELSE
	INSERT INTO answers(Answers_ID,Answer, Question_ID, Users_ID)
	VALUES(@id, @ans, @quest_id, @curr_id)


EXEC answer @id='A001', @ans='Yes if you work hard enough', @quest_id='Q002', @curr_id='U001'
DROP PROC answer

--EDIT ANS--

CREATE PROCEDURE edit_ans @curr_id nvarchar(10), @ans nvarchar(500), @ans_id nvarchar(10), @quest_id nvarchar(10)
AS
IF EXISTS(SELECT * FROM answers WHERE(Answers_ID=@ans_id AND Users_ID=@curr_id))
BEGIN
	UPDATE answers
	SET Answer=@ans
	WHERE(Answers_ID=@ans_id AND Users_ID=@curr_id AND Question_ID=@quest_id)
END

EXEC edit_ans @curr_id='U001', @ans_id='A001', @ans='yes if you are not lazy', @quest_id='Q002'
DROP PROC edit_ans


--VIEW ANS--

CREATE PROCEDURE view_ans @curr_id nvarchar(10), @quest_id nvarchar(10)
AS
IF EXISTS(SELECT Experts_ID FROM Experts WHERE Experts_ID=@curr_id)
BEGIN
	SELECT Answer, Answers_ID, a.Question_ID,a.Users_ID FROM answers a, quiz q, topics t, Classroom_content cc
	WHERE(a.Question_ID=q.Question_ID AND q.Topic_ID=t.Topic_ID
		AND t.Course_ID=cc.Course_ID AND cc.Experts_ID=@curr_id)
		GROUP BY  a.Users_ID,a.Question_ID,Answers_ID,Answer
END
IF EXISTS(SELECT Users_ID FROM Users WHERE Users_ID=@curr_id)
BEGIN
	SELECT Users_ID, Question_ID, Answers_ID, Answer FROM answers a
	WHERE(a.Question_ID=@quest_id AND a.Users_ID=@curr_id)
END

EXEC view_ans @curr_id='U001', @quest_id='Q002'
EXEC view_ans @curr_id='E001', @quest_id='Q002'
DROP PROC view_ans

--assigning expert to course-- FIN

CREATE PROCEDURE exp_assign @id nvarchar(10),@course_id nvarchar(10)
AS
IF EXISTS(SELECT Course_ID FROM course_assigned WHERE(Course_ID=@course_id))
BEGIN
	PRINT'Course has been assigned'
END
ELSE
BEGIN
	INSERT INTO course_assigned (Experts_ID,Course_ID)
	VALUES(@id,@course_id)
END

EXEC exp_assign @id='E001', @course_id='C001'
EXEC exp_assign @id='E002', @course_id='C002'
EXEC exp_assign @id='E003', @course_id='C003'

DROP PROC exp_assign


--UPDATE EXPERT-- FIN

CREATE PROCEDURE update_exp @curr_exp nvarchar(10), @new_exp nvarchar(10), @COURSE_ID nvarchar(10)
AS
IF NOT EXISTS(SELECT Experts_ID FROM Experts WHERE Experts_ID=@new_exp)
BEGIN
	PRINT'EXPERT NOT EXISTS'
END
ELSE
BEGIN
UPDATE course_assigned
SET Experts_ID=@new_exp
WHERE(Experts_ID=@curr_exp AND Course_ID=@COURSE_ID)

UPDATE Classroom_content
SET Experts_ID=@new_exp
FROM Classroom
WHERE(Experts_ID=@curr_exp AND Classroom_content.Course_ID=Classroom.Course_ID AND Classroom.Course_ID=@COURSE_ID)
END

EXEC update_exp @curr_exp='',@new_exp='E001',@COURSE_ID='C002'
EXEC update_exp @curr_exp='E002',@new_exp='E001',@COURSE_ID='C001'
EXEC update_exp @curr_exp='E001',@new_exp='E002',@COURSE_ID='C001'
DROP PROC update_exp



--choosing for user-- FIN

CREATE PROCEDURE user_choose @curr_id nvarchar(10), @choose_course_id nvarchar(10)
AS
IF EXISTS(SELECT Users_ID FROM Classroom_content,Classroom 
WHERE(Users_ID=@curr_id AND Classroom_content.Course_ID=Classroom.Course_ID AND Classroom.Course_ID=@choose_course_id))
BEGIN
	PRINT'Data already exists'
END
IF NOT EXISTS(SELECT Users_ID FROM Classroom_content,Classroom 
WHERE(Users_ID=@curr_id AND Classroom_content.Course_ID=Classroom.Course_ID AND Classroom.Course_ID=@choose_course_id))
BEGIN
	INSERT INTO Classroom_content (Users_ID,Experts_ID,Course_ID)
	VALUES(@curr_id,(SELECT ca.Experts_ID FROM course_assigned ca WHERE(@choose_course_id=ca.Course_ID)),
	@choose_course_id)
END
ELSE
BEGIN
	PRINT'ERROR'
END

EXEC user_choose @curr_id='U001', @choose_course_id='C001'
EXEC user_choose @curr_id='U002', @choose_course_id='C001'
EXEC user_choose @curr_id='U003', @choose_course_id='C001'
EXEC user_choose @curr_id='U004', @choose_course_id='C001'
EXEC user_choose @curr_id='U005', @choose_course_id='C001'
EXEC user_choose @curr_id='U001', @choose_course_id='C002'
EXEC user_choose @curr_id='U002', @choose_course_id='C002'
EXEC user_choose @curr_id='U003', @choose_course_id='C002'
EXEC user_choose @curr_id='U006', @choose_course_id='C002'
EXEC user_choose @curr_id='U003', @choose_course_id='C003'
EXEC user_choose @curr_id='U004', @choose_course_id='C003'
EXEC user_choose @curr_id='U005', @choose_course_id='C003'
EXEC user_choose @curr_id='U006', @choose_course_id='C003'

DROP PROC user_choose
