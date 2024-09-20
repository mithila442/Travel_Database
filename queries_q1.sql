-- 1. (A) 2 Summary Statistics as per general business aim.
-- Query to get the total number of bookings per hotel
    SELECT Hotel_ID, COUNT(*) AS Total_Bookings
    FROM Itinerary
    GROUP BY Hotel_ID;
--
---- Query to calculate the average amount spent on payments
    SELECT AVG(Amount) AS Average_Spending
    FROM Payments;

--1. (B) 1 Transaction from the business perspective.
-- update a customer's email address and phone number
    CREATE OR REPLACE PROCEDURE update_customer_contact(
      p_customer_id IN Customers.Customer_ID%TYPE,
      p_new_phone IN Customers.Phone_Number%TYPE,
      p_new_email IN Customers.Email%TYPE
    ) AS
    BEGIN
      -- Start of the transaction
      SAVEPOINT start_tran;
    
      -- Update the customer's phone number
      UPDATE Customers
      SET Phone_Number = p_new_phone
      WHERE Customer_ID = p_customer_id;
    
      -- Update the customer's email
      UPDATE Customers
      SET Email = p_new_email
      WHERE Customer_ID = p_customer_id;
    
      -- If everything is fine, commit the transaction
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        -- If any error occurs, rollback to the savepoint
        ROLLBACK TO start_tran;
        RAISE; -- Re-raise the exception to be handled by the caller
    END update_customer_contact;
    /
    
    --calling the procedure "update_customer_contact"
    BEGIN
      update_customer_contact(
        p_customer_id => 134001,
        p_new_phone => '(123) 456-7890',
        p_new_email => 'jd1996@gmail.com'
      );
    END;
    /

--1. C)1 Data insertion query where a constraint needs to be preserved.
-- creates another payment entry for an existing customer. Constraint is customer has to be an existing customer record.
-- Also branch has to be an existing branch.
    CREATE OR REPLACE PROCEDURE insert_payment_record (
      p_Payment_ID    IN Payments.Payment_ID%TYPE,
      p_CardNumber    IN Payments.CardNumber%TYPE,
      p_ExpiryDate    IN Payments.ExpiryDate%TYPE,
      p_NameOnTheCard IN Payments.NameOnTheCard%TYPE,
      p_CardType      IN Payments.CardType%TYPE,
      p_PaymentNetwork IN Payments.PaymentNetwork%TYPE,
      p_HappenedAt    IN Payments.HappenedAt%TYPE, 
      p_Amount        IN Payments.Amount%TYPE,
      p_Customer_ID   IN Payments.Customer_ID%TYPE,
      p_Branch_ID     IN Payments.Branch_ID%TYPE
    ) AS
      v_customer_exists INT;
      v_branch_exists   INT;
    BEGIN
      -- Check if Customer_ID exists
      SELECT COUNT(*)
      INTO v_customer_exists
      FROM Customers
      WHERE Customer_ID = p_Customer_ID;
    
      IF v_customer_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer ID does not exist.');
      END IF;
    
      -- Check if Branch_ID exists
      SELECT COUNT(*)
      INTO v_branch_exists
      FROM Branch
      WHERE Branch_ID = p_Branch_ID;
    
      IF v_branch_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Branch ID does not exist.');
      END IF;
    
      -- Insert the payment record
      INSERT INTO Payments (
        Payment_ID, CardNumber, ExpiryDate, NameOnTheCard, CardType, PaymentNetwork, HappenedAt, Amount, Customer_ID, Branch_ID
      ) VALUES (
        p_Payment_ID, p_CardNumber, p_ExpiryDate, p_NameOnTheCard, p_CardType, p_PaymentNetwork, p_HappenedAt, p_Amount, p_Customer_ID, p_Branch_ID
      );
    
      -- If everything is fine, commit the transaction
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        -- If any other error occurs, rollback the transaction
        ROLLBACK;
        -- Log the error or take other appropriate actions
        RAISE; -- Re-raise the exception to be handled by the calling environment
    END insert_payment_record;

    -- calling the procedure "insert_payment_record"
    BEGIN
      insert_payment_record(
        p_Payment_ID    => seq_payments.NEXTVAL, -- Assuming 'seq_payments' is a sequence for auto-incrementing IDs
        p_CardNumber    => '1234-5678-9123-4567',
        p_ExpiryDate    => TO_DATE('2025-12-31', 'YYYY-MM-DD'),
        p_NameOnTheCard => 'Ismail Aziz',
        p_CardType      => 'CREDIT',
        p_PaymentNetwork=> 'VISA',
        p_HappenedAt    => SYSTIMESTAMP, 
        p_Amount        => 400.00,
        p_Customer_ID   => 134012, -- Example customer ID
        p_Branch_ID     => 2032    -- Example branch ID
      );
    END;

--1. D)1 Data deletion query where a constraint needs to be preserved.
-- deletes an existing customer entry who doesn't have a payment record. Constraint is customer has to have zero record of payment to be deleted.
    CREATE OR REPLACE PROCEDURE delete_customer (
      p_Customer_ID Customers.Customer_ID%TYPE
    ) AS
      v_payment_exists INT;
    BEGIN
      -- Check if there are any payments associated with the customer
      SELECT COUNT(*)
      INTO v_payment_exists
      FROM Payments
      WHERE Customer_ID = p_Customer_ID;
    
      IF v_payment_exists = 0 THEN
        -- If no payments are associated, it's safe to delete the customer
        DELETE FROM Customers
        WHERE Customer_ID = p_Customer_ID;
    
        -- After deletion, output a message to indicate success
        DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_Customer_ID || ' has been deleted.');
      ELSE
        -- If there are existing payments, output a message to indicate that deletion is not possible
        DBMS_OUTPUT.PUT_LINE('Cannot delete customer with ID ' || p_Customer_ID || ' because there are existing payments.');
      END IF;
    END delete_customer;
    
    --calling the procedure "delete_customer"
    BEGIN
      delete_customer(p_Customer_ID => 134006);
    END;








