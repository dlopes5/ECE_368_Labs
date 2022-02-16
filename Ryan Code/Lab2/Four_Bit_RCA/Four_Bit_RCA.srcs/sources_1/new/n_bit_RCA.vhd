----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2022 03:54:22 PM
-- Design Name: 
-- Module Name: n_bit_RCA - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.All;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity n_bit_RCA is
    generic(n: integer:=4); -- n bit
    port(A,B: IN signed((n)-1 downto 0);
          --C0: IN std_logic;
          S: OUT signed((n)-1 downto 0);
          OV: OUT std_logic; -- overflow bit
          Cin: INOUT signed((n)-1 downto 0);
          Cout: INOUT signed((n)-1 downto 0) );
--  Port ( );
end n_bit_RCA;

architecture Behavioral of n_bit_RCA is

begin
    S(0) <=  A(0) XOR B(0) XOR Cin(0);
    Cout(0) <= (A(0) AND B(0)) OR (A(0) AND Cin(0)) OR (B(0) AND Cin(0));
    
    gen: for i in 1 to (n)-1 generate
    Cin(i) <= Cout(i-1);
    S(i) <= A(i) XOR B(i) XOR Cin(i);
    Cout(i) <= (A(i) AND B(i)) OR (A(i) AND Cin(i)) OR (B(i) AND Cin(i));
    end generate;
    OV <='1' when ((Cout((n)-1)='1') AND (Cout((n)-2)='0')) else
    '1' when ((Cout((n)-1)='0') AND (Cout((n)-2)='1')) else
    '0';
end Behavioral;
