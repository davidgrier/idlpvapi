;+
; NAME:
;    pvcameraattributes
;
; PURPOSE:
;    Report all of the attributes of a specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> attributes = pvcameraattributes(camera)
;
; INPUTS:
;    camera: index of camera
;
; OUTPUTS:
;    list: [3, nattributes] array of strings
;        list[0,*]: names of attributes
;        list[1,*]: data types
;        list[2,*]: flags
;
; KEYWORD FLAGS:
;    print: if set, print a formatted list of attributes, types and flags
;
; PROCEDURE:
;    Calls pvattrlist and pvattrinfo
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    attributes = pvcameraattributes(0)
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 12/12/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvcameraattributes, camera, print = print, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

attr = pvattrlist(camera, err, debug = debug)
if (err ne 0) then return, -1

nattr = n_elements(attr)
table = strarr(3, nattr)
table[0, *] = attr
for n = 0, nattr-1 do $
   table[1:2, n] = pvstrinfo(pvattrinfo(camera, attr[n], debug = debug))

if keyword_set(print) then begin
   format = '(A,T35,A,T45,A)'
   print, format = format, ['ATTRIBUTE', 'TYPE', 'FLAGS']
   print, format = format, table
endif

return, table
end
