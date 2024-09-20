# Travel Agency Database Management System

This project implements a comprehensive database management system for a travel agency, designed to handle customers, bookings, flights, payments, and more. The database supports efficient management of business operations, providing insights into customer behavior, revenue distribution, and operational efficiency.

## Project Overview

- **Purpose**: To streamline the management of a travel agency's operations, including customer details, hotel bookings, travel packages, flights, payments, and customer support.
- **Technologies Used**: Oracle SQL, PL/SQL for database creation, data manipulation, and business intelligence queries.

## Database Schema

- **Customers**: Manages customer data including contact information, meal preferences, and passport details.
- **Hotels**: Stores hotel information such as location, contact details, and management.
- **Packages**: Lists travel packages with details on stay and car rental durations.
- **Flights**: Contains flight schedules, airline information, and route details.
- **Payments**: Records transaction data with payment details linked to customers and branches.
- **Branch**: Represents various branches of the agency and their location details.
- **Refunds**: Logs refund transactions to monitor branch performance and customer satisfaction.
- **Itinerary**: Manages detailed travel plans linking flights, hotels, car rentals, and packages.

## Key Features

### **1. Business Insights and Operations:**
- **Booking Trends and Spending**: Analyzes customer booking trends and average spending per booking quarterly to predict financial trends and plan budgets.
- **Popular Travel Packages**: Evaluates the popularity and duration of stays associated with each package to refine offerings.
- **Airline and Package Analysis**: Assesses flight and package frequency per airline, aiding in strategic airline partnerships.
- **Revenue Distribution**: Identifies high-revenue branches and countries to guide investment decisions.

### **2. Transaction Management:**
- **Customer Contact Update**: Safely updates customer contact information within a transaction, ensuring data integrity.
- **Payment Insertion**: Adds new payment records, verifying existing customer and branch associations to preserve constraints.
- **Customer Deletion**: Deletes customers only if no associated payments exist, maintaining data consistency.

### **3. Operational Performance:**
- **Refund Analysis**: Highlights branches with high refund amounts to pinpoint operational inefficiencies and enhance customer satisfaction.

## How to Use

1. **Schema Setup**: Run the provided SQL scripts to create the database schema and sequences.
2. **Data Insertion**: Use the data insertion scripts to populate the database with sample data instances.
3. **Execute Queries**: Run the provided queries to gain insights into the business operations and performance.

## Contributors

- Mayesha Maliha Rahman Mithila

## License

This project is for educational purposes only.

