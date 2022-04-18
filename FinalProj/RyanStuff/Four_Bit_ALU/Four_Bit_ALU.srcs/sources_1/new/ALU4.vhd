
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;

entity ALU4 is
    Port ( a : in std_logic_vector(7 downto 0);
           b : in std_logic_vector(7 downto 0);
           FS : in std_logic_vector(3 downto 0);
           c: out std_logic;
           n: inout STD_LOGIC;
           z: inout STD_LOGIC;
           F : inout std_logic_vector(7 downto 0);
           v : out STD_LOGIC);
end ALU4;

architecture Dataflow of ALU4 is
signal cout: std_logic_vector(0 to 8);
signal arithmetic: std_logic;
signal one: std_logic_vector(7 downto 0):= "00000001";
begin
-- ARITHMETIC OPERATIONS -- 
F <=      a WHEN FS = "0000" ELSE
          a + one WHEN FS = "0001" ELSE
          a + b WHEN FS = "0010" ELSE
          a + b + one WHEN FS = "0011" ELSE
          a + (not(b)+one) WHEN FS = "0100" ELSE
          a + (not(b)+one) + one WHEN FS = "0101" ELSE
          a - one WHEN FS = "0110" ELSE --
          a WHEN FS = "0111" ELSE
-- LOGICAL OPERATIONS --
          a and b WHEN FS = "1000" ELSE
          b or b WHEN FS = "1001" ELSE
          a xor b WHEN FS = "1010" ELSE
          not(a)+1 WHEN FS = "1011" ELSE
          b WHEN FS = "1100" ELSE
          "00000000";

arithmetic <= '1' when (FS="0001") or (FS="0010") or (FS="0011") or (FS="0100") or (FS="0101") or (FS="0110") else
              '0';
-- NOW TO SET SOME FLAGS --
-- Zero Flag --
z <=      '1' when F = "00000000" ELSE   -- flag set whenever F="00000000" (ie all zeros)
          '0';
-- Carry Out Flag --
cout(0) <= '0'; -- "carry in"
carry_out: for i in 1 to 8 generate
cout(i) <=  ((a(i-1) and one(i-1)) or (cout(i-1) and (a(i-1) xor one(i-1)))) when (FS="0001" or FS="0110") ELSE 
            ((a(i-1) and b(i-1)) or (cout(i-1) and (a(i-1) xor b(i-1)))); -- c(8) sets carryout flag
end generate carry_out;
c <= cout(8) when arithmetic='1' else
        '0'; -- carry out flag
-- Overflow Flag --
v <= '1' when arithmetic='1' and (((cout(8) ='1') and (cout(7) = '0')) or ((cout(8) ='0') and (cout(7) = '1'))) else 
     '0';
-- Signed Flag --
N <= F(7); -- MSB = Signed Bit of Output

end Dataflow;
