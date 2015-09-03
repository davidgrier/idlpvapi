;+
; NAME:
;    pvversion
;
; PURPOSE:
;    Returns the version of the installed PvAPI SDK
;    for interacting with GigE video cameras manufactured 
;    by Prosilica or AVT.
;    This routine may be called at any time without necessarily
;    initializing the PvAPI system.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> ver = pvversion()
;
; INPUTS:
;    none
;
; OUTPUTS:
;    ver: [major, minor]: major and minor numbers of the release.
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; MODIFICATION HISTORY:
; 12/07/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvversion, debug = debug

debug = keyword_set(debug)

major = 0UL
minor = 0UL

n = call_external("idlpvapi.so", "idlPvVersion", /cdecl, debug, major, minor)

return, [major, minor]
end
