LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_my_BCD_Converter IS 
END tb_my_BCD_Converter;

ARCHITECTURE my_arch of tb_my_BCD_Converter IS

COMPONENT my_BCD_Converter
    PORT( Ain: IN STD_LOGIC_VECTOR(3 DOWNTO 0); a, b, c, d, e, f, g: OUT STD_LOGIC);
END COMPONENT;

SIGNAL A0: STD_LOGIC :='0';
SIGNAL A1: STD_LOGIC :='0';
SIGNAL A2: STD_LOGIC :='0';
SIGNAL A3: STD_LOGIC :='0';
SIGNAL a : STD_LOGIC;
SIGNAL b : STD_LOGIC;
SIGNAL c : STD_LOGIC;
SIGNAL d : STD_LOGIC;
SIGNAL e : STD_LOGIC;
SIGNAL f : STD_LOGIC;
SIGNAL g : STD_LOGIC;

BEGIN
    U1: my_BCD_Converter PORT MAP(Ain(3) => A3, Ain(2) => A2, Ain(1) => A1, Ain(0) => A0, a => a, b => b, c => c, d => d, e => e, f => f, g => g);

PROCESS 
    BEGIN
        wait for 100 ns;
        A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '1';
        wait for 100 ns;
        A3 <= '0'; A2 <= '0'; A1 <= '1'; A0 <= '0';
        wait for 100 ns;
        A3 <= '0'; A2 <= '0'; A1 <= '1'; A0 <= '1';
        wait for 100 ns;
        A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '0';
        wait for 100 ns;
        A3 <= '0'; A2 <= '1'; A1 <= '0'; A0 <= '1';
        wait for 100 ns;
        A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '0';
        wait for 100 ns;
        A3 <= '0'; A2 <= '1'; A1 <= '1'; A0 <= '1';
        wait for 100 ns;
        A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '0';
        wait for 100 ns;
        A3 <= '1'; A2 <= '0'; A1 <= '0'; A0 <= '1';
        wait for 100 ns;
        
END PROCESS;

END my_arch;