;+
; NAME:
;    pvcameraopen
;
; PURPOSE:
;    Open communication with a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcameraopen(camera)
;
; INPUTS:
;    camera: index of camera to open
;
; KEYWORD FLAGS:
;    monitor: if set, open camera in monitor mode
;        Default: Master mode, with full control
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
;    info = pvcameralistex() ; obtain info on visible cameras
;    err = pvcameraopen(0)   ; open the first camera
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvcameraopen, camera, monitor = monitor, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

accessmode = (keyword_set(monitor)) ? 0UL : 1UL

err = call_external("idlpvapi.so",  "idlPvCameraOpen", /cdecl, debug, $
                    ulong(camera), accessmode)

if debug then print, "PvCameraOpen: ", pvstrerr(err)

return, err
end
