" Ressources : https://www.reddit.com/r/vim/comments/b1833u/highlight_if_date_is_past/
" Author : Michael Schoenwaelder <m.schoenwaelder@posteo.de>

if exists("b:current_syntax")
	finish
endif

syntax keyword tasksKeyword Bereich
highlight link tasksKeyword Function

syntax match myMichael "michael"
highlight myMichael ctermfg=green ctermbg=white guibg=green

syntax match taskDate "<\d\d\d\d-\d\d-\d\d,"
syntax match taskDate ">"
highlight taskDate ctermfg=green guifg=green

function! HighlightPastDates()
	let days = [
		\ '01', '02', '03', '04', '05', '06', '07',
		\ '08', '09', '10', '11', '12', '13', '14',
		\ '15', '16', '17', '18', '19', '20', '21',
		\ '22', '23', '24', '25', '26', '27', '28',
		\ '29', '30', '31',
	\ ]
	let months = [
		\ '01', '02', '03', '04', '05', '06',
		\ '07', '08', '09', '10', '11', '12',
	\ ]

	let y = strftime('%Y')
	let m = strftime('%m')
	let d = strftime('%d')

	let lasty = y - 1
	let past_year = '<\(2018\|2019\|2020\)-\d\d-\d\d,'

	let past_month = '<' . y . '-\(' . join(months[:m -2], '\|') . '\)-\d\d,'
	let past_day = '<' . y . '-' . m . '-\(' . join(days[:d -1], '\|') . '\),'

	let pattern = past_year . '\|' . past_month . '\|' . past_day

	execute 'syntax match DiaryDate "' . pattern . '"'
endfunction

"highlight DiaryDate ctermbg=red guibg=red
highlight DiaryDate ctermfg=red guifg=red
call HighlightPastDates()

autocmd ColorScheme,BufRead,BufNewFile * call HighlightPastDates()

let b:current_syntax = "tasks"
