---You are given three tables: epc_students, epc_subjects, and epc_examinations. Your task is to count how many times each student has attended exams for each subject.

Return a result showing every student–subject combination, even if the student has never taken an exam for that subject.




--- SQL
select ss.student_id, ss.student_name,ss.subject_name, COALESCE(COUNT(e.subject_name),0)AS attended_exams
FROM (
  SELECT *
  FROM epc_students 
  CROSS JOIN epc_subjects
) ss 
LEFT JOIN epc_examinations e 
ON ss.student_id=e.student_id AND ss.subject_name=e.subject_name
GROUP BY ss.student_id, ss.student_name, ss.subject_name
ORDER BY ss.student_id, ss.subject_name 



--- Python

import pandas as pd
import numpy as np

def etl(epc_examinations, epc_students, epc_subjects):
    epc_students['key']=1
    epc_subjects['key']=1
    df= epc_students.merge(epc_subjects, on='key').drop(columns='key')
    df= df.merge(epc_examinations, how='left', on=['student_id','subject_name'], indicator=True)
    df['attended_exams']=(df['_merge']=='both').astype(int)
    return df.groupby(['student_id','student_name','subject_name'],as_index=False)['attended_exams'].sum().sort_values(by=['student_id','subject_name'])