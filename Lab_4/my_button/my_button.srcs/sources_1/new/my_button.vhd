-------------------LIBRARY----------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

------------------ENTITY------------------------
ENTITY my_button IS 
    PORT(
            CLK100MHZ: IN STD_LOGIC;
            button_press: IN STD_LOGIC;
            LED_Out: OUT STD_LOGIC
        );
END my_button;

-----------------ARCHITECTURE--------------------
ARCHITECTURE Behavioral OF my_button IS

SIGNAL clk_10ms: STD_LOGIC;
SIGNAL cnt: NATURAL RANGE 0 TO 10000000;
signal rst: std_logic:='0';
signal btn_db: std_logic:='0';
signal not_btn_db:std_logic:='1';

COMPONENT dff IS 
        port( 
                d: in std_logic;
                clk: in std_logic;
                rst: in std_logic;
                q: out std_logic;
                qnot: out std_logic
             );   
END COMPONENT;

    BEGIN
dff1: dff port map(d=>button_press, clk=>clk_10ms, rst=>rst,q=>btn_db,qnot=>not_btn_db);
LED_Out<=btn_db;
    
    PROCESS(CLK100MHZ) --process that divides the clock to 10ms
        BEGIN 
           IF CLK100MHZ'EVENT AND CLK100MHZ='1' THEN 
                    IF cnt /=1000000 THEN 
                       cnt<=cnt+1;
                       clk_10ms<='0';
                    ElSIF cnt=1000000 THEN 
                        clk_10ms<='1';
                        cnt<=0;
                   END IF;           
            END IF;
    END PROCESS;
                    
END Behavioral;
