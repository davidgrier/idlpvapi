;+
; NAME:
;    pvinitialize
;
; PURPOSE:
;    Initializes the PvAPI SDK for interacting
;    with GigE video cameras manufactured by Prosilica or AVT.
;    This routine must be called before any other routine,
;    except pvversion(), which may be called at any time.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvinitialize()
;
; INPUTS:
;    none
;
; OUTPUTS:
;    err: Error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; MODIFICATION HISTORY:
; 12/07/2010 Written by David G. Grier, New York University
; 12/11/2010 DGG Added debug code and COMPILE_OPT.
;
; Copyright (c) 2010-2015 David G. Grier
;-
function pvinitialize, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external(pvlib(),  "idlPvInitialize", /cdecl, debug)

if debug then print, "PvInitialize: ", pvstrerr(err)

return, err
end
