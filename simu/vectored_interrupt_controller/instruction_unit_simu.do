vlib work

vcom -2008 ../../src/mux2v1.vhd
vcom -2008 ../../src/reg.vhd
vcom -2008 ../../src/instruction_memory_irq.vhd
vcom -2008 ../../src/sign_extender.vhd
vcom -2008 ../../src/instruction_unit.vhd
vcom -2008 instruction_unit_tb.vhd

vsim instruction_unit_tb(Bench)

view signals
add wave *
radix signal Instruction hexadecimal
radix signal VICPC hexadecimal
radix signal Offset unsigned

run -all

wave zoom full