;+
; NAME:
;    pvattrinfo
;
; PURPOSE:
;    Return information about one attribute of a Prosilica or AVT
;    camera using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> res = pvattrinfo(camera, attribute, err)
;
; INPUTS:
;    camera: index of camera
;    attribute: string containing the name of the attribute
;
; OUTPUTS:
;    res: data type and flags of the attribute
;
; OPTIONAL OUTPUT:
;    err: error code
;
; KEYWORD FLAGS:
;    string: if set, return results as strings rather than numeric values
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routines from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on first visible camera
;    err = pvcameraopen(0)   ; open the first camera
;    print, pvattrinfo(0, "AcquisitionMode")
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvattrinfo, camera, name, err, string = string, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

datatype = 0UL
flags = 0UL
err = call_external("idlpvapi.so",  "idlPvAttrInfo", /cdecl, debug, $
                    ulong(camera), string(name), datatype, flags)

if debug then print, "PvAttrInfo: ", pvstrerr(err)

res = [datatype, flags]

return, (keyword_set(string)) ? pvstrinfo(res) : res
end
