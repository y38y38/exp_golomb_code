verilator --cc --exe  --trace-fst --trace-params --trace-structs --trace-underscore \
    exp_golomb_code.v -exe test_exp_golomb_code.cpp
make -C obj_dir -f Vexp_golomb_code.mk

