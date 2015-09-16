;+
; NAME:
;    pvattrrange
;
; PURPOSE:
;    Get the range of values of a specified attribute of a 
;    specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> range = pvattrrange(camera, attr)
;
; INPUTS:
;    camera: index of camera
;    attr:   string containing name of attribute to set
;
; OUTPUTS:
;    range: range of values
;
; PROCEDURE:
;    Calls routines from the idlpvapi.so library.
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    print, pvattrrange(0, "ExposureValue")
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 11/02/2011 Written by David G. Grier, New York University
;
; Copyright (c) 2011 David G. Grier
;-
function pvattrrange, camera, attr, debug = debug

COMPILE_OPT IDL2

debug = keyword_set(debug)

if ~isa(attr, 'String') then begin
   message, 'requires an attribute string', /inf
   return, -1
endif

if ~pvattrisavailable(camera, attr, debug = debug) then begin
   message, attr + ' is not an available attribute', /inf
   return, -1
endif

info = pvattrinfo(camera, attr, debug = debug)

if ~(info[1] and 2) then begin
   message, attr + ' is not a settable attribute', /inf
   return, -1
endif

case info[0] of
   4: begin                     ; Enum
      value = ''
      err = call_external("idlpvapi.so", "idlPvAttrEnumRange", /cdecl, $
                          debug, ulong(camera), string(attr), value)
   end
   5: begin                     ; Uint32
      min = 0UL
      max = 0UL
      err = call_external("idlpvapi.so", "idlPvAttrUint32Range", /cdecl, $
                          debug, ulong(camera), string(attr), min, max)
      value = [min, max]
   end
   6: begin                     ; Float32
      min = 0.
      max = 0.
      err = call_external("idlpvapi.so", "idlPvAttrFloat32Range", /cdecl, $
                          debug, ulong(camera), string(attr), min, max)
      value = [min, max]
   end
else: begin
   message, "Attribute does not have a range", /inf
   value = -1
end
endcase

return, value
end
