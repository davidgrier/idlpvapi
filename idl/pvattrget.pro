;+
; NAME:
;    pvattrget
;
; PURPOSE:
;    Report the value of a specified attribute of a 
;    specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> v = pvattrget(camera, attr)
;
; INPUTS:
;    camera: index of camera
;    attr:   string containing attribute to get
;
; OUTPUTS:
;    v: value of attribute
;
; PROCEDURE:
;    Calls routines from the idlpvapi.so library.
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    print, pvattrget(0, "ExposureValue")
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 11/02/2011 Written by David G. Grier, New York University
;
; Copyright (c) 2011 David G. Grier
;-
function pvattrget, camera, attr, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

if ~isa(attr, 'String') then begin
   message, 'requires an attribute string', /inf
   return, -1
endif

if ~pvattrisavailable(camera, attr, debug = debug) then begin
   message, attr + ' is not available', /inf
   return, -1
endif

info = pvattrinfo(camera, attr, debug = debug)

if ~(info[1] and 1) then begin
   message, 'cannot read attribute ' + attr, /inf
   return, -1
endif

err = 0
case info[0] of
   3: begin                     ; String
      val = ''
      err = call_external("idlpvapi.so", "idlPvAttrStringGet", /cdecl, $
                          debug, ulong(camera), string(attr), val)
   end
   4: begin                     ; Enum
      val = ''
      err = call_external("idlpvapi.so", "idlPvAttrEnumGet", /cdecl, $
                          debug, ulong(camera), string(attr), val)
   end
   5: begin                     ; Uint32
      val = 0UL
      err = call_external("idlpvapi.so", "idlPvAttrUint32Get", /cdecl, $
                          debug, ulong(camera), string(attr), val)
   end
   6: begin                     ; Float32
      val = 0.
      err = call_external("idlpvapi.so", "idlPvAttrFloat32Get", /cdecl, $
                          debug, ulong(camera), string(attr), val)
   end
else: val = -1
endcase

if err ne 0 then return, -1
return, val
end
