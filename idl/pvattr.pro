;+
; NAME:
;    pvattr
;
; PURPOSE:
;    Set, get or check the range of an attribute 
;    on a Prosilica or AVT camera using the PvAPI SDK interface.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> err = pvattr(camera, attribute, value)
;
; INPUTS:
;    camera: index of camera
;    attribute: string containing the name of the attribute to set
;    value: value to set
;
; KEYWORD FLAGS
;    get: if set, get value of attribute
;        Default: Set value
;    range: if set, get the list of possible values
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
;    err = pvattr(0, "AcquisitionMode", "Continuous")
;    err = pvcameraclose(0)  ; close first camera
;    pvuninitialize          ; free resources for the PvAPI module
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
; 12/13/2010 DGG set value to blank string or string array for
;    GET or RANGE requests on unknown attribute types
; 03/14/2011 DGG include attribute name in debugging messages
;
; Copyright (c) 2010-2011, David G. Grier
;-
;
; Enumerated Attributes
;
function pvattrenum, camera, name, value, $
                     get = get, range = range, debug = debug

COMPILE_OPT IDL2, HIDDEN

debug = keyword_set(debug)

if keyword_set(get) then begin
   value = ""
   err = call_external("idlpvapi.so", "idlPvAttrEnumGet", /cdecl, debug, $
                       ulong(camera), string(name), value)
endif else if keyword_set(range) then begin
   value = ""
   err = call_external("idlpvapi.so", "idlPvAttrEnumRange", /cdecl, debug, $
                       ulong(camera), string(name), value)
endif else $
   err = call_external("idlpvapi.so",  "idlPvAttrEnumSet", /cdecl, debug, $
                       ulong(camera), string(name), string(value))

if debug then print, "PvAttrEnum: " + $
                     ((keyword_set(get)) ? "GET " : "SET ") + $
                     string(name) + ": ", pvstrerr(err)

return, err
end
;
; Uint32 Attributes
;
function pvattruint32, camera, name, value, $
                       get = get, range = range, debug = debug

COMPILE_OPT IDL2, HIDDEN

debug = keyword_set(debug)

if keyword_set(get) then begin
   value = 0UL
   err = call_external("idlpvapi.so", "idlPvAttrUint32Get", /cdecl, debug, $
                       ulong(camera), string(name), value)
endif else if keyword_set(range) then begin
   vmin = 0UL
   vmax = 0UL
   err = call_external("idlpvapi.so", "idlPvAttrUint32Range", /cdecl, debug, $
                       ulong(camera), string(name), vmin, vmax)
   value = [vmin, vmax]
endif else $
   err = call_external("idlpvapi.so",  "idlPvAttrUint32Set", /cdecl, debug, $
                       ulong(camera), string(name), ulong(value))

if debug then print, "PvAttrUint32: " + $
                     ((keyword_set(get)) ? "GET " : "SET ") + $
                     string(name) + ": ", pvstrerr(err)

return, err
end
;
; Float32 Attributes
;
function pvattrfloat32, camera, name, value, $
                        get = get, range = range, debug = debug

COMPILE_OPT IDL2, HIDDEN

debug = keyword_set(debug)

if keyword_set(get) then begin
   value = 0.
   err = call_external("idlpvapi.so", "idlPvAttrFloat32Get", /cdecl, debug, $
                       ulong(camera), string(name), value)
endif else if keyword_set(range) then begin
   vmin = 0.
   vmax = 0.
   err = call_external("idlpvapi.so", "idlPvAttrFloat32Range", /cdecl, debug, $
                       ulong(camera), string(name), vmin, vmax)
   value = [vmin, vmax]
endif else $
   err = call_external("idlpvapi.so",  "idlPvAttrFloat32Set", /cdecl, debug, $
                       ulong(camera), string(name), float(value))

if debug then print, "PvAttrFloat32: " + $
                     ((keyword_set(get)) ? "GET " : "SET ") + $
                     string(name) + ": ", pvstrerr(err)

return, err
end
;
; String Attributes
;
function pvattrstring, camera, name, value, $
                       get = get, range = range, debug = debug

COMPILE_OPT IDL2, HIDDEN

debug = keyword_set(debug)

if keyword_set(range) then begin
   value = "Free form"
   err = 0
endif else if keyword_set(get) then begin
   value = ""
   err = call_external("idlpvapi.so", "idlPvAttrStringGet", /cdecl, debug, $
                       ulong(camera), string(name), value)
endif else $
   err = call_external("idlpvapi.so",  "idlPvAttrStringSet", /cdecl, debug, $
                       ulong(camera), string(name), string(value))

if debug then print, "PvAttrString: " + $
                     ((keyword_set(get)) ? "GET " : "SET ") + $
                     string(name) + ": ", pvstrerr(err)

return, err
end
;
; Main routine
;
function pvattr, camera, name, value, $
                 get = get, range = range, debug = debug

debug = keyword_set(debug)

; is the attribute available?
if ~PvAttrIsAvailable(camera, name, err, debug = debug) then begin
   if debug then print, "PvAttr: Attribute ", name, " cannot be accessed"
   return, err
endif

; what kind of attribute?
info = PvAttrInfo(camera, name, err, debug = debug)
if (err ne 0) then begin
   if debug then print, "PvAttr: Cannot access information about ", name
   return, err
endif

case info[0] of
   3: err = PvAttrString(camera, name, value, $
                         get = get, range = range, debug = debug)
   4: err = PvAttrEnum(camera, name, value, $
                       get = get, range = range, debug = debug)
   5: err = PvAttrUint32(camera, name, value, $
                         get = get, range = range, debug = debug)
   6: err = PvAttrFloat32(camera, name, value, $
                          get = get, range = range, debug = debug)
   ELSE: begin
      if debug then print, "PvAttr: type not implemented"
      if keyword_set(get) then value = " "
      if keyword_set(range) then value = [" ", " "]
      return, -1
   end
endcase

return, err
end
