library verilog;
use verilog.vl_types.all;
entity full_FIR is
    port(
        DIN             : in     vl_logic_vector(7 downto 0);
        b0              : in     vl_logic_vector(7 downto 0);
        b1              : in     vl_logic_vector(7 downto 0);
        b2              : in     vl_logic_vector(7 downto 0);
        b3              : in     vl_logic_vector(7 downto 0);
        b4              : in     vl_logic_vector(7 downto 0);
        b5              : in     vl_logic_vector(7 downto 0);
        b6              : in     vl_logic_vector(7 downto 0);
        b7              : in     vl_logic_vector(7 downto 0);
        b8              : in     vl_logic_vector(7 downto 0);
        DOUT            : out    vl_logic_vector(7 downto 0);
        CLK             : in     vl_logic;
        RST_n           : in     vl_logic;
        VIN             : in     vl_logic;
        VOUT            : out    vl_logic
    );
end full_FIR;
