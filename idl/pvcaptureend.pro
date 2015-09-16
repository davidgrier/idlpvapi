;+
; NAME:
;    pvcaptureend
;
; PURPOSE:
;    Close the image capture stream on a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcaptureend(camera)
;
; INPUTS:
;    camera: index of camera
;
; OUTPUTS:
;    err: error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routine from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on visible cameras
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
function pvcaptureend, camera, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external("idlpvapi.so",  "idlPvCaptureEnd", /cdecl, debug, $
                    ulong(camera))

if debug then print, "PvCaptureEnd: ", pvstrerr(err)

return, err
end
