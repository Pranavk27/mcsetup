function font_install()
{
				rm -rf $HOME/fonts/*
				git clone https://github.com/powerline/fonts.git $HOME/fonts
				cd $HOME/fonts
				./install.sh
				rm -rf $HOME/fonts/*
				git clone https://github.com/belluzj/fantasque-sans.git $HOME/fonts
				cd $HOME/fonts
				make ||	make ||	make ||	make ||	make
				cp *.ttf $HOME/.local/share/fonts
				rm -rf $HOME/fonts
}

function tpowerline_install()
{
				cd $HOME/.vim/bundle/tmux-powerline
				./generate_rc.sh
				mv $HOME/.tmux-powerlinerc.default $HOME/.tmux-powerlinerc
}

function omz_zsh_install()
{
				cd $HOME
				sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function clang_install()
{
#				cd $HOME
#				svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
#				cd llvm/tools
#				svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
#				cd ../..
#				cd llvm/tools/clang/tools
#				svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
#				cd ../../../..
#				cd llvm/projects
#				svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
#				cd ../..
#				cd llvm/projects
#				svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx
#				cd ../..
#				mkdir build
#				cd build
#				cmake -G "Unix Makefiles" ../llvm
#				make
			  packages_install llvm clang	
}

function ycmd_install()
{
				clang_install
				cd $HOME/.vim/bundle/YouCompleteMe
				git submodule update --init --recursive
				./install.py --all
				rm -rf $HOME/ycm_build
				mkdir $HOME/ycm_build
				cd $HOME/ycm_build
				cmake -G 'Unix Makefiles' -DPATH_TO_LLVM_ROOT=$HOME/llvm $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
				cmake --build . --target ycm_core --config Release
}

function setup_vimrc()
{
				echo ">> Setting up VImrc <<"
				#First line vimrc
				sed -i "1i source $CONFIGPATH/installplgrc" $VIMRC

				#Last line vimrc
				sed -i "\$asource $CONFIGPATH/setupplgrc" $VIMRC
				sed -i 's#XMYPLUGINX#Plugin \x27file:///$CONFIGPATH/devplugin\x27#g' config/installplgrc
}

function setup_plugins()
{
				git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
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
