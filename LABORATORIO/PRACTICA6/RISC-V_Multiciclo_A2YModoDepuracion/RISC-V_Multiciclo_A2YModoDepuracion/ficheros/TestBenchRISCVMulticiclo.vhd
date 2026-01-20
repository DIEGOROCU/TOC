LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TestBenchRISCVMulticiclo IS
END TestBenchRISCVMulticiclo;
 
ARCHITECTURE behavior OF TestBenchRISCVMulticiclo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RISCVMulticiclo
    PORT(
         clk              : in  std_logic;
         rst              : in  std_logic;
		 display	      : out std_logic_vector(6 downto 0);
		 display_enable   : out std_logic_vector(3 downto 0);
		 modo		      : in 	std_logic;
		 siguiente        : in 	std_logic         
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 100 ns;
   
   signal display	      : std_logic_vector(6 downto 0);
   signal display_enable  : std_logic_vector(3 downto 0);
   signal modo		      : std_logic;
   signal siguiente       : std_logic;   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RISCVMulticiclo PORT MAP (
          clk             => clk,
          rst             => rst,
		  display         => display,
		  display_enable  => display_enable,
		  modo            => modo,		    
		  siguiente       => siguiente           
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 200 ns.
	  rst <= '1';
	  modo <= '0';
      wait for 200 ns;	

	  rst <= '0';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
