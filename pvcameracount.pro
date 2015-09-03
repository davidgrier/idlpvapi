;+
; NAME:
;    pvcameracount
;
; PURPOSE:
;    Returns the number of GigE cameras presently connected
;    to the system.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> n = pvcameracount()
;
; INPUTS:
;    none
;
; OUTPUTS:
;    n: Number of attached cameras
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()
;    if ~err then n = pvcameracount()
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 12/07/2010 Written by David G. Grier, New York University
; 12/11/2010 DGG Added debug code and COMPILE_OPT
;
; Copyright (c) 2010 David G. Grier
;-
function pvcameracount, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

n = call_external("idlpvapi.so", "idlPvCameraCount", /cdecl, debug)

if debug then print, "PvCameraCount: ", n

return, n
end
