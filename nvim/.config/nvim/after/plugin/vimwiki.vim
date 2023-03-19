let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_markdown_link_ext = 1  " changes vimwiki links from [text](text) to  [text](text.md)
nnoremap <Space><Space> :VimwikiToggleListItem<CR>
noremap <Space>r :VimwikiToggleRejectedListItem<CR>
