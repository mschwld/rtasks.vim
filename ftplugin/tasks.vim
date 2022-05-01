" receive date, add days, return list
function! Add_Days(day, month, year, days)
	let i = a:days
	let day = a:day
	let month = a:month
	let year = a:year

	while i > 0
		let day = day + 1
		let i = i - 1

		" month transition from februaray, paying attention to leapyears
		if day == 29 && month == 2 && (year % 4 != 0)
			let month = 3
			let day = 1
		endif
		if day == 30 && month == 2 && (year % 4 == 0)
			let month = 3
			let day = 1
		endif

		" month transition from april, june, september or november
		if day == 31
			if month == 4 || month == 6 || month == 9 || month == 11
				let month = month + 1
				let day = 1
			endif
		endif

		" month transition from january, march, may, july, august, october
		if day == 32
			if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10
				let month = month + 1
				let day = 1
			endif
		endif

		" month transition from DEC
		if day == 32
			if month == 12
				let month = 1
				let day = 1
				let year = year + 1
			endif
		endif
	endwhile

	return [day,month,year]
endfunction


" receive date, add weeks, return list
function! Add_Weeks(day, month, year, weeks)
	let day = a:day
	let month = a:month
	let year = a:year
	let i = a:weeks
	while i > 0
		if month == 2
			if year % 4 != 0
				if day+7 > 28
					let day = (day+7)-28
					let month = month + 1
				else
					let day = day + 7
				endif
			else
				if day+7 > 29
					let day = (day+7)-29
					let month = month + 1
				else
					let day = day + 7
				endif
			endif
		endif

		if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10
			if day+7 > 31
				let day = (day+7)-31
				let month = month + 1
			else
				let day = day + 7
			endif
		endif

		if month == 4 || month == 6 || month == 9 || month == 11
			if day+7 > 30
				let day = (day+7)-30
				let month = month + 1
			else
				let day = day + 7
			endif
		endif

		if month == 12
			if day+7 > 31
				let day = (day+7)-31
				let month = 1
				let year = year + 1
			else
				let day = day + 7
			endif
		endif

		let i = i - 1
	endwhile

	return [day,month,year]
endfunction


" receive date, add months, return list
function! Add_Months(day, month, year, months)
	let day = a:day
	let month = a:month
	let year = a:year
	let i = a:months
	while i > 0
		let month = month + 1
		let i = i - 1 

		" year transition
		if month == 13
			let month = 1
			let year = year + 1
		endif
	endwhile

	" check for impossible dates
	if day == 31
		if month == 2 || month == 4 || month == 6 || month == 9 || month == 11
			let day = 30

			" check for leapyears
			if month == 2 && day == 29
				if year % 4 != 0
					let day = 1
					let month = month + 1
				endif
			endif
		endif
	endif

	return [day,month,year]
endfunction


" receive date, add years, return list
function! Add_Years(day, month, year, years)
	let day = a:day
	let month = a:month
	let year = a:year
	let years = a:years

	let year = year + years

	" check for leapyears
	if day == 29 && month == 2
		if year % 4 != 0
			day = 1
			month = 3
		endif
	endif

	return [day, month, year]
endfunction


" format date to string
function! FormatDate(ndate)
	let nextDay = a:ndate[0]
	let nextMonth = a:ndate[1]
	let nextYear = a:ndate[2]

	if nextDay < 10 && len(nextDay) == 1
		let nextDay = '0' . nextDay 
	endif
	if nextMonth < 10 && len(nextMonth) == 1
		let nextMonth = '0' . nextMonth
	endif
	return nextYear . '-' . nextMonth . '-' . nextDay
endfunction


" update current line
function! ReplaceDate()
	let currentLine = getline(".")
	let currentDate = matchstr(currentLine, '\d\d\d\d-\d\d-\d\d')

	let currentYear = split(currentDate, "-")[0]
	let currentMonth = split(currentDate, "-")[1]
	let currentDay = split(currentDate, "-")[2]

	let actualYear = strftime('%Y')
	let actualMonth = strftime('%m')
	let actualDay = strftime('%d')

	let addPart = matchstr(currentLine, '\(++\|.+\)\d\+\(d\|m\|w\|y\)')
	let add = addPart[2:-2]
	let modifier = addPart[-1:]

	" add to actual date, else to scheduled date
	if(addPart[0] == '.')
		let currentYear = actualYear
		let currentMonth = actualMonth
		let currentDay = actualDay
	endif

	" get next day
	if modifier == 'd'
		let nextDate = Add_Days(currentDay, currentMonth, currentYear, add)
	elseif modifier == 'w'
		let nextDate = Add_Weeks(currentDay, currentMonth, currentYear, add)
	elseif modifier == 'm'
		let nextDate = Add_Months(currentDay, currentMonth, currentYear, add)
	elseif modifier == 'y'
		let nextDate = Add_Years(currentDay, currentMonth, currentYear, add)
	endif

	let newdate = FormatDate(nextDate)

	" write new line to file
	call setline(line('.'), substitute(getline('.'), '\d\d\d\d-\d\d-\d\d', newdate, ''))

	" log action to history file
	let actualFullDate = strftime('%Y-%m-%d %H:%M')
	let writeLine = "Marked DONE on " . actualFullDate . ": " . currentLine
	let filepath = expand('%:p:h') . '/.taskhistory'
	call writefile(split(writeLine, "\n", 1), filepath, "a")
endfunction

" keybindings
nnoremap <Leader>tt :call ReplaceDate()<cr>
