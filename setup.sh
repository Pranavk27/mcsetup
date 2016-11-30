VIM=vim
PLGINSTALLOPTS=" +PluginInstall +qall"
VIMRC=/etc/vimrc
PLUGINLIST="omz_zsh tpowerline ycmd font"
CONFIGPATH="$HOME/myscripts/config"
PACKAGEFILE="$HOME/myscripts/packages"

source $HOME/myscripts/setupvim.sh

function package_present()
{
				[ $? -ne 0 ]
}

function packages_install()
{
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

packages_install `cat $PACKAGEFILE` 
packages_install vim  
setup_vimrc
mkdir $HOME/.vim
setup_plugins
for_each_plugin
