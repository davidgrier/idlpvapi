;+
; NAME:
;    pvcaptureadjustpacketsize
;
; PURPOSE:
;    Set the maximum packet size for network communications
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcaptureadjustpacketsize(camera, packetsize)
;
; INPUTS:
;    camera: index of camera
;    packetsize: maximum packet size, up to 8228
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
; 03/17/2011 Written by David G. Grier, New York University
;
; Copyright (c) 2011, David G. Grier
;-
function pvcaptureadjustpacketsize, camera, packetsize, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external("idlpvapi.so",  "idlPvCaptureAdjustPacketSize", /cdecl, $
                    debug, $
                    ulong(camera), ulong(packetsize))

if debug then print, "PvCaptureAdjustPacketSize: ", pvstrerr(err)

return, err
end
