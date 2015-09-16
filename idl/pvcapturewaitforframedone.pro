;+
; NAME:
;    pvcapturewaitforframedone
;
; PURPOSE:
;    Block until a frame is captured on a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcapturewaitforframedone(camera, frame, timeout)
;
; INPUTS:
;    camera: index of camera
;    frame: index of frame on camera
;    timeout: maximum time to wait in milliseconds
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
; Copyright (c) 2010-2015 David G. Grier
;-
function pvcapturewaitforframedone, camera, timeout, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external(pvlib(),  "idlPvCaptureWaitForFrameDone", /cdecl, $
                    debug, $
                    ulong(camera), ulong(timeout))

if debug then print, "PvCaptureWaitForFrameDone: ", pvstrerr(err)

return, err
end
