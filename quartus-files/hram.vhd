library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hram is
    port (
        w_write, w_read: in std_logic;
        w_in0,w_in1,w_in2,w_in3: in std_logic_vector(31 downto 0);
        w_A: in std_logic_vector(2 downto 0);
        wout00, wout01, wout02, wout03,wout04, wout05, wout06, wout07 : out std_logic_vector(31 downto 0);
		  sel:in std_logic_vector(1 downto 0);
        clk, rst: in std_logic
    );
end entity hram;

architecture a of hram is
    type mem is array (0 to 7) of std_logic_vector(31 downto 0);
    signal data0, data1, data2, data3: mem := (others => (others => '0'));

begin

reading:process(clk,rst,sel,data0,data1,data2,data3)
         begin
            case sel is
                    when "00" =>
						  wout00 <= data0(0);
							wout01 <= data0(1);
							wout02 <= data0(2);
							wout03 <= data0(3);
							wout04 <= data0(4);
							wout05 <= data0(5);
							wout06 <= data0(6);
							wout07 <= data0(7);

                    when "01" =>
                      wout00 <= data1(0);
							wout01 <= data1(1);
							wout02 <= data1(2);
							wout03 <= data1(3);
							wout04 <= data1(4);
							wout05 <= data1(5);
							wout06 <= data1(6);
							wout07 <= data1(7);
                    when "10" =>
						   wout00 <= data2(0);
							wout01 <= data2(1);
							wout02 <= data2(2);
							wout03 <= data2(3);
							wout04 <= data2(4);
							wout05 <= data2(5);
							wout06 <= data2(6);
							wout07 <= data2(7);
                    when "11" =>
                     wout00 <= data3(0);
							wout01 <= data3(1);
							wout02 <= data3(2);
							wout03 <= data3(3);
							wout04 <= data3(4);
							wout05 <= data3(5);
							wout06 <= data3(6);
							wout07 <= data3(7);
                    when others =>
                        null;
                end case;
				end process;
    process (clk, rst)
    begin
        if rst = '1' then
           -- Initialization for data0
						data0(0) <= x"6a09e667";  -- H(0)
						data0(1) <= x"bb67ae85";  -- H(1)
						data0(2) <= x"3c6ef372";  -- H(2)
						data0(3) <= x"a54ff53a";  -- H(3)
						data0(4) <= x"510e527f";  -- H(4)
						data0(5) <= x"9b05688c";  -- H(5)
						data0(6) <= x"1f83d9ab";  -- H(6)
						data0(7) <= x"5be0cd19";  -- H(7)

						-- Initialization for data1
						data1(0) <= x"6a09e667";  -- H(0)
						data1(1) <= x"bb67ae85";  -- H(1)
						data1(2) <= x"3c6ef372";  -- H(2)
						data1(3) <= x"a54ff53a";  -- H(3)
						data1(4) <= x"510e527f";  -- H(4)
						data1(5) <= x"9b05688c";  -- H(5)
						data1(6) <= x"1f83d9ab";  -- H(6)
						data1(7) <= x"5be0cd19";  -- H(7)

						-- Initialization for data2
						data2(0) <= x"6a09e667";  -- H(0)
						data2(1) <= x"bb67ae85";  -- H(1)
						data2(2) <= x"3c6ef372";  -- H(2)
						data2(3) <= x"a54ff53a";  -- H(3)
						data2(4) <= x"510e527f";  -- H(4)
						data2(5) <= x"9b05688c";  -- H(5)
						data2(6) <= x"1f83d9ab";  -- H(6)
						data2(7) <= x"5be0cd19";  -- H(7)

						-- Initialization for data3
						data3(0) <= x"6a09e667";  -- H(0)
						data3(1) <= x"bb67ae85";  -- H(1)
						data3(2) <= x"3c6ef372";  -- H(2)
						data3(3) <= x"a54ff53a";  -- H(3)
						data3(4) <= x"510e527f";  -- H(4)
						data3(5) <= x"9b05688c";  -- H(5)
						data3(6) <= x"1f83d9ab";  -- H(6)
						data3(7) <= x"5be0cd19";  -- H(7)

        elsif rising_edge(clk) then
            if w_write = '1' then
                   
                        data0(to_integer(unsigned(w_A))) <= w_in0;
                        data1(to_integer(unsigned(w_A))) <= w_in1;
                        data2(to_integer(unsigned(w_A))) <= w_in2;
                        data3(to_integer(unsigned(w_A))) <= w_in3;

            end if;
        end if;
    end process;


end architecture a;
