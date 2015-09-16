;+
; NAME:
;    pvuninitialize
;
; PURPOSE:
;    Uninitializes the PvAVI SDK and frees resources
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> pvuninitialize
;
; INPUTS:
;    none
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; MODIFICATION HISTORY:
; 12/07/2010 Written by David G. Grier, New York University
; 12/11/2010 DGG Added debug code and COMPILE_OPT.  Unload module.
;
; Copyright (c) 2010 David G. Grier
;-
pro pvuninitialize, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external("idlpvapi.so", "idlPvUnInitialize", debug, /cdecl)

if debug then print, "PvUninitialize: ", pvstrerr(err)

end
