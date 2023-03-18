vlib work

vcom -2008 ../../src/mux2v1.vhd
vcom -2008 ../../src/reg.vhd
vcom -2008 ../../src/instruction_memory.vhd
vcom -2008 ../../src/instruction_unit.vhd
vcom -2008 instruction_unit_tb.vhd

vsim instruction_unit_tb(Bench)

view signals
add wave *

run -all