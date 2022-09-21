SHELL := /bin/bash

PWD = $(shell pwd)

INCDIR_PREFIX =-incdir
LIB_FLAG = -v


ifndef AQ_BMC_DESIGN_TRAFFICLIGHTS_DIR
  AQ_BMC_DESIGN_TRAFFICLIGHTS_DIR:=$(abspath $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
endif
include $(AQ_BMC_DESIGN_TRAFFICLIGHTS_DIR)/config.mk
include $(AQ_BMC_DESIGN_TRAFFICLIGHTS_DIR)/simfiles.mk
 
clean:
	rm -rf $(PWD)/xcelium.d
	rm -rf $(PWD)/.simvision
	rm -rf $(PWD)/waves.shm
	rm xrun.history
	rm xrun.key
	rm xrun.log
  
 
run_pem_trafficlights_tests: list
	xrun \
	-64bit \
	-v93 \
	-sv \
	-timescale 1ns/10ps -notimingchecks \
	-access +rwc \
	-disable_sem2009 \
	-gui \
	-defineall AES128 \
	-f rtl.lst	\
	$(TESTBENCH_FILES)


.PHONY: list
list:
	@echo " -= Create RTL-list =- "
	@rm -f rtl.lst
	@for var in $(RTL_DEF); do echo +define+$$var >> rtl.lst; done
	@for var in $(RTL_INC); do echo +incdir+$$var >> rtl.lst; done
	@for var in $(RTL_SRC); do echo $$var >> rtl.lst; done 

jg_apb_proof: list
	@echo " -= Start JasperGold APB Proof =- "
	srun --x11 -c 4 jg ./formal/jg/jg_apb.tcl

jg_superlint: list
	@echo " -= Start JasperGold Superlint =- "
	srun --x11 -c 48 jg -superlint ./formal/jg/jg_superlint.tcl
