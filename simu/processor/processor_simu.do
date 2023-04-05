vlib work

vcom -2008 ../../src/alu.vhd
vcom -2008 ../../src/instruction_memory.vhd
vcom -2008 ../../src/memory.vhd
vcom -2008 ../../src/psr.vhd
vcom -2008 ../../src/reg_en.vhd
vcom -2008 ../../src/registers.vhd
vcom -2008 ../../src/instruction_unit.vhd
vcom -2008 ../../src/instruction_decoder.vhd
vcom -2008 ../../src/processing_unit.vhd
vcom -2008 ../../src/processor.vhd
vcom -2008 processor_tb.vhd

vsim processor_tb(Bench)

view signals
add wave *
add wave processor/instruction_decoder/*
for {set i 0} {$i < 3} {incr i} {
    add wave -radix hexadecimal /processor_tb/processor/processing_unit/registers/Registers($i)
}

for {set i 32} {$i < 43} {incr i} {
    add wave -radix hexadecimal /processor_tb/processor/processing_unit/memory/Memory($i)
}

run -all
