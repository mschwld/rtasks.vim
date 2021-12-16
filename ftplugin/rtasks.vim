function! ReplaceDate()
	let currentLine = getline(".")

	let currentDate = matchstr(currentLine, '\d\d\d\d-\d\d-\d\d')
	let currentYear = split(currentDate, "-")[0]
	let currentMonth = split(currentDate, "-")[1]
	let currentDay = split(currentDate, "-")[2]

	let actualYear = strftime('%Y')
	let actualMonth = strftime('%m')
	let actualDay = strftime('%d')

	let addPart = matchstr(currentLine, '\(++\|.+\)\d\(d\|m\|y\)')

	let adder = addPart[2:-2]

	if(addPart[0] == '.')
		let currentYear = actualYear
		let currentMonth = actualMonth
		let currentDay = actualDay
	endif

	let modifier = addPart[-1:]

	let newYear = currentYear
	let newMonth = currentMonth
	let newDay = currentDay

	" calculate new date
	if modifier == 'd'
		let i = adder
		while i > 0
			let newDay = newDay + 1

			" month transition from FEB
			if newDay == 29 && newMonth == 2 && (newYear % 4 != 0)
				let newMonth = 3
				let newDay = 1
			endif
			if newDay == 30 && newMonth == 2 && (newYear % 4 == 0)
				let newMonth = 3
				let newDay = 1
			endif
			
			" month transition from APR, JUN, SEP, NOV
			if newDay == 32
				if newMonth == 4 || newMonth == 6 || newMonth == 9 || newMonth == 11
					let newMonth = newMonth + 1
					let newDay = 1
				endif
			endif

			" month transition from JAN, MAR, MAY, JUL, AUG, OCT
			if newDay == 32
				if newMonth == 1 || newMonth == 3 || newMonth == 5 || newMonth == 7 || newMonth == 8 || newMonth == 10
					let newMonth = newMonth + 1
					let newDay = 1
				endif
			endif
		
			" year transition from DEC
			if newMonth == 12 && newDay == 32
				let newMonth = 1
				let newDay = 1
				let newYear = newYear + 1
			endif
			let i = i - 1
		endwhile
	elseif modifier == 'm'
		let i = adder
		while i > 0
			let newMonth = newMonth + 1
			let i = i - 1 

			" year transition
			if newMonth == 13:
				let newMonth = 1
				let newYear = newYear + 1
			endif
		endwhile

		" fix impossible dates
		if newMonth == 02:
			if newDay == 29:
				if newYear % 4 != 0
					let newDay = 1
					let newMonth = newMonth + 1
				endif
			endif
		endif
	elseif modifier == 'y'
		newYear = newYear + adder
	endif

	" write new line
	if newDay < 10 && len(newDay) == 1
		let newDay = '0' . newDay 
	endif
	if newMonth < 10 && len(newMonth) == 1
		let newMonth = '0' . newMonth
	endif
	let newfulldate = newYear . '-' . newMonth . '-' . newDay
	call setline(line('.'), substitute(getline('.'), '\d\d\d\d-\d\d-\d\d', newfulldate, ''))

	" log action
	let actualFullDate = strftime('%Y-%m-%d %H:%M')
	let writeLine = "Marked DONE on " . actualFullDate . ": " . currentLine
	call writefile(split(writeLine, "\n", 1), ".taskhistory", "a")
endfunction

nnoremap <Leader>tt :call ReplaceDate()<cr>
