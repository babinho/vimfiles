"Fabio Kung <fabio.kung@gmail.com>
"
"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

set backupdir=~/tmp,/tmp,/var/tmp,.,./.backup
set directory=~/tmp,/tmp,/var/tmp,.,./.backup

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set number      "add line numbers

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set showbreak=...
set nowrap linebreak

"mapping for command key to map navigation thru display lines instead
"of just numbered lines
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^

"disable visual bell
set visualbell t_vb=

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk
set fo=l

set encoding=utf-8

set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

set smartcase
set smarttab

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load pathogen managed plugins
call pathogen#infect()

"load ftplugins and indent files
filetype plugin indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

set textwidth=80

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

let mapleader=","

if has("gui_running")
    set t_Co=256
    set guitablabel=%M%t
    "colorscheme xoria256
    colorscheme molokai
    "colorscheme mac_classic

    if has("gui_gnome")
        set guifont=Source\ Code\ Pro\ 11
    endif
    if has("gui_mac") || has("gui_macvim")
        set lines=50
        set columns=105
        set guifont=Monaco:h14
        "set guifont=Menlo:h14
        " make Mac's Option key behave as the Meta key
        set invmmta
        " comma as the leader key
        set guioptions-=r
    endif
    if has("gui_win32") || has("gui_win32s")
        set guifont=Consolas:h12
        set enc=utf-8
    endif
else
    "dont load csapprox if there is no gui support - silences an annoying warning
    let g:CSApprox_loaded = 1
    if has("gui")
        set t_Co=256
        set guitablabel=%M%t
        colorscheme molokai
    endif
endif

"Powerline
call Pl#Theme#InsertSegment('charcode', 'after', 'filetype')
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')
let g:Powerline_symbols = 'fancy'

nmap <silent> <Leader>p :NERDTreeToggle<CR>
nmap <silent> <Leader>t :TlistToggle<CR>

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map to bufexplorer
nnoremap <leader>f :BufExplorer<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"quicksilver in fuzzy mode by default
let g:QSMatchFn = "fuzzy"

"bindings for ragtag
inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1

"mark syntax errors with :signs
let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes = ['cpp']

"key mapping for vimgrep result navigation
map <A-o> :copen<CR>
map <A-q> :cclose<CR>
map <A-j> :cnext<CR>
map <A-k> :cprevious<CR>

"snipmate setup
try
  source ~/.vim/snippets/support_functions.vim
catch
  source $HOMEPATH\vimfiles\snippets\support_functions.vim
endtry
autocmd vimenter * call s:SetupSnippets()
function! s:SetupSnippets()

    "if we're in a rails env then read in the rails snippets
    if filereadable("./config/environment.rb")
        call ExtractSnips("~/.vim/snippets/ruby-rails", "ruby")
        call ExtractSnips("~/.vim/snippets/eruby-rails", "eruby")
    endif

    call ExtractSnips("~/.vim/snippets/html", "eruby")
    call ExtractSnips("~/.vim/snippets/html", "xhtml")
    call ExtractSnips("~/.vim/snippets/html", "php")
endfunction

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"if exists('+colorcolumn')
"    set colorcolumn=+1
"else
"    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
"endif

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

"spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

"snipmate settings
let g:snips_author = "Berislav Babic"

" minitest
set completefunc=syntaxcomplete#Complete

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1


" ctags settings
set tags+=./tags
set foldlevel=1

nmap <leader><F12> :!ctags -R --exclude=.git --exclude=logs --exclude=doc .<CR>
" fucking Cro keyboard
nmap <C-q> <C-]>
" source self if needed
nmap <leader>s :so $MYVIMRC<CR>

" read ruby tags
au BufRead,BufNewFile *.rb setlocal tags+=~/.vim/tags/ruby_and_gems

" execute ruby on F5, nice for scripts
au BufRead,BufNew *.rb map <F5> :!ruby % <CR>

" Make XML pretty
au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
nmap <leader>xml :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>

" ruby hashrocket replace
nmap rs :%s/:\([^ ]*\)\(\s*\)=>/\1:/g <CR>

"key mapping for window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"key mapping for tab navigation
nmap <S-Tab> gt
nmap <C-S-Tab> gT

"Enabling Zencoding
let g:user_zen_settings = {
      \  'php' : {
      \    'extends' : 'html',
      \    'filters' : 'c',
      \  },
      \  'xml' : {
      \    'extends' : 'html',
      \  },
      \  'haml' : {
      \    'extends' : 'html',
      \  },
      \  'erb' : {
      \    'extends' : 'html',
      \  },
      \}

" when press { + Enter, the {} block will expand.
imap {<CR> {}<ESC>i<CR><ESC>O}
