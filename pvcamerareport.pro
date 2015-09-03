;+
; NAME:
;    pvcamerareport
;
; PURPOSE:
;    Report all of the attributes of a specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> pvcamerareport, camera
;
; INPUTS:
;    camera: index of camera
;
; MODIFICATION HISTORY:
; 12/13/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
pro pvcamerareport, camera, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

RESOLVE_ALL, QUIET = ~debug

if pvinitialize(debug = debug) then return
while (pvcameracount(debug = debug) lt 1) do wait, 0.1
info = pvcameralistex(debug = debug)

if n_params() eq 0 then camera = 0 ; first camera by default

if pvcameraopen(camera, /monitor, debug = debug) then begin
   message, "could not access requested camera", /inf
   goto, uninitialize
endif

attr = pvattrlist(camera, err, debug = debug)
if (err ne 0) then begin
   message, "could not obtain list of attributes", /inf
   goto, closecamera
endif

nattr = n_elements(attr)
table = strarr(4, nattr)
table[0, *] = attr
for n = 0, nattr-1 do begin
   table[1:2, n] = pvattrinfo(camera, attr[n], /string, debug = debug)
   err = pvattr(camera, attr[n], value, /get, debug = debug)
   table[3, n] = string(value)
endfor

print
print, 'REPORT FOR CAMERA: ', strtrim(camera, 2)
print, 'TYPE: ', info.cameraname,  ' -- S/N: ', info.serialnumber
print
format = '(A,T33,A,T42,A,T50,A)'
print, format = format, ['ATTRIBUTE', 'TYPE', 'FLAGS', 'VALUE']
print, format = format, table

closecamera:
err = pvcameraclose(camera, debug = debug)

uninitialize:
pvuninitialize
end
