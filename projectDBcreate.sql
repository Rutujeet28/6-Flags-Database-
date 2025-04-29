--Person
CREATE TABLE F23_S001_T3_Person (
    SSN VARCHAR2(20) PRIMARY KEY,
    Name VARCHAR2(255),
    DOB DATE,
    Gender VARCHAR2(10)
	);
-- Bookings Table
CREATE TABLE F23_S001_T3_Bookings (
    BookingID VARCHAR2(50) PRIMARY KEY,
    PassID VARCHAR2(50),
    RideID VARCHAR2(50),
    DateOfBooking DATE,
    DateOfVisit DATE,
    TimeOfArrival TIMESTAMP
);

-- Ride Table
CREATE TABLE F23_S001_T3_Ride (
    RideID VARCHAR2(50) PRIMARY KEY,
    TicketID VARCHAR2(50),
    TicketFareUSD NUMBER,
    PassID VARCHAR2(50),
    YearOfManufacture INT,
    Capacity INT,
    Maintenance VARCHAR2(255),
    DateOfVisit DATE,
    ModelType VARCHAR(50)
);
CREATE TABLE F23_S001_T3_Passenger (
    PassID VARCHAR2(50) PRIMARY KEY,
    SSN VARCHAR2(20) UNIQUE,
    Phone VARCHAR2(20),
    HomeZipCode VARCHAR2(10),
    FOREIGN KEY (SSN) REFERENCES F23_S001_T3_Person(SSN)
);

-- Employee Table
CREATE TABLE F23_S001_T3_Employee (
    EmpID INT PRIMARY KEY,
    SSN VARCHAR2(20) UNIQUE,
    Email VARCHAR2(255),
    Salary NUMBER,
    Designation VARCHAR2(50),
    ZoneID INT,
    FOREIGN KEY (SSN) REFERENCES F23_S001_T3_Person(SSN)
);

-- RideSchedule Table
CREATE TABLE F23_S001_T3_RideSchedule (
    ScheduleID INT PRIMARY KEY,
    StartTime TIMESTAMP,
    EndTime TIMESTAMP,
    RideID VARCHAR2(50),
    DateOfVisit DATE,
    FOREIGN KEY (RideID) REFERENCES F23_S001_T3_Ride(RideID)
);

-- Zone Table
CREATE TABLE F23_S001_T3_Zone (
    EmpID INT,
    ZoneID INT PRIMARY KEY,
    Name VARCHAR2(50),
    Description VARCHAR2(255),
    FOREIGN KEY (EmpID) REFERENCES F23_S001_T3_Employee(EmpID)
);


-- Alter Bookings Table
ALTER TABLE F23_S001_T3_Bookings
ADD CONSTRAINT FK_Bookings_Passenger
FOREIGN KEY (PassID) REFERENCES F23_S001_T3_Passenger(PassID);

ALTER TABLE F23_S001_T3_Bookings
ADD CONSTRAINT FK_Bookings_Ride
FOREIGN KEY (RideID) REFERENCES F23_S001_T3_Ride(RideID);

-- Alter Ride Table
--ALTER TABLE F23_S001_T3_Ride
--ADD CONSTRAINT FK_Ride_Bookings
--FOREIGN KEY (TicketID) REFERENCES F23_S001_T3_Bookings(BookingID);


commit;
