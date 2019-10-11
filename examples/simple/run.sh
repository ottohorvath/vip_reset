#!/usr/bin/env bash

set -euo pipefail

sim_mode=-gui
sim=mti

__sn=`basename $0`
__pwd=`readlink -f $0 | sed s"|/${__sn}||"`

pushd ${__pwd} > /dev/null
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

VIP_RESET_SV_HOME=${__pwd}/../../sv
export VIP_RESET_SV_HOME

sim_path=${__pwd}/simulation
log_path=${sim_path}/run_log_${sim}
work_path=${sim_path}/work_${sim}
elab_path=${work_path}/elab_${sim}

tb_vc=${__pwd}/simple.vc
tb_top=simple_tb_top
tc=simple_test

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

[[ -e ${sim_path} ]] && rm -rf ${sim_path}

mkdir -p ${sim_path} && cd ${sim_path}

{
    compile_mti
    elaborate_mti
    simulate_mti
} 2>&1 | tee ${log_path}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

popd > /dev/null
