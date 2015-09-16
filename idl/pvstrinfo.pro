;+
; NAME:
;    pvstrinfo
;
; PURPOSE:
;    Translate attribute information into descriptive strings.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> str = pvstrinfo(info)
;
; INPUTS:
;    info: Attribute information returned by idlpvattrinfo
;
; OUTPUTS:
;    str: array of strings describing the data type and flags
;        of the attribute.
;
; PROCEDURE:
;    Transcription of the codes in PvApi.h
;
; MODIFICATION HISTORY:
; 12/11/2010 Written by David G. Grier, New York University
;
; Copyright (c) 2010 David G. Grier
;-
function pvstrinfo, info

COMPILE_OPT IDL2

type = ['Unknown', $            ; ePvDatatypeUnknown
        'Command', $            ; ePvDatatypeCommand
        'Raw', $                ; ePvDatatypeRaw
        'String', $             ; ePvDatatypeString
        'Enum', $               ; ePvDatatypeEnum
        'Uint32', $             ; ePvDatatypeUint32
        'Float32', $            ; ePvDatatypeFloat32
        'Int64', $              ; ePvDatatypeInt64
        'Boolean', $            ; ePvDatatypeBoolean
        'Unknown!']

maxtype = n_elements(type) - 1
mytype = type[info[0] < maxtype]

flags = info[1]
myflags  = ((flags and 1) eq 1) ? "r" : " " ; read
myflags += ((flags and 2) eq 2) ? "w" : " " ; write
myflags += ((flags and 4) eq 4) ? "V" : " " ; volatile
myflags += ((flags and 8) eq 8) ? "C" : " " ; constant

return, [mytype, myflags]
end
