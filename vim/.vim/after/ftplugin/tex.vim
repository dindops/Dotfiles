" Latex mappings {{{
noremap <Space><Space> /<??><Enter>"_c4l
inoremap ;b \textbf{}<Space><??><Esc>T{i
inoremap ;i \textit{}<Space><??><Esc>T{i
inoremap ;un \underline{<??>}<Space><??><Esc>T{i
inoremap ;ct \textcite{}<Space><??><Esc>T{i
inoremap ;ref \ref{}<Space><??><Esc>T{i
inoremap ;ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><??><Esc>3kA<Space><Space>\item<Space>
inoremap ;ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><??><Esc>3kA<Space><Space>\item<Space>
inoremap ;it <Space><Space>\item<Space>
inoremap ;wf \begin{wrapfigure}{l}{8cm}<Enter>\begin{center}<Enter>\includegraphics[width=\linewidth,keepaspectratio]{<??>}<Enter>\caption{<??>}<Enter>\label{<??>}<Enter>\end{center}<Enter>\end{wrapfigure}<Enter>
inoremap ;fi \begin{figure}[h!]<Enter>\begin{center}<Enter>\includegraphics[width=\linewidth,keepaspectratio]{<??>}<Enter>\caption{<??>}<Enter>\label{<??>}<Enter>\end{center}<Enter>\end{figure}<Enter>
inoremap ;sec \section{}<Enter><Enter><??><Esc>2kf}i
inoremap ;fr %FRAME<Enter>\begin{frame}<Enter>\frametitle{<??>}<Enter><??><Enter><Enter><Enter>\end{frame}<Enter><Enter><Esc>9kA
inoremap ;eq $$<Esc>i
inoremap ;rar $\rightarrow$<Space>
inoremap ;Rar $\Rightarrow$<Space>
inoremap ;lar $\leftarrow$<Space>
inoremap ;Lar $\Leftarrow$<Space>
" }}}

