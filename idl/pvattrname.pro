;+
; NAME:
;    pvattrname
;
; PURPOSE:
;    Get the attribute name that most closely corresponds to a
;    given string.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> name = pvattrname(camera, str)
;
; INPUTS:
;    camera: index of camera
;    str:    string specifying name of attribute
;
; OUTPUTS:
;    name: name of attribute
;
; PROCEDURE:
;    Calls routines from the idlpvapi.so library.
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    print, pvattrget(0, "ExposureValue")
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 11/02/2011 Written by David G. Grier, New York University
;
; Copyright (c) 2011-2015 David G. Grier
;-
function pvattrname, camera, str, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

if ~isa(str, 'String') then begin
   message, 'requires an string specification', /inf
   return, ''
endif

list = pvattrlist(camera, err, debug = debug)
if err ne 0 then begin
   message, 'could not obtain list of attributes', /inf
   return, ''
endif

w = where(strmatch(list, str, /fold_case), nmatches)
if nmatches lt 1 then $
   return,  ''

attr = list[w]

flag = intarr(nmatches)
for i = 0, nmatches-1 do $
   flag[i] = pvattrisavailable(camera, attr[i], debug = debug)

w = where(flag, nmatches)
if nmatches lt 1 then $
   return, ''

return, attr[w]
end
