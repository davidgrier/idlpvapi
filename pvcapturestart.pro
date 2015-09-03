;+
; NAME:
;    pvcapturestart
;
; PURPOSE:
;    Start the image capture stream on a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcapturestart(camera)
;
; INPUTS:
;    camera: index of camera
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
;    err = pvcapturestart(0)
;    err = pvcaptureend(0)
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvcapturestart, camera, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external("idlpvapi.so",  "idlPvCaptureStart", /cdecl, debug, $
                    ulong(camera))

if debug then print, "PvCaptureStart: ", pvstrerr(err)

return, err
end
