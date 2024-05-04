current_design des3

set clk_name clk
set clk_port_name clk
set clk_period 0.72

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay 0.1 -clock $clk_name $non_clock_inputs
set_output_delay 0.1 -clock $clk_name [all_outputs]

# set_clock_uncertainty 0.072 [get_clock $clk_name]
