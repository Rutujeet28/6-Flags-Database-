--Calculate the average duration of each ride on September 4, 2022. 
--This analysis is based on data from the "F23_S001_T3_Ride" and "F23_S001_T3_RideSchedule" tables,
--The result is presented as the average ride duration in minutes for each distinct ride.

SELECT
    F23_S001_T3_Ride.RideID,
    AVG(EXTRACT(MINUTE FROM (F23_S001_T3_RideSchedule.endtime - F23_S001_T3_RideSchedule.starttime))) AS AverageDurationInMinute
FROM
    F23_S001_T3_Ride
JOIN
    F23_S001_T3_RideSchedule ON F23_S001_T3_Ride.RideID = F23_S001_T3_RideSchedule.RideID
WHERE
    F23_S001_T3_Ride.DATEOFVISIT = TO_DATE('2022-09-04','YYYY-MM-DD')
GROUP BY
        F23_S001_T3_Ride.RideID;

--Display the ssn, zipcode and the age of all passengers whose age is greater than the average age

SELECT pr.ssn, 
       p.homezipcode,
       TRUNC(months_between(sysdate, pr.DOB) / 12) AS age
FROM F23_S001_T3_Passenger p
JOIN F23_S001_T3_Person pr ON p.ssn = pr.ssn 
WHERE TRUNC(months_between(sysdate, pr.DOB) / 12) > (
    SELECT AVG(TRUNC(months_between(sysdate, pr_inner.DOB) / 12))
    FROM F23_S001_T3_Person pr_inner
    JOIN F23_S001_T3_Passenger p_inner ON pr_inner.ssn = p_inner.ssn
)
ORDER BY pr.ssn
FETCH FIRST 20 ROWS ONLY;

--CUBE
--Retrieve the count of passengers along with their genders, considering all possible combinations of genders and 
--also display 'TOTAL' count. Include only those passengers who have made bookings for rides in the amusement park.

SELECT COALESCE(F23_S001_T3_Person.Gender,'TOTAL') AS GENDER,  (COUNT(F23_S001_T3_Bookings.PassID)) AS PassengerCount
FROM F23_S001_T3_Passenger
JOIN F23_S001_T3_Bookings ON F23_S001_T3_Passenger.PassID = F23_S001_T3_Bookings.PassID
JOIN F23_S001_T3_Ride ON F23_S001_T3_Bookings.RideID = F23_S001_T3_Ride.RideID
JOIN F23_S001_T3_Person ON F23_S001_T3_Passenger.SSN = F23_S001_T3_Person.SSN
GROUP BY CUBE(F23_S001_T3_Person.Gender);

--Display the PassID, RideID, count,and age group of passengers between 51-60 and having duration of the ride greater than 20 minutes.
SELECT
    F23_S001_T3_Passenger.PassID,
    F23_S001_T3_Ride.RideID,
    COUNT(F23_S001_T3_Bookings.PassID) AS PassengerCount,
    '51-60' AS AgeGroup
FROM
    F23_S001_T3_Passenger
JOIN
    F23_S001_T3_Bookings ON F23_S001_T3_Passenger.PassID = F23_S001_T3_Bookings.PassID
JOIN
    F23_S001_T3_Ride ON F23_S001_T3_Bookings.RideID = F23_S001_T3_Ride.RideID
JOIN
    F23_S001_T3_Person ON F23_S001_T3_Passenger.SSN = F23_S001_T3_Person.SSN
JOIN
    F23_S001_T3_RideSchedule ON F23_S001_T3_Ride.RideID = F23_S001_T3_RideSchedule.RideID
WHERE
    TRUNC(MONTHS_BETWEEN(SYSDATE, F23_S001_T3_Person.DOB) / 12) BETWEEN 51 AND 60
GROUP BY
    F23_S001_T3_Passenger.PassID,
    F23_S001_T3_Ride.RideID
HAVING
    (MAX(F23_S001_T3_RideSchedule.EndTime) - MIN(F23_S001_T3_RideSchedule.StartTime)) > INTERVAL '20' MINUTE;

--Retrieve the employee ID, designation, and salary for 
--employees whose salary is greater than to the average salary for employees in the same designation.
SELECT
    f23_s001_t3_employee.empid,
    f23_s001_t3_employee.designation,
    f23_s001_t3_employee.salary AS avgsalary
FROM
    f23_s001_t3_employee
GROUP BY
    f23_s001_t3_employee.designation,
    f23_s001_t3_employee.salary,
    f23_s001_t3_employee.empid
HAVING
    f23_s001_t3_employee.salary > (
        SELECT
            AVG(f23_s001_t3_employee.salary)
        FROM
            f23_s001_t3_employee
    );

--Retrieve the booking IDs and passenger names for bookings where the passenger's name starts with 'A'

SELECT
    B.BookingID,
    P1.Name
FROM
    F23_S001_T3_Bookings B
JOIN
    F23_S001_T3_Passenger P ON B.PassID = P.PassID
JOIN
    F23_S001_T3_Person P1 ON P.SSN = P1.SSN
WHERE
    UPPER(P1.Name) LIKE 'A%';

--OVER
--retrieve the employee ID (EmpID), salary, and the
--average salary calculated across all employees
SELECT
    EmpID,
    Salary,
    AVG(Salary) OVER () AS AverageSalaryAcrossAllEmployees
FROM
    F23_S001_T3_Employee;


--DIVISION --
--Find the distinct count of employee IDs (EMPID) associated with 
--zones where every ride within each zone has 
--at least one booking on the specified date, which is September 4, 2023.
SELECT DISTINCT COUNT(Z.EMPID)
FROM F23_S001_T3_Zone Z
WHERE NOT EXISTS (
    SELECT R.RIDEID
    FROM F23_S001_T3_Ride R
    WHERE NOT EXISTS (
        SELECT COUNT(B.RIDEID)
        FROM F23_S001_T3_Bookings B
        WHERE B.RIDEID = R.RIDEID
        AND B.DATEOFVISIT = TO_DATE('2023-09-04','YYYY-MM-DD')
    )
);