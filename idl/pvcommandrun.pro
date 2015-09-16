;+
; NAME:
;    pvcommandrun
;
; PURPOSE:
;    Run a command on a Prosilica or AVT camera
;    using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvcommandrun(camera, command)
;
; INPUTS:
;    camera: index of camera
;    command: string containing the name of the command
;
; OUTPUTS:
;    err: Error code
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call the equivalent routines from
;    the PvAPI SDK.
;
; EXAMPLE:
;    err = pvinitialize()    ; initialize PvAPI module
;    info = pvcameralistex() ; obtain info on first visible camera
;    err = pvcameraopen(0)   ; open the first camera
;    err = pvcapturestart(0) ; start capture stream
;    err = pvcommandrun(0, "AcquisitionStart")
;    err = pvcommandrun(0, "AcquisitionStop")
;    err = pvcapturestop(0)
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/12/2010 Written by David G. Grier, New York University
; 03/14/2011 DGG. Include command in debugging message.
;
; Copyright (c) 2010-2015, David G. Grier
;-
function pvcommandrun, camera, command, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

err = call_external(pvlib(),  "idlPvCommandRun", /cdecl, debug, $
                    ulong(camera), string(command))

if debug then print, "PvCommandRun: " + string(command) + ": ", pvstrerr(err)

return, err
end
