;+
; NAME:
;    pvcameraclose
;
; PURPOSE:
;    Close communication with a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcameraclose(camera)
;
; INPUTS:
;    camera: index of camera to close
;
; OUTPUTS:
;    err: Error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on first visible camera
;    err = pvcameraopen(0)   ; open the first camera
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010-2015 David G. Grier
;-
function pvcameraclose, camera, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external(pvlib(),  "idlPvCameraClose", /cdecl, debug, $
                    ulong(camera))

if debug then print, "PvCameraClose: ", pvstrerr(err)

return, err
end
