;+
; NAME:
;    pvcapturetransferframe
;
; PURPOSE:
;    Transfer an image acquired with
;    an AVT or Prosilica camera using the PvAPI SDK.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> a = pvcapturetransferframe(camera, err)
;
; INPUTS:
;    camera: index of camera
;
; OUTPUTS:
;    a: acquired image
;
; OPTIONAL OUTPUT:
;    err: error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call relevant routines from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on first visible camera
;    err = pvcameraopen(0)   ; open the first camera
;    err = pvcapturestart(0)
;    frame = pvcapturequeueframe(0)
;    err = pvcaptureend(0)
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/12/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvcapturetransferframe, camera, err, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = PvAttrUint32(camera, "TotalBytesPerFrame", framesize, /get, debug = debug)
err = PvAttrUint32(camera, "Width", w, /get, debug = debug)
err = PvAttrUint32(camera, "Height", h, /get, debug = debug)
depth = framesize/w/h

a = bytarr(w, h)
err = call_external("idlpvapi.so", "idlPvCaptureTransferFrame", /cdecl, $
                    debug, a)

if debug then print, "PvCaptureQueueFrame: ", pvstrerr(err)

return, a
end
