" Ressources : https://www.reddit.com/r/vim/comments/b1833u/highlight_if_date_is_past/
" Author : Michael Schoenwaelder <m.schoenwaelder@posteo.de>

if exists("b:current_syntax")
	finish
endif

" Group keyword
syntax keyword groupKeyword Group
highlight link groupKeyword Keyword

" Todo keyword
syntax keyword todoKeyword Todo
highlight link todoKeyword Keyword

" Recurring keyword
syntax keyword recKeyword Recurring
highlight link recKeyword Keyword

" Todo brackets
syntax match todoItem "\[ \]"
highlight todoItem ctermfg=blue guifg=blue

" dates: wrong format
syntax match wrongDate "\d\d\d\d-\d-\d\d"
syntax match wrongDate "\d\d\d\d-\d-\d"
syntax match wrongDate "\d\d\d\d-\d\d-\d"
highlight wrongDate ctermbg=red guibg=red ctermfg=black guifg=black

" dates: correct format
syntax match rightDate "\d\d\d\d-\d\d-\d\d"
highlight rightDate ctermfg=green guifg=green

" add pattern
syntax match repeatPattern "[+|.]*+\d*[d|w|m|y]"
highlight repeatPattern ctermfg=blue guifg=red

" everything >= today gets a red color
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
	let past_year = '<\(2018\|2019\|2020\|2021\)-\d\d-\d\d,'

	let past_month = '<' . y . '-\(' . join(months[:m-1], '\|') . '\)-\d\d,'
	let past_day = '<' . y . '-' . m . '-\(' . join(days[:d-1], '\|') . '\),'

	if m != "01"
		let pattern = past_year . '\|' . past_month . '\|' . past_day
	else
		let pattern = past_year . '\|' . past_day
	endif

	execute 'syntax match DiaryDate "' . pattern . '"'
endfunction

highlight DiaryDate ctermfg=red guifg=red
call HighlightPastDates()

autocmd ColorScheme,BufRead,BufNewFile * call HighlightPastDates()

let b:current_syntax = "tasks"
