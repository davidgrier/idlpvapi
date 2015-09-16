;+
; NAME:
;    pvlib
;
; PURPOSE:
;    Return the location of the pvapi shared object library
;
; MODIFICATION HISTORY:
; 09/15/2015 Written by David G. Grier, New York University
;
; COPYRIGHT:
; Copyright (c) 2015 David G. Grier
;-
function pvlib

  COMPILE_OPT IDL2, HIDDEN

  return, "/usr/local/IDL/idlpvapi/idlpvapi.so"
end
