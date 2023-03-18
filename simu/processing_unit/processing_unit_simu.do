vlib work

vcom -2008 ../../src/registers.vhd
vcom -2008 ../../src/sign_extender.vhd
vcom -2008 ../../src/mux2v1.vhd
vcom -2008 ../../src/alu.vhd
vcom -2008 ../../src/memory.vhd
vcom -2008 ../../src/processing_unit.vhd
vcom -2008 processing_unit_tb.vhd

vsim processing_unit_tb(Bench)

view signals
add wave *

run -all