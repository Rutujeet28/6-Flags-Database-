--ALTER TABLE F23_S001_T3_Bookings
--DROP CONSTRAINT FK_Bookings_Passenger;

--ALTER TABLE F23_S001_T3_Bookings
--DROP CONSTRAINT FK_Bookings_Ride;

--ALTER TABLE F23_S001_T3_Ride
--DROP CONSTRAINT FK_Ride_Bookings;

drop table F23_S001_T3_Person cascade constraints purge;
drop table F23_S001_T3_Passenger cascade constraints purge;
drop table F23_S001_T3_Bookings cascade constraints purge;
drop table F23_S001_T3_Ride cascade constraints purge;
drop table F23_S001_T3_RideSchedule cascade constraints purge;
drop table F23_S001_T3_Zone cascade constraints purge;
drop table F23_S001_T3_Employee cascade constraints purge;
commit;