function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

function! SendLines(pane)
    let lines = GetVisualSelection()
    for i in range(0, len(lines)-1)
	let lines[i] = substitute(lines[i], '\;', '\\;', "g")
	let cmd = 'tmux send-keys -t ' . shellescape(a:pane) . ' ' 	
	let cmd .= shellescape(lines[i]) . ' enter'
	call system(cmd)
    endfor	
endfunction
