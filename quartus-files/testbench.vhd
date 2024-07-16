library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is

    -- Component Declaration for the Unit Under Test (UUT)
    component SHA256
        Port (clk,rst,start:in std_logic;i4:out std_logic;
               aso,bso,cso,dso,eso,fso,gso,hso,aco,bco,cco,dco,eco,fco,gco,hco,i0,i1,i2,i3,mewout1:out std_logic_vector(31 downto 0);
               counts:out std_logic_vector(9 downto 0));
    end component;

    -- Inputs
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal start : std_logic := '0';
	 signal w_write : std_logic;

    -- Outputs
    signal aso, bso, cso, dso, eso, fso, gso, hso,ao,bo,co,do,eo,fo,go,ho,i0,i1,i2,i3,mewout: std_logic_vector(31 downto 0);
    signal counts : std_logic_vector(9 downto 0);

    -- Clock period definition
    constant clk_period : time := 100 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: SHA256 Port map (
          clk => clk,
          rst => rst,
          start => start,
          aso => aso,
          bso => bso,
          cso => cso,
          dso => dso,
          eso => eso,
          fso => fso,
          gso => gso,
          hso => hso,i0=>i0,i1=>i1,i2=>i2,i3=>i3,mewout1=>mewout,i4=>w_write,
          counts => counts,aco=>ao,bco=>bo,cco=>co,dco=>do,eco=>eo,fco=>fo,gco=>go,hco=>ho
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
        start <= '0';

    -- Stimulus process
    stim_proc: process
    begin	
        -- hold reset state for 100 ns.
        wait for 100 ns;
        rst <= '1';
        wait for clk_period/2;
        rst <= '0';
        
        -- Add stimulus here


        -- Wait for the simulation to complete
        wait for 50000 ns;
        
        -- Stop simulation
        assert false report "End of simulation" severity failure;
    end process;

end Behavioral;