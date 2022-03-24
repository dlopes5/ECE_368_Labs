library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
        port( 
                d: in std_logic;
                clk: in std_logic;
                rst: in std_logic;
                q: out std_logic;
                qnot: out std_logic
             );    
end dff;

architecture Behavioral of dff is

begin
    process(clk, rst)
        begin
            if clk'event and clk='1' then 
                if rst='1' then
                    q<='0';
                    qnot<='1';
                else
                    q<=d;
                    qnot<=not d;
                end if;
            end if; 
    end process;
end Behavioral;