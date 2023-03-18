vlib work

vcom -2008 ../src/processing_unit.vhd
vcom -2008 processing_unit_tb.vhd

vsim processing_unit_tb(Bench)

view signals
add wave *

run -all