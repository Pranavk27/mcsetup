#!/bin/bash
# mksetup.sh

set_env_variables(){

	echo "Enter Netvault Installation Directory:"
	read NVHOME
	echo "Enter URL for SVN checkout:"
	read SVNURL
	echo "Enter 64BIT for 64-bit setup else leave blank:"
	read NV_TYPE
	echo "Enter Port number for PostgreSQL [51486]:"
	read PGDBPORT
	echo "Enter PostgreSQL password [binars]:"
	read PGDBPASS
	echo "Enter Repository [karak7]:"
	read NVREPO
	echo "Enter Branch [trunk]:"
	read NVBRANCH

	BLDDIR="$HOME/nvbuild/$NVREPO/$NVBRANCH"
	
	echo \
	"
	MY_PROXY_URL=10.55.2.67:8080
	HTTP_PROXY=$MY_PROXY_URL
	HTTPS_PROXY=$MY_PROXY_URL
	FTP_PROXY=$MY_PROXY_URL
	http_proxy=$MY_PROXY_URL
	https_proxy=$MY_PROXY_URL
	ftp_proxy=$MY_PROXY_URL
	export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy " >> ~/.bashrc
	echo \
	"export no_proxy=\"localhost,127.0.0.1,*.dsgdev.lab,*.prod.quest.corp,*.poolelab.emea,wiki.quest.com,*.corp.bb,*.bakbone.com\"" \
	>> ~/.bashrc
	echo "export JMAKE_WIDTH=1" >> ~/.bashrc
	echo "export NV_BUILD_TYPE=$NV_TYPE" >> ~/.bashrc
	echo "export NV_BUILD_DIR=\"$BLDDIR/build\"" >> ~/.bashrc
	echo "export NV_CONTRIB_PATH=\"$BLDDIR/source/contrib\"" >> ~/.bashrc
	echo "export NVPGDBPORT=PGDBPORT" >> ~/.bashrc
	echo "export NVPGDBPASSWORD=\"$PGDBPASS\"" >> ~/.bashrc
	echo "export NVPGDBINSTALLDIR=$NVHOME/pgsql" >> ~/.bashrc
	echo "export NVPGDBDATADIR=$NVHOME/db/pgsql" >> ~/.bashrc
	echo "export NVALLOWASCLIENT=TRUE" >> ~/.bashrc
	echo "export NVAUTOSCAN=NEITHER" >> ~/.bashrc
	echo "export NVDISABLESECURITY=TRUE" >> ~/.bashrc
	echo "export NVDOCRASH=TRUE" >> ~/.bashrc
	echo "export NVMACHINENAME='hostname'" >> ~/.bashrc
	echo "export NVTRACETOFILE=TRUE" >> ~/.bashrc
	echo "export NV_BUILD_CLIENT_ONLY=FALSE" >> ~/.bashrc
	echo "export NV_BRANCH=$NVBRANCH" >> ~/.bashrc
	echo "export BLDDIR=$BLDDIR" >> ~/.bashrc
	
	source $HOME/.bashrc

}

svn_chkout_source(){


	echo "Enter URL for SVN checkout:"
	read SVNURL
	echo "Enter Repository [karak7]:"
	read NVREPO
	echo "Enter Branch [trunk]:"
	read NVBRANCH
	echo "Enter Source Location:"
	read -d ';' SVNDIR

	if [ "$OPTIONS" = "setup" ];
	then
		BLDDIR="$HOME/nvbuild/$NVREPO/$NVBRANCH"
		mkdir -p $BLDDIR

		while read DIR ;do
			svn co "$SVNURL/$DIR/$NVBRANCH"  "$BLDDIR/source/$DIR"
		done < $HOME/scripts/svnco
		sed -i '/GEN_COMPILE_CMDS_DEFAULT/aGEN_COMPILE_CMDS=FALSE' $BLDDIR/source/base/configure
		sed -i 's/\/usr\/nv\//$NVHOME\//g'  $BLDDIR/source/base/buildutils/examples/nv-db-install.sh
		svn co $SVNURL/emacs $HOME/k6/emacs --username $USER --password $PASS
		cp $HOME/k6/emacs/dotemacsstub $HOME/.emacs
	else
		BLDDIR="$HOME/nvbuild/$NVREPO/$NVBRANCH"
		mkdir -p $BLDDIR

		for ISVNDIR in $SVNDIR
		do
			svn co "$SVNURL/$ISVNDIR/$NVBRANCH"  "$BLDDIR/source/$ISVNDIR"
		done
	fi

}


install_packages(){

	while read p ;do
		yum install -y $p
	done < $HOME/scripts/install_pkgs
	make_rtags

}

inital_setup(){

	iptables -F
	iptables -X
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD ACCEPT
	sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

}

make_rtags(){

	tar xvJfp $HOME/scripts/emacs-24.5.tar.xz
	cd emacs-24.5/
	./configure 
	make
	sudo make install
	rm -rf emacs-24.5/

	tar xvf $HOME/scripts/clang+llvm-3.8.0-linux-x86_64-centos6.tar.xz
	mv $HOME/scripts/clang+llvm-3.8.0-linux-x86_64-centos6/ $HOME/scripts	

	export CLANG_CXXFLAGS=`$HOME/scripts/clang+llvm-3.8.0-linux-x86_64-centos6/bin/llvm-config --cxxflags`
	export CLANG_LIBS='-L$HOME/scripts/clang+llvm-3.8.0-linux-x86_64-centos6/lib/ -lclang'
	PATH=$PATH:$HOME/scripts/clang+llvm-3.8.0-linux-x86_64-centos6/bin/
	
	mkdir $HOME/porting
	cd $HOME/porting
	unzip $HOME/scripts/rtags.zip
	mkdir build
	cd build
	cmake ..
	make -j4
	sudo make install
	cd $HOME
	rm -rf $HOME/porting

}

compile_base(){
	
	echo "Enter Repository [karak7]:"
	read NVREPO
	echo "Enter Branch [trunk]:"
	read NVBRANCH

	BLDDIR="$HOME/nvbuild/$NVREPO/$NVBRANCH"
	mkdir -p $BLDDIR/build/base
	NV_BUILD_DIR="$BLDDIR/build/"
	cd $BLDDIR/source/base

	#svn up
	./configure
	
	cd $BLDDIR/build/base
	make

}

plugin_compile(){
	
	echo "Enter Repository [karak7]:"
	read NVREPO
	echo "Enter Branch [trunk]:"
	read NVBRANCH
	echo "Enter Plugin [trunk]:"
	read NVPLUGIN

	BLDDIR="$HOME/nvbuild/$NVREPO/$NVBRANCH"
	NV_BUILD_DIR="$BLDDIR/build/"
	cd $BLDDIR/source/$NVPLUGIN

	#svn up
	../base/buildutils/configuremod
	
	mkdir -p $BLDDIR/build/$NVPLUGIN
	cd $BLDDIR/build/$NVPLUGIN
	make

}

install_netvault(){

	echo "Enter Netvault Installation Directory:"
	read NVHOME
	echo "Enter 64BIT for 64-bit setup else leave blank:"
	read NV_TYPE
	compile_base
	rm -rf $NVHOME/*
	make install
	rm -rf $NVHOME/pgsql
	rm -rf $NVHOME/db/pgsql
	$BLDDIR/source/base/buildutils/examples/nv-db-install.sh

}
 
OPTIONS="${1}"
case "${OPTIONS}" in
	"setup")
		set_env_variables
		inital_setup
		install_packages
		svn_chkout_source
		compile_base
		;;
	"checkout")
		svn_chkout_source
		;;
	"compile") 
		compile_base
		;;
	"install")
		install_netvault
		;;
	"plgcompile")
		plugin_compile
		;;
esac
