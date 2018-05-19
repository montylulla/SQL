

Create Table Admin
(
User_IDA INT NOT NULL,
first_name VARCHAR(20),
last_name VARCHAR(20),
CONSTRAINT USER_IDA_PK PRIMARY KEY(User_IDA),
CONSTRAINT User_IDA_FK FOREIGN KEY(User_IDA) REFERENCES User1(User_ID)
)

Insert into Admin values(10001,'pranay','lulla')
Insert into Admin values(10002,'harsh','takrani')
Insert into Admin values(10003,'romil','godha')
Insert into Admin values(10004,'omkar','mutreja')
Select * from Admin
Create Table Driver
(
License_Number INT NOT NULL,
user_id INT NOT NULL,
First_Name VARCHAR(20),
Last_Name VARCHAR(20),
Valid_Thru Date NOT NULL,
License_Type VARCHAR(20),
Age INT,
DOB DATE,
validity VARCHAR(20),
VEHICLE_NUMBER VARCHAR(20) NOT NULL,
CONSTRAINT License_Number_PK PRIMARY KEY(License_Number),
CONSTRAINT USER_IDD_FK FOREIGN KEY(user_id) REFERENCES Admin(User_IDA),
CONSTRAINT VEHICLE_NUMBER_FK FOREIGN KEY(VEHICLE_NUMBER) REFERENCES Vehicle(VEHICLE_NUMBER)
)
Insert into Driver values(12345,10001,'abcd','efgh','01/01/2015','Class D',23,'01/02/1995','hariom','vALID')
Insert into Driver values(12346,10001,'defg','hijk','05/01/2016','Class A',24,'01/02/1994','onkar','vALID')
Insert into Driver values(12347,10001,'ghij','klmn','04/01/2014','Class B',25,'01/02/1993','shree','vALID')
Insert into Driver values(12348,10001,'jklm','nopq','03/01/2013','Class D',26,'01/02/1992','namo','vALID')
Insert into Driver values(12349,10001,'mnop','qrst','02/01/2012','Class C',27,'01/02/1991','raga','vALID')
Select * from driver

Create Table Vehicle
(
VEHICLE_NUMBER VARCHAR(20) NOT NULL,
Vehicle_Type VARCHAR(20),
Vehicle_Color VARCHAR(20),
Vehicle_Condition VARCHAR(20),
CONSTRAINT VEHICLE_NUMBER_PK PRIMARY KEY(VEHICLE_NUMBER)
)
Insert into vehicle values('hariom','SUV','blue','good')
Insert into vehicle values('onkar','Sedan','blue','average')
Insert into vehicle values('shree','hatchback','red','v.good')
Insert into vehicle values('namo','hatchback','grey','bad')
Insert into vehicle values('raga','SUV','white','excellent')

Create Table Ticket
(
Ticket_Number VARCHAR(20) NOT NULL,
License_Number INT NOT NULL,
Response VARCHAR(20) NOT NULL,
Date_Affirmed DATE NOT NULL,
Time_Issued TIME NOT NULL,
Reason_of_issue VARCHAR(50),
Place_of_issue VARCHAR(20),
Section VARCHAR(20) NOT NULL,
Officer_ID VARCHAR(20) NOT NULL,
CONSTRAINT Ticket_Number_PK PRIMARY KEY(Ticket_Number),
CONSTRAINT Officer_ID_FK FOREIGN KEY(Officer_ID) REFERENCES Officer(Officer_ID),
Description_id VARCHAR(20) NOT NULL,
CONSTRAINT Description_id FOREIGN KEY(Description_id) REFERENCES Offence_Description(Description_id)
CONSTRAINT LICENSE_NUMBER_FK FOREIGN KEY(LICENSE_NUMBER) REFERENCES DRIVER(LICENSE_NUMBER)
)

Insert into Ticket values('T111','12345','Not guilty','02/03/2018','01:01:02','Speeding','Broome','111A','O10','D10')
Insert into Ticket values('T112','12346','guilty','02/02/2018','11:02:02','Distracted Driving','Syracuse','112B','P11','D13')
Insert into Ticket values('T113','12346','guilty','03/03/2018','01:05:02','Reckless Driving','Binghamton','113C','Q12','D12')
Insert into Ticket values('T114','12347','Not guilty','06/04/2018','10:01:02','Speeding','Buffalo','111A','O10','D10')
Insert into Ticket values('T115','12348','Not guilty','01/02/2018','10:01:02','Running a red light','Syracuse','115E','P11','D13')
Insert into Ticket values('T116','12349','guilty','01/24/2018','16:01:02','Moving Violation','Broome','115F','Q12','D14')
Insert into Ticket values('T117','12349','guilty','02/23/2018','14:14:02','Speeding','Binghamton','111A','O10','D10')

CREATE TABLE OFFICER
(
Officer_ID VARCHAR(20) NOT NULL,
Officer_First_Name VARCHAR(20),
Officer_Last_Name VARCHAR(20),
CONSTRAINT Officer_ID_PK PRIMARY KEY(Officer_ID),
)
Insert into OFFICER values('O10','Alex','O')
Insert into OFFICER values('P11','Mike','P')
Insert into OFFICER values('Q12','Sean','Q')

Create Table Offence_Description
(
Description_id VARCHAR(20) NOT NULL,
Offence VARCHAR(20) NOT NULL,
Penalty VARCHAR(20) NOT NULL,
CONSTRAINT Description_ID_PK PRIMARY KEY(Description_ID)
)
Insert into Offence_Description values('D10','Speeding','5')
Insert into Offence_Description values('D11','Distracted driving','8')
Insert into Offence_Description values('D12','Reckless Driving','6')
Insert into Offence_Description values('D13','Running a red light','4')
Insert into Offence_Description values('D14','Moving Violation','3')

Create Table Detail
(
ID VARCHAR(20) NOT NULL,
LICENSE_NUMBER INT NOT NULL,
COURT_ID VARCHAR(20) NOT NULL,
TICKET_NUMBER VARCHAR(20) NOT NULL,
Court_Date Date NOT NULL
CONSTRAINT Court_ID_FK FOREIGN KEY(Court_ID) REFERENCES Court(Court_ID)
CONSTRAINT ID_PK Primary KEY(ID)
CONSTRAINT TICKET_NUMBER_FK FOREIGN KEY(TICKET_NUMBER) REFERENCES TICKET(TICKET_NUMBER)
)
Select * from Detail
Insert into Detail values('11','COURT1','T111','03/04/2018')
Insert into Detail values('12','COURT2','T112','03/03/2018')
Insert into Detail values('13','COURT3','T113','04/04/2018')
Insert into Detail values('14','COURT4','T114','07/05/2018')
Insert into Detail values('15','COURT2','T115','02/04/2018')
Insert into Detail values('16','COURT1','T116','02/04/2018')
Insert into Detail values('17','COURT3','T117','03/04/2018')

Create Table Court
(
Court_ID VARCHAR(20) NOT NULL,
Court_Name VARCHAR(20),
County VARCHAR(20),
Contact VARCHAR(20),
State VARCHAR(20)
CONSTRAINT Court_ID_PK Primary KEY (Court_ID)
)
Insert into Court values('COURT1','Kirkwood town','broome','3154430000','New York')
Insert into Court values('COURT2','Syracuse','syracuse','3154430001','New York')
Insert into Court values('COURT3','binghamton','binghamton','3154430002','New York')
Insert into Court values('COURT4','buffalo','buffalo','3154430003','New York')
Select * from Ticket
Select * from Offence_Description 
sELECT * FROM COURT

CREATE TRIGGER suspend_License 
ON Ticket
FOR Insert,UPDATE as
if @@ROWCOUNT>=1
BEGIN
UPDATE Driver
SET Validity='SUSPENDED'
FROM
(Select T.License_Number, sum(Points) "Total Points"
from Ticket as T
Inner Join inserted
Inner Join Offence_Description as OD ON T.Description_id=OD.Description_id
Inner Join Driver as D ON D.License_Number=T.License_Number
group by T.License_Number
HAVING sum(Points)>12) as abb
Where Driver.License_Number=abb.License_Number
END;

Insert into Ticket values('T118','12346','guilty','03/03/2018','01:05:02','Reckless Driving','Binghamton','113C','Q12','D12')
Select * from Offence_Description
Select * from Driver
