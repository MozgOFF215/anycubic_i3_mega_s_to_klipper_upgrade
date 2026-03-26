G21 ; Set units to millimeters
G90 ; Use absolute positioning
M104 S200 ; Set nozzle temperature
M140 S45 ; Set bed temperature
M109 S200 ; Wait for nozzle temperature
M190 S45 ; Wait for bed temperature
G28 ; Home all axes
G1 Z5 F1000 ; Raise nozzle to avoid scratching

; first part
; Move to front-left corner
G1 X10 Y10 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to back-right corner
G1 Z5 F1000
G1 X200 Y200 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to back-left corner
G1 Z5 F1000
G1 X10 Y200 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to front-right corner
G1 Z5 F1000
G1 X200 Y10 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to center
G1 Z5 F1000
G1 X100 Y100 F3000 ; Move to center
G1 Z0 F1000
G4 S10 ; wait 10 seconds  

; second part
; raise and move to front-left corner
G1 Z5 F1000
G1 X10 Y10 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to back-right corner
G1 Z5 F1000
G1 X200 Y200 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to back-left corner
G1 Z5 F1000
G1 X10 Y200 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to front-right corner
G1 Z5 F1000
G1 X200 Y10 F3000
G1 Z0 F1000
G4 S10 ; wait 10 seconds

; Raise and move to center
G1 Z5 F1000
G1 X100 Y100 F3000 ; Move to center
G1 Z0 F1000
G4 S10 ; wait 10 seconds  

; Raise and finish
G1 Z10 F3000