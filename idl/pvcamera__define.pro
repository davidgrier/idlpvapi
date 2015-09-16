;
; Initialization
;
; Initialize the PvAPI module, get a list of cameras
; and open the requested camera
;
function pvcamera::init

if pvinitialize() then return, 0
while (pvcameracount() lt 1) do wait, 0.1
info = pvcameralistex()
if pvcameraopen(self.camera) then begin
   pvuninitialize
   return, 0
endif

self.image = ptr_new(/allocate)

return, 1
end

;
; Cleanup
;
; Shut down the PvAPI module and clean up the
; pvcamera object
;
pro pvcamera::cleanup

self->stopcapture
err = pvcameraclose(self.camera)
pvuninitialize
ptr_free, self.image

return
end

;
; Attributes
;
; Return a list of camera attributes
;
function pvcamera::attributes

list = pvcameraattributes(self.camera)

return, list
end

pro pvcamera::attributes

list = pvcameraattributes(self.camera, /print)

return
end

;
; Attr
;
; Get, Set or determine the Range of values for a named attribute
;
function pvcamera::attr, name, value, $
                         get = get, set = set, range = range

self.err = pvattr(self.camera, name, value, $
                  get = get, range = range)

if self.err ne 0 then $
   return, -1

return, value
end

;
; Startcapture
;
; Start capturing images
;
pro pvcamera::startcapture

if ~self.capturing then begin
   self.err = pvcapturestart(self.camera)
   print, "Capture Start: ", pvstrerr(self.err)
;   self.err = pvcapturequeueframe(self.camera, buffer, flags, /allocate)
   self.capturing = 1
endif

if ~self.acquiring then begin
   self.err = pvattr(self.camera, "AcquisitionMode", "Continuous")   
;self.err = pvcommandrun(self.camera, "AcquisitionStart")
   self.acquiring = 1
endif

print, "ok"
return
end

;
; Stopcapture
;
; Stop capturing images
;
pro pvcamera::stopcapture

if self.acquiring then begin
   self.err = pvcommandrun(self.camera, "AcquisitionStop")
   print, "Acquisition Stop: ", pvstrerr(self.err)
endif

if self.capturing then begin
   self.err = pvcaptureend(self.camera)
   print, "Capture Stop: ", pvstrerr(self.err)
endif

self.acquiring = 0
self.capturing = 0

return
end

;
; Error
;
; Report errors
;
function pvcamera::error, string = string

return, (keyword_set(string)) ? pvstrerr(self.err) : self.err
end

pro pvcamera__define, camera

if n_params() eq 0 then camera = 0UL ; first camera by default
 
void = {pvcamera, $
        image:ptr_new(), $        ; last image from camera
        camera:ulong(camera), $   ; index of camera
        flags:bytarr(4), $        ; flags for camera's callback process
        capturing:0, $            ; is the capture stream open?
        acquiring:0, $            ; is camera acquiring images?
        err:0UL $                 ; last error code
       }
return
end
