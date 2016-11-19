VIM=vim
PLGINSTALLOPTS=" +PluginInstall +qall"
VIMRC=/etc/vimrc
PLUGINLIST="tpowerline ycmd font"
CONFIGPATH="$HOME/myscripts/config"


function font_install()
{
				git clone https://github.com/powerline/fonts.git $HOME/fonts
				cd $HOME/fonts
				./install.sh
				git clone https://github.com/belluzj/fantasque-sans.git $HOME/fonts
				cd $HOME/fonts
				make &&	make &&	make &&	make &&	make
}

function tpowerline_install()
{
				cd $HOME/.vim/bundle/tmux-powerline
				./generate_rc.sh
				mv $HOME/.tmux-powerlinerc.default $HOME/.tmux-powerlinerc
				cd -
}

function clang_install()
{
				cd $HOME
				svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
				cd llvm/tools
				svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
				cd ../..
				cd llvm/tools/clang/tools
				svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
				cd ../../../..
				cd llvm/projects
				svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
				cd ../..
				cd llvm/projects
				svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx
				cd ../..
				mkdir build
				cd build
				cmake -G "Unix Makefiles" ../llvm
				make
}

function ycmd_install()
{
				clang_install
				cd $HOME/.vim/bundle/YouCompleteMe
				git submodule update --init --recursive
				./install.py --all
				cd $HOME
				mkdir ycm_build
				cd ycm_build
				cmake -G 'Unix Makefiles' -DPATH_TO_LLVM_ROOT=$HOME/llvm $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
				cmake --build . --target ycm_core --config Release
}

function install_vim()
{
				echo ">> Check VIm is present <<"
				if ! vim_present;
				then
								echo ">> VIm not present >> Installing <<"
								yum -y install $VIM;
				fi
				echo ">> VIm now present <<"
}

function vim_present()
{
				[ -x `which vim` ]
}

function setup_vimrc()
{
				echo ">> Setting up VImrc <<"
				#First line vimrc
				sed -i "1i source \"$CONFIGPATH/installplgrc\"" $VIMRC

				#Last line vimrc
				sed -i "\$asource \"$CONFIGPATH/setupplgrc\"" $VIMRC
				sed -i 's#XMYPLUGINX#Plugin \x27file:///$CONFIGPATH/devplugin\x27#g' config/installplgrc
}

function setup_plugins()
{
				$VIM $PLGINSTALLOPTS
}

function for_each_plugin()
{
				for PLUGIN in $PLUGINLIST;
				do
								echo ">> Installing plugin $PLUGIN <<"
								"$PLUGIN"_install
				done
}

install_vim
setup_vimrc
mkdir -p $HOME/.vim
setup_plugins
for_each_plugin
