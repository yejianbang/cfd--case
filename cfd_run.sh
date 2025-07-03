#!/bin/bash
CFDPP_DIR=/home/yjb/CFD++14.1_Linux64 # 解压后的应用目录
CFDPP_RUN_DIR=/home/yjb/cfdpp  # 算例目录
NP=46
MEM=240

run()
{
	cd ${CFDPP_RUN_DIR}
	rm -rf ./mcfdenv.sh
	cp ${CFDPP_DIR}/METACOMP/mcfdenv.sh ./mcfdenv.sh	
	source ./mcfdenv.sh
	tometis pmetis ${NP}
	echo "`hostname`" > hosts
	time -p $MPI_DIR/mpirun -e MCFD_MAXMEM=${MEM}G -e MCFD_PROCMEM=${MEM}G -e LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${CFDPP_DIR}/METACOMP/glib -np ${NP} -hostfile hosts ${EXEC}/hpmpimcfd |tee -a 2>&1 ${NP}.log
}

run
