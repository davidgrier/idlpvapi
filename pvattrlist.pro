;+
; NAME:
;    pvattrlist
;
; PURPOSE:
;    List the attributes of a specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> list = pvattrlist(camera, [err])
;
; INPUTS:
;    camera: index of camera
;
; OUTPUTS:
;    list: [nattributes] array of strings
;
; OPTIONAL OUTPUTS:
;    err: error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call routines from
;    the PvAPI SDK to build up a functionality equivalent
;    to the PvAttrList routine.
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    attributes = pvattrlist(0)
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvattrlist, camera, err, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

count = 0UL
err = call_external("idlpvapi.so", "idlPvCountAttributes", /cdecl, debug, $
                    long(camera), count)

if (err ne 0) then begin
   if debug then print, "PvAttrList: ", pvstrerr(err)
   return, -1
endif

if debug then print, "PvAttrList: ", count, " attributes"

list = strarr(count)

err = call_external("idlpvapi.so", "idlPvAttrList", /cdecl, debug, $
                    ulong(camera), list)

if debug then print, "PvAttrList: ", pvstrerr(err)

return, list
end
