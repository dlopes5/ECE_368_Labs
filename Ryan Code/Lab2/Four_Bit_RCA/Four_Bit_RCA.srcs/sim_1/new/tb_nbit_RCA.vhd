----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2022 10:48:33 AM
-- Design Name: 
-- Module Name: tb_nbit_RCA - Structural
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

entity tb_nbit_RCA is
  Port (A,B: IN SIGNED(3 DOWNTO 0); S: OUT SIGNED(3 DOWNTO 0); OV: OUT std_logic; Cin, Cout: INOUT SIGNED(3 DOWNTO 0) );
  -- we are using 3 DOWNTO 0 in this case since the comp is being tested with n=4
end tb_nbit_RCA;

architecture Structural of tb_nbit_RCA is
-- COMPONENT DECLARATION
COMPONENT n_bit_RCA PORT (A,B: IN SIGNED(3 DOWNTO 0); S: OUT SIGNED(3 DOWNTO 0); OV: OUT std_logic; Cin, Cout: INOUT SIGNED(3 DOWNTO 0) );
end COMPONENT;

begin
x: n_bit_RCA port map (A,B,S,OV,Cin,Cout);

end Structural;
