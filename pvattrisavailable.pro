;+
; NAME:
;    pvattrisavailable
;
; PURPOSE:
;    Determine whether an attribute is available on a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> res = pvattrisavailable(camera, attribute, err)
;
; INPUTS:
;    camera: index of camera
;    attribute: string containing the name of the attribute to set
;
; OUTPUTS:
;    res: nonzero if attribute is available
;
; OPTIONAL OUTPUT:
;    err: error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routines from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on first visible camera
;    err = pvcameraopen(0)   ; open the first camera
;    err = pvcapturestart(0)
;    print, pvattrisavailable(0, "AcquisitionMode")
;    err = pvcaptureend(0)
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
; 03/14/2011 DGG include name of attribute in debugging message.
;
; Copyright (c) 2010-2011, David G. Grier
;-
function pvattrisavailable, camera, name, err, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external("idlpvapi.so",  "idlPvAttrIsAvailable", /cdecl, debug, $
                    ulong(camera), string(name))

if debug then print, "PvAttrIsAvailable: " + string(name) + ": ", pvstrerr(err)

return, (err eq 0)
end
