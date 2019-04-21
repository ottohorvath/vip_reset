#!/usr/bin/env bash
set -e

sim_mode=-gui
sim=mti
#===============================================================================
VIP_RESET_SV_HOME=${PWD}/../../sv
export VIP_RESET_SV_HOME

log_path=${PWD}/run_log_${sim}
work_path=${PWD}/work_${sim}
elab_path=${work_path}/elab_${sim}
tb_vc=${PWD}/`find -name "*.vc"`
tb_top=`find -name "*tb_top.sv" | sed "s|.sv||" | sed "s|\W*||"`
tc=`find -name "*test.sv" | sed "s|.sv||" | sed "s|\W*||"`

compile_mti ()
{
    vlib ${work_path}
    vlog -64 -incr -sv -work ${work_path} -F ${tb_vc} -timescale 1ns/1ps
    vopt -64 -incr +acc -work ${work_path} ${tb_top} -o ${tb_top}_opt
}
elaborate_mti ()
{
    vsim -64 -batch -classdebug -lib ${work_path} -compress_elab -elab ${elab_path} ${tb_top}_opt
}
simulate_mti ()
{
    vsim -64 ${sim_mode} -load_elab ${elab_path} +UVM_TESTNAME=${tc}
}

#===============================================================================
if [[ -d ${work_path} ]]
then
    rm -rf ${work_path}
fi

# Remove auto generate bullshit
rm -rf {transcript,work,wlf*,vish*}

if [[ "${sim}" == "mti" ]]
then
{
    compile_mti
    elaborate_mti
    simulate_mti
} 2>&1 | tee ${log_path}
else
    echo "Only MTI support is implemented!"
fi

exit 0