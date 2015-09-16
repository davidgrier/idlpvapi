err = pvinitialize(debug = debug)
while (pvcameracount(debug = debug) lt 1) do wait, 0.1
info = pvcameralistex(debug = debug)
err = pvcameraopen(0, debug = debug)

;list = pvcameraattributes(0, /print)
err = PvAttr(0, "Width", wrange, /range, debug = debug)
err = PvAttr(0, "Height",  hrange, /range, debug = debug)
err =  PvAttr(0, "Width", wrange[1], debug = debug)
err =  PvAttr(0, "Height", hrange[1], debug = debug)
err = PvAttr(0, "PixelFormat", "Rgb24", debug = debug)

err = PvAttr(0, "CameraName", name, /get, debug = debug)
err = PvAttr(0, "Width", w, /get, debug = debug)
err = PvAttr(0, "Height", h, /get, debug = debug)
err = PvAttr(0, "PixelFormat", format, /get, debug = debug)
err = PvAttr(0, "FrameRate", framerate, /get, debug = debug)
err = PvAttr(0, "TotalBytesPerFrame", bytesperframe, /get, debug = debug)
;print, name
;print, format, w, h, bytesperframe, framerate

err = pvcapturestart(0, debug = debug)

err = pvAttr(0, "AcquisitionMode", "Continuous", debug = debug)
err = pvAttr(0, "FrameStartTriggerMode", "Software", debug = debug)
err = pvcommandrun(0, "AcquisitionStart", debug = debug)

err = pvcapturequeueframe(0, b, flags, /allocate, debug = debug)
err = pvcommandrun(0, "FrameStartTriggerSoftware", debug = debug)
err = pvcapturewaitforframedone(0, 1000, debug = debug)
im = image(b)

for n = 0, 100 do begin $
   err = pvcapturequeueframe(0, b, flags, debug = debug) & $
   err = pvcommandrun(0, "FrameStartTriggerSoftware", debug = debug) & $
   err = pvcapturewaitforframedone(0, 1000, debug = debug) & $
   im -> putdata, b & $
endfor

;for n = 0, 10 do begin $
;   err = pvcapturequeueframe(0, b, flags, debug = debug) & $
;   err = pvcapturewaitforframedone(0, 1000, debug = debug) & $
;   im -> putdata, reform(bytscl(b), 3, w, h) & $
;   wait, 1 & $
;endfor
err = pvcommandrun(0, "AcquisitionStop", debug = debug)
err = pvcaptureend(0, debug = debug)

err = pvcameraclose(0, debug = debug)
pvuninitialize, debug = debug
