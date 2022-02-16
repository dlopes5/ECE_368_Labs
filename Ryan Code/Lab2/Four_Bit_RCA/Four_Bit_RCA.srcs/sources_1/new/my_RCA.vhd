----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2022 09:04:22 AM
-- Design Name: 
-- Module Name: my_RCA - Dataflow
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_RCA is
    Port ( A: IN UNSIGNED(3 DOWNTO 0);
           B: IN UNSIGNED(3 DOWNTO 0);
           Cout: INOUT UNSIGNED(3 DOWNTO 0);
           Cin: IN std_logic;
           C: INOUT UNSIGNED(3 DOWNTO 0);
           S: OUT UNSIGNED(3 DOWNTO 0));
end my_RCA;

architecture Dataflow of my_RCA is
   
begin
---------------- First Adder ------------   
    S(0) <= A(0) XOR B(0) XOR Cin;
    Cout(0) <= (A(0) AND B(0)) OR (A(0) AND Cin) OR (B(0) AND Cin);
---------------- Second Adder ---------------
    C(1) <= Cout(0);
    S(1) <= A(1) XOR B(1) XOR C(1);
    Cout(1) <= (A(1) AND B(1)) OR (A(1) AND C(1)) OR (B(1) AND C(1));
---------------- Third Adder ------------------
    C(2) <= Cout(1);
    S(2) <= A(2) XOR B(2) XOR C(2);
    Cout(2) <= (A(2) AND B(2)) OR (A(2) AND C(2)) OR (B(2) AND C(2));
--------------- Fourth Adder -------------------
    C(3) <= Cout(2);
    S(3) <= A(3) XOR B(3) XOR C(3);
    Cout(3) <= (A(3) AND B(3)) OR (A(3) AND C(3)) OR (B(3) AND C(3));
    
end Dataflow;
