;+
; NAME:
;    pvcameralistex
;
; PURPOSE:
;    List the Prosilica and AVT cameras currently visible to the
;    system.  This provides the UniqueID fields that are required
;    to communicate with specific cameras.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> list = pvcameralistex([maxncameras])
;
; OPTIONAL INPUTS:
;    maxncameras: Maximum number of cameras to list
;        Default: First camera
;
; OUTPUTS:
;    list: [ncameras] array of tPvCameraInfoEx structures
;
; PROCEDURE:
;    Uses CALL_EXTERNAL to call routines from
;    the PvAPI SDK to build up a functionality equivalent
;    to the PvCameraListEx routine.
;
; EXAMPLE:
;    err = pvinitialize()
;    list = pvcameralistex()
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 12/09/2010 Written by David G. Grier, New York University
; 12/11/2010 DGG Added debug code and COMPILE_OPT.
;
; Copyright (c) 2010 David G. Grier
;-
function pvcameralistex, maxncameras, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

if n_params() lt 1 then maxncameras = 1UL

ncameras = call_external("idlpvapi.so",  "idlPvCameraListEx", /cdecl, debug, $
                         ulong(maxncameras), /UL_VALUE)

if debug then print, "PvCameraListEx: ", ncameras, " cameras found"

structver = 0UL
uniqueid = 0UL
cameraname = ""
modelname = ""
partnumber = ""
serialnumber = ""
firmwareversion = ""
permittedaccess =  0UL
interfaceid = 0UL
interfacetype = 0UL

info = replicate( $
       {tPvCameraInfoEx, $
        structver:structver, $
        uniqueid:uniqueid, $
        cameraname:cameraname, $
        modelname:modelname, $
        partnumber:partnumber, $
        serialnumber:serialnumber, $
        firmwareversion:firmwareversion, $
        permittedaccess:permittedaccess, $
        interfaceid:interfaceid, $
        interfacetype:interfacetype}, ncameras)

for camera = 0UL, ncameras-1 do begin
   err = call_external("idlpvapi.so", "idlTransferCameraListEx", /cdecl, debug, $
                       ulong(camera), $
                       structver, uniqueid, cameraname, $
                       modelname, partnumber, serialnumber, firmwareversion, $
                       permittedaccess, interfaceid, interfacetype)

   if debug then print, "PvCameraListEx: Camera ", camera, ": ", pvstrerr(err)

   info[camera].structver = structver
   info[camera].uniqueid = uniqueid
   info[camera].cameraname = cameraname
   info[camera].modelname = modelname
   info[camera].partnumber = partnumber
   info[camera].serialnumber = serialnumber
   info[camera].firmwareversion = firmwareversion
   info[camera].permittedaccess = permittedaccess
   info[camera].interfaceid = interfaceid
   info[camera].interfacetype = interfacetype
endfor

return, info
end
