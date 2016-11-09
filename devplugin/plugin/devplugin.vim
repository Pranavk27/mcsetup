"" First Plugin for setting dev mode for a development purpose 

"" Init {{
"" initial checks
if !exists('s:cpo_save')
    " If the taglist plugin is sourced recursively, the 'cpo' setting will be
    " set to the default value.  To avoid this problem, save the cpo setting
    " only when the plugin is loaded for the first time.
    let s:cpo_save = &cpo
endif
set cpo&vim

if exists('loaded_developer_pane')
				finish
endif
"" }}

"" Globals {{
let loaded_developer_pane=1
let is_nerd_tree_open=1					"Needed first time for NerdTree invokation
let g:is_maximized_pane=0					"Needed to adjust first time and then toggle maximize
"" }}

"" Commands {{
command! -nargs=0 DevPaneToggle call s:DeveloperPaneToggle()
command! -nargs=0 AdjustPane call s:AdjustPane()
command! -nargs=0 MaximizePane call s:MaximizePane()
"" }}

"" Mappings {{
nnoremap <F2> :DevPaneToggle<CR>
nnoremap <F3> :AdjustPane<CR>
nnoremap <F4> :MaximizePane<CR>
"" }}

function! s:MaximizePane()
				if !g:is_maximized_pane
						vertical resize |
						let g:is_maximized_pane = 1
				else
						call s:AdjustPane()
				endif
endfunction

function! s:AdjustPane()
						wincmd b | vertical resize 30
						wincmd t | vertical resize 25
						wincmd w
						let g:is_maximized_pane = 0
endfunction

function! s:DeveloperPaneToggle()
		if exists('is_nerd_tree_open')
			NERDTree % | let is_nerd_tree_open=0		"Called Only once Need better solution
		endif
		NERDTreeToggle 
		TlistToggle
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
