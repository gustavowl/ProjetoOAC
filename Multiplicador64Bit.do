vlib work
vmap work

vcom Multiplicador64Bit.vhd
vcom Multiplicador64Bit_tb.vhd

vsim mult64_tb

add wave /mult64_tb/sclk
add wave /mult64_tb/sstart
add wave /mult64_tb/mtplcnd
add wave /mult64_tb/mtplcdr
add wave /mult64_tb/res
add wave /mult64_tb/sdone

force -freeze sim:/mult64_tb/sclk 1 0, 0 {25 ps} -r 50
force -freeze sim:/mult64_tb/sstart 0 0
force -freeze sim:/mult64_tb/mtplcnd 0000000000000000000000000000000000000000000000000000000000001000 0
force -freeze sim:/mult64_tb/mtplcdr 00000000000000000000000101010101 0

force -freeze sim:/mult64_tb/sstart 1 100
force -freeze sim:/mult64_tb/sstart 0 200

view wave
run 1 ns
