;+
; NAME:
;    pvstrerr
;
; PURPOSE:
;    Returns a string explaining an error code returned
;    by the PvAPI SDK.
;
; CATEGORY:
;    Hardware control
;
; CALLING SEQUENCE:
;    IDL> str = pvstrerr(err)
;
; INPUTS:
;    err: Error code returned by an idlpvapi routine
;
; OUTPUTS:
;    str: String describing the error.
;
; PROCEDURE:
;    Transcription of the error codes in PvApi.h
;
; MODIFICATION HISTORY:
; 12/07/2010 Written by David G. Grier, New York University
; 12/11/2010 DGG Edited strings, corrected entries.  Added COMPILE_OPT.
;
; Copyright (c) 2010-2015 David G. Grier
;-
function pvstrerr, err

COMPILE_OPT IDL2

str = ['Success', $                                       ; ePvErrSuccess
       'Unexpected camera fault', $                       ; ePvErrCameraFault
       'Unexpected fault in PvAPI or driver', $           ; ePvErrInternalFault
       'Bad camera handle', $                             ; ePvErrBadHandle
       'Bad function parameter', $                        ; ePvErrBadParameter
       'Incorrect sequence of API calls', $               ; ePvErrBadSequence
       'Requested camera or attribute not found', $       ; ePvErrNotFound
       'Camera cannot be opened in the requested mode', $ ; ePvAccessDenied
       'Camera has been unexpectedly unplugged', $        ; ePvErrUnplugged
       'Some settings are invalid', $                     ; ePvErrInvalidSetup
       'System or network resources unavailable', $       ; ePvErrResources
       '1394 bandwidth is not available', $               ; ePvErrBandwidth
       'Frame queue is full', $                           ; ePvErrQueueFull
       'Frame buffer too small for image', $              ; ePvErrBufferTooSmall
       'Frame has been cancelled by user', $              ; ePvErrCancelled
       'Data for frame has been lost', $                  ; ePvErrDataLost
       'Some data for frame is missing', $                ; ePvErrDataMissing
       'Timeout expired', $                               ; ePvErrTimeout
       'Attempted to set attribute value out of range', $ ; ePvErrOutOfRange
       'Attempted to set attribute to wrong data type', $ ; ePvErrWrongType
       'Attribute cannot be written at this time', $      ; ePvErrForbidden
       'Attribute is not available at this time', $       ; ePvErrUnavailable
       'Firewall is blocking the streaming port', $       ; ePvErrFirewall
       'Unknown error!']

nerrors = n_elements(str)

myerror = (abs(err) > 0) < (nerrors - 1)

return, str[myerror]
end
