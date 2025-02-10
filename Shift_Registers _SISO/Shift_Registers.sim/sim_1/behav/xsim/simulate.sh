#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sat Feb 08 11:41:26 PKT 2025
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_serialin_serialout_behav -key {Behavioral:sim_1:Functional:tb_serialin_serialout} -tclbatch tb_serialin_serialout.tcl -log simulate.log"
xsim tb_serialin_serialout_behav -key {Behavioral:sim_1:Functional:tb_serialin_serialout} -tclbatch tb_serialin_serialout.tcl -log simulate.log

