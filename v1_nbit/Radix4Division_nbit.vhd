--------------------------------------------
-- Project		:	None

-- Component	:	
-- Description	:	
--				:	

-- Author		:	Eric Holman

-- Date Created	:	

-- Revisions	:

-- Date		Ref		Revision


--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Radix4Division_nbit is
	generic(
		w			:	INTEGER := 8
	);
	port(
		clk			: in  STD_LOGIC;
		n_in	    : in  STD_LOGIC_VECTOR (w-1 downto 0);
		d_in	    : in  STD_LOGIC_VECTOR (w-1 downto 0);
		q_out		: out STD_LOGIC_VECTOR (w-1 downto 0);
		r_out		: out STD_LOGIC_VECTOR (w-1 downto 0)
	);
end Radix4Division_nbit;
	
architecture Behavioral of Radix4Division_nbit is

	component Radix4Stage_nbit is
		generic(
			w			:	INTEGER := 8
		);
		port(
			clk			: in  STD_LOGIC;
			d_in		: in  UNSIGNED (w-1 downto 0);
			p_in		: in  UNSIGNED (2*w-1 downto 0);
			q_in		: in  UNSIGNED (w-1 downto 0);
			d_out		: out UNSIGNED (w-1 downto 0);
			p_out		: out UNSIGNED (2*w-1 downto 0);
			q_out		: out UNSIGNED (w-1 downto 0)
		);
	end component;
	
	type		u64_array		is	ARRAY (integer range <>) of UNSIGNED (2*w-1 downto 0);
	type		u32_array		is	ARRAY (integer range <>) of UNSIGNED (w-1 downto 0);
	
	constant	p_pad			:	UNSIGNED (w-1 downto 0) := (others => '0');
	
	signal		p_int			:	u64_array(0 to w/2) := (others => (others => '0'));
	signal		d_int			:	u32_array(0 to w/2) := (others => (others => '0'));	
	signal		q_int			:	u32_array(0 to w/2) := (others => (others => '0'));

begin

	d_int(0) <= unsigned(d_in);
	p_int(0) <= p_pad & unsigned(n_in);

	Stages: for i in 0 to w/2-1 generate
		Stage: Radix4Stage_nbit generic map(w) port map (
			clk		=> clk,
			d_in	=> d_int(i),
			p_in	=> p_int(i),
			q_in	=> q_int(i),
			d_out	=> d_int(i+1),
			q_out	=> q_int(i+1),
			p_out	=> p_int(i+1)
		);		
	end generate;
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (p_int(w/2)(2*w-1 downto w) >= d_int(w/2)(w-1 downto 0)) then
				q_out <= std_logic_vector(q_int(w/2) + 1);
				r_out <= std_logic_vector(p_int(w/2)(2*w-1 downto w) - d_int(w/2)(w-1 downto 0));
			else
				q_out <= std_logic_vector(q_int(w/2));
				r_out <= std_logic_vector(p_int(w/2)(2*w-1 downto w));
			end if;
		end if;
	end process;

end Behavioral;