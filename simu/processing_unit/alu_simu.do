vlib work

vcom -2008 ../../src/alu.vhd
vcom -2008 alu_tb.vhd

vsim alu_tb(Bench)

view signals
add wave *

run -all