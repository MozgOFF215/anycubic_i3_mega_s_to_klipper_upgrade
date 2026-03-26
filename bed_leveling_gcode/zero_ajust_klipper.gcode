G90 ; Absolute positioning for all axes (X/Y/Z)
M140 S45 ; Set bed target temperature to 45C (do not wait)
M104 S200 ; Set nozzle target temperature to 200C (do not wait)
M190 S45 ; Wait until bed reaches 45C
M109 S200 ; Wait until nozzle reaches 200C
G28 ; Home all axes
G1 Z10 F1200 ; Lift nozzle to Z=10 at feedrate 1200 mm/min

G1 X10 Y10 F6000 ; Move to front-left point
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for all queued moves to finish
RESPOND MSG="FL: подкрути угол, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here (without park move)

G1 Z5 F1200 ; Lift before travel
G1 X200 Y10 F6000 ; Move to front-right point
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="FR: подкрути угол, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X200 Y200 F6000 ; Move to back-right point
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="BR: подкрути угол, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X10 Y200 F6000 ; Move to back-left point
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="BL: подкрути угол, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X100 Y100 F6000 ; Move to center check point
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="Center: проверь бумажкой, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X10 Y10 F6000 ; Move to front-left (2nd pass)
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="2nd FL: доводка, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X200 Y10 F6000 ; Move to front-right (2nd pass)
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="2nd FR: доводка, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X200 Y200 F6000 ; Move to back-right (2nd pass)
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="2nd BR: доводка, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z5 F1200 ; Lift before travel
G1 X10 Y200 F6000 ; Move to back-left (2nd pass)
G1 Z0.20 F600 ; Go to paper test height
M400 ; Wait for motion complete
RESPOND MSG="2nd BL: доводка, затем Resume" ; Show message in console/UI
PAUSE_BASE ; Pause exactly here

G1 Z10 F1200 ; Lift nozzle after leveling
TURN_OFF_HEATERS ; Turn off bed and nozzle heaters
M84 ; Disable stepper motors
