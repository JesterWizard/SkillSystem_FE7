@ Definitions

@ Functions
.global MoveCursorUp
.type   MoveCursorUp, function
.set    MoveCursorUp, 0x08081E85 //FE8 -> 0x08089355

.global MoveCursorDown
.type   MoveCursorDown, function
.set    MoveCursorDown, 0x08081EB5 //FE8 -> 0x08089385

.global MoveCursorLeft
.type   MoveCursorLeft, function
.set    MoveCursorLeft, 0x08081EE5 //FE8 -> 0x080893B5

.global MoveCursorRight
.type   MoveCursorRight, function
.set    MoveCursorRight, 0x08081F15 //FE8 -> 0x080893E5


@ RAM locations
.global StatScreenStruct
.set    StatScreenStruct, 0x0200310C //FE8 -> 0x02003BFC
