###
The MIT License (MIT)

Tyepd.coffee | Copyright (c) 2014 Matt Boldt | www.mattboldt.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

	"use strict"

	Typed = (el, options) ->

		# chosen element to manipulate text
		@el = $(el)
		# options
		@options = $.extend({}, $.fn.typed.defaults, options)

		# text content of element
		@text = @el.text()

		# typing speed
		@typeSpeed = @options.typeSpeed

		# amount of time to wait before backspacing
		@backDelay = @options.backDelay

		# input strings of text
		@strings = @options.strings

		# character number position of current string
		@strPos = 0

		# current array position
		@arrayPos = 0

		# current string based on current values[] array position
		@string = @strings[@arrayPos]

		# number to stop backspacing on.
		# default 0, can change depending on how many chars
		# you want to remove at the time
		@stopNum = 0

		# Looping logic
		@loop = @options.loop
		@loopCount = @options.loopCount
		@curLoop = 1
		if @loop == false
			# number in which to stop going through array
			# set to strings[] array (length - 1) to stop deleting after last string is typed
			@stopArray = @strings.length-1

		else
			@stopArray = @strings.length


		# All systems go!
		@build()


	Typed.prototype =

		constructor: Typed

		init: ->
			# begin the loop w/ first current string (global self.string)
			# current string will be passed as an argument each time after this
			@typewrite(@string, @strPos)

		build: ->
			@el.after("<span id=\"typed-cursor\">|</span>")
			@init()


		# pass current string state to each function
		typewrite: (curString, curStrPos) ->

			# varying values for setTimeout during typing
			# can't be global since number changes each time loop is executed
			humanize = Math.round(Math.random() * (100 - 30)) + @typeSpeed
			self = this

			# ------------- optional ------------- #
			# backpaces a certain string faster
			# ------------------------------------ #
			# if (self.arrayPos == 1){
			# 	self.backDelay = 50
			# }
			# else{ self.backDelay = 500 }

			# containg entire typing function in a timeout
			setTimeout( ->

				# make sure array position is less than array length
				if self.arrayPos < self.strings.length

					# start typing each new char into existing string
					# curString is function arg
					self.el.text(self.text + curString.substr(0, curStrPos))

					# check if current character number is the string's length
					# and if the current array position is less than the stopping point
					# if so, backspace after backDelay setting
					if curStrPos > curString.length && self.arrayPos < self.stopArray
						clearTimeout(clear)
						clear = setTimeout( ->
							self.backspace(curString, curStrPos)
						, self.backDelay)

					# else, keep typing
					else
						# add characters one by one
						curStrPos++
						# loop the function
						self.typewrite(curString, curStrPos)
						# if the array position is at the stopping position
						# finish code, on to next task
						if self.loop == false
							if self.arrayPos == self.stopArray && curStrPos == curString.length
								# animation that occurs on the last typed string
								# fires callback function
								clear = self.options.callback()
								clearTimeout(clear)

				# if the array position is greater than array length
				# and looping is active, reset array pos and start over.
				else if self.loop == true && self.loopCount == false
					self.arrayPos = 0
					self.init()

				else if self.loopCount != false && self.curLoop < self.loopCount
					self.arrayPos = 0
					self.curLoop = self.curLoop+1
					self.init()

			# humanized value for typing
			, humanize)


		backspace: (curString, curStrPos) ->

			# varying values for setTimeout during typing
			# can't be global since number changes each time loop is executed
			humanize = Math.round(Math.random() * (100 - 30)) + @typeSpeed
			self = this

			setTimeout( ->

				# ----- this part is optional ----- #
				# check string array position
				# on the first string, only delete one word
				# the stopNum actually represents the amount of chars to
				# keep in the current string. In my case it's 14.
				# if (self.arrayPos == 1){
				#	self.stopNum = 14
				# }
				#every other time, delete the whole typed string
				# else{
				#	self.stopNum = 0
				# }

				# ----- continue important stuff ----- #
				# replace text with current text + typed characters
				self.el.text(self.text + curString.substr(0, curStrPos))

				# if the number (id of character in current string) is
				# less than the stop number, keep going
				if curStrPos > self.stopNum
					# subtract characters one by one
					curStrPos--
					# loop the function
					self.backspace(curString, curStrPos)

				# if the stop number has been reached, increase
				# array position to next string
				else if curStrPos <= self.stopNum
					clearTimeout(clear)
					clear = self.arrayPos = self.arrayPos+1
					# must pass new array position in this instance
					# instead of using global arrayPos
					self.typewrite(self.strings[self.arrayPos], curStrPos)


			# humanized value for typing
			, humanize)

	$.fn.typed = (option) ->
    @each( ->
      $this = $(this)
      data = $this.data('typed')
      options = typeof option == 'object' && option
      if !data
      	$this.data('typed', (data = new Typed(this, options)))
      if typeof option == 'string'
      	data[option]()
      	true
    )

	$.fn.typed.defaults =
		strings: ["These are the default values...", "You know what you should do?", "Use your own!", "Have a great day!"],
		# typing and backspacing speed
		typeSpeed: 0
		# time before backspacing
		backDelay: 500
		# loop
		loop: false
		# false = infinite
		loopCount: false
		# ending callback function
		callback: -> null




