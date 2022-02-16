LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------
ENTITY my_full_adder IS
PORT (a, b,cin: IN STD_LOGIC;
        S, C: OUT STD_LOGIC);
END my_full_adder;
-------------------------------------------------
ARCHITECTURE dataflow OF my_full_adder IS
BEGIN 
    S <= a XOR b XOR cin;
    C <= (a AND b) OR (a AND cin) OR 
         (B and cin);
END dataflow;