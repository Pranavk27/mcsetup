VIM=vim
PLGINSTALLOPTS=" +PluginInstall +qall"
VIMRC=/etc/vimrc
PLUGINLIST="omz_zsh tpowerline ycmd font"
CONFIGPATH="$HOME/myscripts/config"
PACKAGEFILE="$HOME/myscripts/packages"

<<<<<<< HEAD
source $HOME/myscripts/setupvim.sh
=======
source $HOME/myscripts/plgsetup
>>>>>>> 6686fb2deda401ec92da69ebc3d9cac0ed6ae13b

function package_present()
{
				[ $? -ne 0 ]
}

function packages_install()
{
<<<<<<< HEAD
=======
				PACKAGES=$*
>>>>>>> 6686fb2deda401ec92da69ebc3d9cac0ed6ae13b
				for PACKAGE in $PACKAGES;
				do
				echo ">> Check $PACKAGE is present <<"
				which $PACKAGE
				if package_present;
				then
								echo ">> $PACKAGE not present >> Installing <<"
								yum -y install $PACKAGE;
								echo ">> $PACKAGE now present <<"
				fi
				done
}

<<<<<<< HEAD
echo "Installing Packages"
=======
>>>>>>> 6686fb2deda401ec92da69ebc3d9cac0ed6ae13b
packages_install `cat $PACKAGEFILE` 
packages_install vim  
setup_vimrc
mkdir $HOME/.vim
setup_plugins
for_each_plugin
