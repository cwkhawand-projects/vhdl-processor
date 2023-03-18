vlib work

vcom -2008 ../../src/mux2v1.vhd
vcom -2008 mux2v1_tb.vhd

vsim mux2v1_tb(Bench)

view signals
add wave *

run -all