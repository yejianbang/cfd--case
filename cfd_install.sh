#!/bin/bash

CFDPP_LICENSE=/home/yjb/Metacomp.lic.ok # 可用的license文件
CFDPP_DIR=/home/yjb/CFD++14.1_Linux64 # 解压后的应用目录
CFDPP_RUN_DIR=/home/yjb/cfdpp  # 算例目录

install()
{
	cd ${CFDPP_DIR}
	rm -rf METACOMP
	mkdir METACOMP
	cd METACOMP

	cp ../readme .
	cp ../mcfdall.tar .
	cp ../msetup.bash .
	cp ../msetenv.bash .
	cp ../msetsgi.bash .

	sh ./msetup.bash | tee msetup.log
	sh ./msetenv.bash
        mv ./mcfdenv.sh.template ./mcfdenv.sh
        echo  -e "export MPI_ROOT=\$METACOMP_HOME/hpmpi \nexport PATH=\$PATH:\$MPI_ROOT/bin \nexport MANPATH=\$MANPATH:\$MPI_ROOT/share/man \nexport MPI_REMSH=ssh \nexport EXEC=\$METACOMP_HOME/mlib/mcfd.14.1/exec \nexport MPI_DIR=\$MPI_ROOT/bin " >> ./mcfdenv.sh
        source ./mcfdenv.sh
	cd ${CFDPP_DIR}/METACOMP/mlib/mcfd.14.1
	./check.execs-list

	cd ${CFDPP_DIR}/METACOMP/mbin/
	rm -rf Metacomp.lic
	cp ${CFDPP_LICENSE} Metacomp.lic
	sed -i "s/hostname/`hostname`/g" Metacomp.lic
	sed -i "s/hostid/`hostid`/g" Metacomp.lic
	./lmgrd -c Metacomp.lic -l lmgrd.log 
}
install
