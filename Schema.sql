CREATE SEQUENCE seq_customers
START WITH 134001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_hotels
START WITH 23001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_packages
START WITH 101
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_branch
START WITH 2031
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_flights
START WITH 1001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_cs_support
START WITH 101
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_payments
START WITH 10001
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_employees
START WITH 1230
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_car_rentals
START WITH 2100
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_itinerary
START WITH 101
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seq_refunds
START WITH 2001
INCREMENT BY 1
NOCACHE
NOCYCLE;


-- Customers Table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    First_Name VARCHAR2(255) NOT NULL,
    Last_Name VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Phone_Number VARCHAR2(255) UNIQUE NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Gender VARCHAR2(20) CHECK (Gender IN ('Male', 'Female', 'Other', 'Prefer not to say')) NOT NULL,
    Passport_Number VARCHAR2(255) UNIQUE NOT NULL,
    Issuing_Country VARCHAR2(50) NOT NULL,
    Meal_Preference VARCHAR2(20) CHECK (Meal_Preference IN ('Vegetarian', 'Vegan', 'Gluten Free')) NOT NULL
);

-- Hotels Table
CREATE TABLE Hotels (
    Hotel_ID INT PRIMARY KEY,
    Hotel_Name VARCHAR2(255) NOT NULL,
    Operated_By VARCHAR2(255) NOT NULL,
    Hotel_email VARCHAR2(255) UNIQUE NOT NULL,
    Hotel_Phone_No VARCHAR2(255) UNIQUE NOT NULL,
    Street_Name VARCHAR2(255) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    State VARCHAR2(50) NOT NULL,
    Zip_Code VARCHAR2(50) NOT NULL,
    Country VARCHAR2(50) NOT NULL
);

-- Packages Table
CREATE TABLE Packages_name (
    Package_ID INT PRIMARY KEY,
    Package_Name VARCHAR2(255) UNIQUE NOT NULL,
    Stay_duration NUMBER(10, 2) CHECK (Stay_duration >= 0),
    Car_Rental_duration NUMBER(10, 2) CHECK (Car_Rental_duration >= 0)
);

-- Branch Table
CREATE TABLE Branch (
    Branch_ID INT PRIMARY KEY,
    City VARCHAR2(50) NOT NULL,
    Country VARCHAR2(50) NOT NULL,
    Branch_email VARCHAR2(255) UNIQUE NOT NULL,
    Zip_Code VARCHAR2(50) NOT NULL,
    Contact_No VARCHAR2(255) UNIQUE NOT NULL,
    Street_name VARCHAR2(255) NOT NULL
);

-- Flights Table
CREATE TABLE Flights (
    Flight_Reference INT PRIMARY KEY,
    Airways VARCHAR2(255) NOT NULL,
    Departure_Time TIMESTAMP NOT NULL,
    Arrival_Time TIMESTAMP NOT NULL,
    Source_name VARCHAR2(255) NOT NULL,
    Destination_name VARCHAR2(255) NOT NULL,
    CHECK (Arrival_Time > Departure_Time)
);


-- Customer Support Table
CREATE TABLE Customer_support (
    CS_ID INT PRIMARY KEY,
    Phone_No VARCHAR2(255) NOT NULL UNIQUE,
    Email VARCHAR2(255) NOT NULL UNIQUE,
    Country VARCHAR2(50) NOT NULL,
    Website VARCHAR2(255) NOT NULL UNIQUE
);

-- Payments Table
CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    CardNumber VARCHAR2(50) NOT NULL UNIQUE,
    ExpiryDate DATE NOT NULL,
    NameOnTheCard VARCHAR2(255) NOT NULL,
    CardType VARCHAR2(50) NOT NULL,
    PaymentNetwork VARCHAR2(50) NOT NULL,
    HappenedAt TIMESTAMP NOT NULL, 
    Amount NUMBER(10, 2) CHECK (Amount > 0),
    Customer_ID INT,
    Branch_ID INT,
    CONSTRAINT fk_customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE CASCADE,
    CONSTRAINT fk_branch FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID) ON DELETE CASCADE
);

-- Employees Table
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    First_Name VARCHAR2(255) NOT NULL,
    Last_Name VARCHAR2(255) NOT NULL,
    Phone_Number VARCHAR2(255) UNIQUE NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Branch_ID INT,
    Role_emp VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_employee_branch FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)ON DELETE CASCADE
);

-- Car Rentals Table
CREATE TABLE Car_rentals (
    Rental_ID INT PRIMARY KEY,
    Company_Name VARCHAR2(255) NOT NULL,
    Pickup_Time TIMESTAMP NOT NULL,
    Return_Time TIMESTAMP NOT NULL,
    Vehicle_No VARCHAR2(255) UNIQUE NOT NULL,
    Vehicle_Description VARCHAR2(255) NOT NULL,
    Mileage NUMBER CHECK (Mileage >= 0),
    Rented_Duration NUMBER(10,2) CHECK (Rented_Duration >= 0),
    Vehicle_Group VARCHAR2(50) NOT NULL,
    Customer_ID INT,
    Payment_ID INT,
    CHECK (Return_Time > Pickup_Time),
    CONSTRAINT fk_car_rental_customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE CASCADE,
    CONSTRAINT fk_car_rental_payment FOREIGN KEY (Payment_ID) REFERENCES Payments(Payment_ID) ON DELETE CASCADE
);

-- Itinerary Table
CREATE TABLE Itinerary (
    Itinerary_ID INT PRIMARY KEY,
    Class VARCHAR2(50) NOT NULL,
    Departure_Date TIMESTAMP NOT NULL,
    Arrival_Date TIMESTAMP NOT NULL,
    Customer_ID INT,
    Flight_Reference INT,
    Package_ID INT,
    Payment_ID INT,
    Rental_ID INT,
    Hotel_ID INT,
    CHECK (Arrival_Date > Departure_Date),
    CONSTRAINT fk_itinerary_customer FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE CASCADE,
    CONSTRAINT fk_itinerary_payment FOREIGN KEY (Payment_ID) REFERENCES Payments(Payment_ID) ON DELETE CASCADE,
    CONSTRAINT fk_itinerary_flight FOREIGN KEY (Flight_Reference) REFERENCES Flights(Flight_Reference) ON DELETE CASCADE,
    CONSTRAINT fk_itinerary_package FOREIGN KEY (Package_ID) REFERENCES Packages_name(Package_ID) ON DELETE CASCADE,
    CONSTRAINT fk_itinerary_rental FOREIGN KEY (Rental_ID) REFERENCES Car_rentals(Rental_ID) ON DELETE CASCADE,
    CONSTRAINT fk_itinerary_hotel FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE
);

-- Refunds Table
CREATE TABLE Refunds (
    Refund_ID INT PRIMARY KEY,
    Refund_Status VARCHAR2(50) NOT NULL,
    Refund_Amount NUMBER(10,2) CHECK (Refund_Amount >= 0),
    Itinerary_ID INT,
    Branch_ID INT,
    CONSTRAINT fk_refund_itinerary FOREIGN KEY (Itinerary_ID) REFERENCES Itinerary(Itinerary_ID) ON DELETE CASCADE,
    CONSTRAINT fk_refund_branch FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID) ON DELETE CASCADE
);

-- relationship set table packages_flights
CREATE TABLE Packages_Flights (
    Flight_Reference INT,
    Package_ID INT,
    Price NUMBER(10,2) CHECK (Price >= 0),
    Currency VARCHAR2(20),
    CONSTRAINT PK_Flight_Packages PRIMARY KEY (Flight_Reference, Package_ID),
    CONSTRAINT FK_Flight FOREIGN KEY (Flight_Reference) REFERENCES Flights(Flight_Reference) ON DELETE CASCADE,
    CONSTRAINT FK_Package FOREIGN KEY (Package_ID) REFERENCES Packages_name(Package_ID) ON DELETE CASCADE
);

COMMIT;