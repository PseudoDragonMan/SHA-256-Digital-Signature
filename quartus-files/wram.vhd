library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wram is
    port (
        w_write: in std_logic;
        w_sel: in std_logic_vector(1 downto 0);
        w_in: in std_logic_vector(31 downto 0);
        w_A, w_A0, w_A1, w_A2, w_A3,w_r: in std_logic_vector(5 downto 0);
        wout0, wout1, wout2, wout3,woutr: out std_logic_vector(31 downto 0);
        clk, rst: in std_logic
    );
end entity wram;

architecture a of wram is
    type mem is array (0 to 63) of std_logic_vector(31 downto 0);
    signal data0, data1, data2, data3: mem := (
        0 => x"00000000", 1 => x"00000001", 2 => x"00000002", 3 => x"00000003",
        4 => x"00000004", 5 => x"00000005", 6 => x"00000006", 7 => x"00000007",
        8 => x"00000008", 9 => x"00000009", 10 => x"0000000A", 11 => x"0000000B",
        12 => x"0000000C", 13 => x"0000000D", 14 => x"0000000E", 15 => x"0000000F",
        16 => x"00000010", 17 => x"00000011", 18 => x"00000012", 19 => x"00000013",
        20 => x"00000014", 21 => x"00000015", 22 => x"00000016", 23 => x"00000017",
        24 => x"00000018", 25 => x"00000019", 26 => x"0000001A", 27 => x"0000001B",
        28 => x"0000001C", 29 => x"0000001D", 30 => x"0000001E", 31 => x"0000001F",
        32 => x"00000020", 33 => x"00000021", 34 => x"00000022", 35 => x"00000023",
        36 => x"00000024", 37 => x"00000025", 38 => x"00000026", 39 => x"00000027",
        40 => x"00000028", 41 => x"00000029", 42 => x"0000002A", 43 => x"0000002B",
        44 => x"0000002C", 45 => x"0000002D", 46 => x"0000002E", 47 => x"0000002F",
        48 => x"00000030", 49 => x"00000031", 50 => x"00000032", 51 => x"00000033",
        52 => x"00000034", 53 => x"00000035", 54 => x"00000036", 55 => x"00000037",
        56 => x"00000038", 57 => x"00000039", 58 => x"0000003A", 59 => x"0000003B",
        60 => x"0000003C", 61 => x"0000003D", 62 => x"0000003E", 63 => x"0000003F"
    );

begin

    process (clk, rst,w_sel)
    begin
        if rst = '1' then
-- Fill data0 array 
data0(0)  <= X"48694961";--Text "HiIamMithinKumarPentapallifromIITBOMBAYElectrical" is encoded in utf-8 preproceesed and hard-coded into all four wram blocks
data0(1)  <= X"6D4D6974";
data0(2)  <= X"68696E4B";
data0(3)  <= X"756D6172";
data0(4)  <= X"50656E74";
data0(5)  <= X"6170616C";
data0(6)  <= X"6C696672";
data0(7)  <= X"6F6D4949";
data0(8)  <= X"54424F4D";
data0(9)  <= X"42415945";
data0(10) <= X"6C656374";
data0(11) <= X"72696361";
data0(12) <= X"6C800000";
data0(13) <= X"00000000";
data0(14) <= X"00000000";
data0(15) <= X"00000188";

-- Fill data1 array
data1(0)  <= X"48694961";
data1(1)  <= X"6D4D6974";
data1(2)  <= X"68696E4B";
data1(3)  <= X"756D6172";
data1(4)  <= X"50656E74";
data1(5)  <= X"6170616C";
data1(6)  <= X"6C696672";
data1(7)  <= X"6F6D4949";
data1(8)  <= X"54424F4D";
data1(9)  <= X"42415945";
data1(10) <= X"6C656374";
data1(11) <= X"72696361";
data1(12) <= X"6C800000";
data1(13) <= X"00000000";
data1(14) <= X"00000000";
data1(15) <= X"00000188";

-- Fill data2 array
data2(0)  <= X"48694961";
data2(1)  <= X"6D4D6974";
data2(2)  <= X"68696E4B";
data2(3)  <= X"756D6172";
data2(4)  <= X"50656E74";
data2(5)  <= X"6170616C";
data2(6)  <= X"6C696672";
data2(7)  <= X"6F6D4949";
data2(8)  <= X"54424F4D";
data2(9)  <= X"42415945";
data2(10) <= X"6C656374";
data2(11) <= X"72696361";
data2(12) <= X"6C800000";
data2(13) <= X"00000000";
data2(14) <= X"00000000";
data2(15) <= X"00000188";

-- Fill data3 array
data3(0)  <= X"48694961";
data3(1)  <= X"6D4D6974";
data3(2)  <= X"68696E4B";
data3(3)  <= X"756D6172";
data3(4)  <= X"50656E74";
data3(5)  <= X"6170616C";
data3(6)  <= X"6C696672";
data3(7)  <= X"6F6D4949";
data3(8)  <= X"54424F4D";
data3(9)  <= X"42415945";
data3(10) <= X"6C656374";
data3(11) <= X"72696361";
data3(12) <= X"6C800000";
data3(13) <= X"00000000";
data3(14) <= X"00000000";
data3(15) <= X"00000188";

            -- Initialize the rest of data3 memory as needed

        elsif rising_edge(clk) then
            if w_write = '1' then
                case w_sel is
                    when "00" =>
                        data0(to_integer(unsigned(w_A))) <= w_in;
                    when "01" =>
                        data1(to_integer(unsigned(w_A))) <= w_in;
                    when "10" =>
                        data2(to_integer(unsigned(w_A))) <= w_in;
                    when "11" =>
                        data3(to_integer(unsigned(w_A))) <= w_in;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    process (w_r,w_A0, w_A1, w_A2, w_A3, data0, data1, data2, data3,w_sel)
    begin
        wout0 <= data0(to_integer(unsigned(w_A0)));                    
        wout1 <= data1(to_integer(unsigned(w_A1)));    
        wout2 <= data2(to_integer(unsigned(w_A2)));    
        wout3 <= data3(to_integer(unsigned(w_A3))); 
	     case w_sel is
                    when "00" =>
                        woutr<=data0(to_integer(unsigned(w_r)));
                    when "01" =>
                        woutr<=data1(to_integer(unsigned(w_r)));
                    when "10" =>
                        woutr<=data2(to_integer(unsigned(w_r)));
                    when "11" =>
                        woutr<=data3(to_integer(unsigned(w_r)));
                    when others =>
                        null;
                end case;  
    end process;

end architecture a;
