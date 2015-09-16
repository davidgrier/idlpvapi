;+
; NAME:
;    pvattrset
;
; PURPOSE:
;    Set the value of a specified attribute of a 
;    specified Prosilica or AVT camera
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvattrset(camera, attr, value)
;
; INPUTS:
;    camera: index of camera
;    attr:   string containing name of attribute to set
;    value:  value of attribute
;
; OUTPUTS:
;    err: error code
;
; PROCEDURE:
;    Calls routines from the idlpvapi.so library.
;
; EXAMPLE:
;    err = pvinitialize()
;    cameras = pvcameralistex()
;    err = pvcameraopen(0)
;    err = pvattrset(0, "ExposureValue", 10000) ; 10 ms
;    print, pvattrget(0, "ExposureValue")
;    err = pvcameraclose(0)
;    pvuninitialize
;
; MODIFICATION HISTORY:
; 11/02/2011 Written by David G. Grier, New York University
;
; Copyright (c) 2011 David G. Grier
;-
function pvattrset, camera, attr, value, debug = debug

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
   3: begin                     ; String
      err = call_external("idlpvapi.so", "idlPvAttrStringSet", /cdecl, $
                          debug, ulong(camera), string(attr), string(value))
   end
   4: begin                     ; Enum
      err = call_external("idlpvapi.so", "idlPvAttrEnumSet", /cdecl, $
                          debug, ulong(camera), string(attr), string(value))
   end
   5: begin                     ; Uint32
      range = pvattrrange(camera, attr, debug = debug)
      if n_elements(range) eq 1 || value lt range[0] || value gt range[1] then $
         err = -1 $
      else $
      err = call_external("idlpvapi.so", "idlPvAttrUint32Set", /cdecl, $
                          debug, ulong(camera), string(attr), ulong(value))
   end
   6: begin                     ; Float32
      range = pvattrrange(camera, attr, debug = debug)
      if n_elements(range) eq 1 || value lt range[0] || value gt range[1] then $
         err = -1 $
      else $
      err = call_external("idlpvapi.so", "idlPvAttrFloat32Set", /cdecl, $
                          debug, ulong(camera), string(attr), float(value))
   end
else: begin
   message, "Attribute type not recognized", /inf
   err = -1
end
endcase

return, err
end
