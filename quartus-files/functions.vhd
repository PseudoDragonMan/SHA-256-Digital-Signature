library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


package Gates is

component Adder32 is
    Port ( A : in  STD_LOGIC_VECTOR(31 downto 0);
           B : in  STD_LOGIC_VECTOR(31 downto 0);
           Sum : out  STD_LOGIC_VECTOR(31 downto 0);
           CarryOut : out  STD_LOGIC);
end component Adder32;

component SHA256_Constants is
    port (
        index : in integer ;  -- Input index for round constant
        round_constant : out std_logic_vector(31 downto 0)  -- Output round constant based on index
    );
end component ;

end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Entity for 32-bit Adder
entity Adder32 is
    Port ( A : in  STD_LOGIC_VECTOR(31 downto 0);
           B : in  STD_LOGIC_VECTOR(31 downto 0);
           Sum : out  STD_LOGIC_VECTOR(31 downto 0);
           CarryOut : out  STD_LOGIC);
end Adder32;
architecture Behavioral of Adder32 is
begin
    process (A, B)
    variable temp_sum : STD_LOGIC_VECTOR(32 downto 0);
    begin
        temp_sum := ('0' & A) + ('0' & B);
        Sum <= temp_sum(31 downto 0);
        CarryOut <= temp_sum(32);
    end process;
end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SHA256_Constants is
    port (
        index : in integer ;  -- Input index for round constant
        round_constant : out std_logic_vector(31 downto 0)  -- Output round constant based on index
    );
end entity ;

architecture constants of SHA256_Constants is
type SHA256_Keys_Array is array (0 to 63) of std_logic_vector(31 downto 0);
    constant k : SHA256_Keys_Array := (
        x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5",
        x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
        x"d807aa98", x"12835b01", x"243185be", x"550c7dc3",
        x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
        x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc",
        x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
        x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7",
        x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
        x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13",
        x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
        x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3",
        x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
        x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5",
        x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
        x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208",
        x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
    );
begin

    process (index)
    begin
        case index is
            when 0 to 63 =>
                round_constant <= K(index);
            when others =>
                round_constant <= (others => '0');  -- Default to zero if index out of range (optional)
        end case;
    end process;

end architecture constants;
