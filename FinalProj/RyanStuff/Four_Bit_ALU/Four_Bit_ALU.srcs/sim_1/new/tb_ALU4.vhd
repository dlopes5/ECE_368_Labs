library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ALU4 is
end tb_ALU4;

architecture Behavioral of tb_ALU4 is
component ALU4
    Port ( a : in std_logic_vector(7 downto 0);
           b : in std_logic_vector(7 downto 0);
           FS : in std_logic_vector(3 downto 0);
           c: out std_logic;
           n: inout STD_LOGIC;
           z: inout STD_LOGIC;
           F : inout std_logic_vector(7 downto 0);
           v : out STD_LOGIC);
end component;
signal Ain: std_logic_vector(7 downto 0);
signal Bin: std_logic_vector(7 downto 0);
signal FS_IN: std_logic_vector(3 downto 0);
signal cin: std_logic;
signal nin: std_logic;
signal zin: std_logic;
signal Fin: std_logic_vector(7 downto 0);
signal vin: std_logic;

begin
U1: ALU4 port map (Ain, Bin, FS_IN, cin, nin, zin, Fin, vin);

process
begin
    Ain<="00000001";
    wait for 20 ns;
    Ain<="11110000";
    wait for 20 ns;
    Ain<="11110000";
end process;

process
begin
    Bin<="00000001";
    wait for 20 ns;
    Bin<="11110000";
    wait for 20 ns;
    Bin<="11110000";
end process;

process
begin
    FS_IN<="0000";
    wait for 40 ns;
    FS_IN<="0001";
    wait for 40 ns;
    FS_IN<="0010";
    wait for 40 ns;
    FS_IN<="0011";
    wait for 40 ns;
    FS_IN<="0100";
    wait for 40 ns;
    FS_IN<="0101";
    wait for 40 ns;
    FS_IN<="0110";
    wait for 40 ns;
    FS_IN<="0111";
    wait for 40 ns;
    FS_IN<="1000";
    wait for 40 ns;
    FS_IN<="1001";
    wait for 40 ns;
    FS_IN<="1010";
    wait for 40 ns;
    FS_IN<="1011";
    wait for 40 ns;
    FS_IN<="1100";
end process;

end Behavioral;
