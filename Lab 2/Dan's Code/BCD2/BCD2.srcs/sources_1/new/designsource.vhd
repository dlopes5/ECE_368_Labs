LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY my_BCD_Converter IS
    PORT ( 
           Ain: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
           --AnodeEn: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
           a : OUT STD_LOGIC;
           b : OUT STD_LOGIC;
           c : OUT STD_LOGIC;
           d : OUT STD_LOGIC;
           e : OUT STD_LOGIC;
           f : OUT STD_LOGIC;
           g : OUT STD_LOGIC);
END my_BCD_Converter;

ARCHITECTURE Structural of my_BCD_Converter IS

SIGNAL SegOut: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN 
SegOut <= "1111110" WHEN Ain ="0000" ELSE --0
          "0110000" WHEN Ain ="0001" ELSE --1
          "1101101" WHEN Ain ="0010" ELSE --2
          "1111001" WHEN Ain ="0011" ELSE --3
          "0110011" WHEN Ain ="0100" ELSE --4
          "1011011" WHEN Ain ="0101" ELSE --5
          "1011111" WHEN Ain ="0110" ELSE --6
          "1110000" WHEN Ain ="0111" ELSE --7
          "1111111" WHEN Ain ="1000" ELSE --8
          "1110011" WHEN Ain ="1001";     --9
          
a <= NOT segOut(6);
b <= NOT SegOut(5);
c <= NOT SegOut(4);
d <= NOT SegOut(3);
e <= NOT SegOut(2);
f <= NOT SegOut(1);
g <= NOt SegOut(0);

--AnodeEn <= "11111110";

END Structural;
