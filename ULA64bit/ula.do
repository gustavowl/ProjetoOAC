vlib work
vmap work

vcom ula.vhd
vcom ula_tb.vhd

vsim ula_tb

add wave /ula_tb/mclk
add wave /ula_tb/mdo_op
add wave /ula_tb/mx
add wave /ula_tb/my
add wave /ula_tb/mz
add wave /ula_tb/ma
add wave /ula_tb/mb
add wave /ula_tb/ms
add wave /ula_tb/mcout
add wave /ula_tb/mdone
add wave /ula_tb/mst

force -freeze sim:/ula_tb/mclk 1 0, 0 {5000 ps} -r 10000
force -freeze sim:/ula_tb/mdo_op 0 0
force -freeze sim:/ula_tb/mdo_op 1 20000

view wave
run 400 ns
