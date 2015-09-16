;+
; NAME:
;    pvcapturequeueframe
;
; PURPOSE:
;    Allocate and register a frame buffer for image acquisition with
;    an AVT or Prosilica camera using the PvAPI SDK.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcapturequeueframe(camera, buffer, flags)
;
; INPUTS:
;    camera: index of camera
;    buffer: array for storing images
;    flags: array for storing flags for the camera's callback process
;
; OUTPUTS:
;    err: error code
;
; KEYWORD FLAGS:
;    allocate: allocate buffer and flags
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
;    err = pvcapturequeueframe(0, buffer, flags, /allocate)
;    err = pvcaptureend(0)
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/12/2010 Written by David G. Grier, New York University
; 12/21/2010 DGG: Major overhaul.  Changed error return and argument
;     order.  Added ALLOCATE keyword.
; 03/14/2011 DGG Allocate buffer with correct geometry, rather than a
;     linear buffer.
;
; Copyright (c) 2010-2015, David G. Grier
;-
function pvcapturequeueframe, camera, buffer, flags, $
                              allocate = allocate, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = PvAttr(camera, "TotalBytesPerFrame", framesize, /get, debug = debug)
err = PvAttr(camera, "Width", w, /get, debug = debug)
err = PvAttr(camera, "Height", h, /get, debug = debug)

if keyword_set(allocate) then begin
;   buffer = bytarr(framesize)
   nchannels = framesize / w / h
   buffer = bytarr(nchannels, w, h)
   flags = bytarr(4)
endif else begin
   if n_elements(buffer) lt framesize then $
      message, "buffer too small to accommodate images: not queued", /inf
   if n_elements(flags) ne 4 then $
      message, "flags must be an array of four elements: not queued", /inf
endelse

err = call_external(pvlib(), "idlPvCaptureQueueFrame", /cdecl, debug, $
                    ulong(camera), buffer, framesize, flags)

if debug then print, "PvCaptureQueueFrame: ", pvstrerr(err)

return, err
end
