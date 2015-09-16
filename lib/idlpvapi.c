//
// idlpvapi: IDL interface to the PvAPI SDK for interacting
//    with Prosilica and AVT GigE video cameras
//
// Modification History
// 12/07/2010 Written by David G. Grier, New York University
// 03/16/2011 DGG Fixed bug in idlpvattfloat32set.
//
// Copyright (c) 2010-2011, David G. Grier
//

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

// PvAPI support
#include <PvApi.h>

// IDL support
#include <idl_export.h>

// Global data
IDL_INT debug;

#define MAXCAMERAS 128
tPvCameraInfoEx info[MAXCAMERAS];
tPvHandle camera[MAXCAMERAS];

#define MAXFRAMES 16
//tPvFrame frame[MAXFRAMES];
tPvFrame frame;

//#define IMGBUFFERSIZE 3*1024*1024
//char ImageBuffer[IMGBUFFERSIZE];

#define STRBUFFERSIZE 512
char buffer[STRBUFFERSIZE];

#define idlPvErrCode(CODE) -(int)(CODE)

#define CHECKINDEX(N) if ((N) >= MAXCAMERAS) {			\
    if (debug) printf("invalid camera index: %ld\n", (N));	\
    return idlPvErrCode(ePvErrBadHandle);			\
  }

//
// idlPvVersion
//
// Return the version number of the PvAPI module.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: OUT major number
// argv[2]: OUT minor number
int idlPvVersion (int argc, char *argv[])
{
  unsigned long *pMajor;
  unsigned long *pMinor;

  debug = *(IDL_INT *) argv[0];
  pMajor = (unsigned long *) argv[1];
  pMinor = (unsigned long *) argv[2];


  PvVersion(pMajor, pMinor);

  return 0;
}

//=========================================================
//
// INITIALIZATION
//
//=========================================================
//
// idlPvInitialize
//
// Initialize the PvAPI module.
//
// command line arguments
// argv[0]: IN/FLAG debug
int idlPvInitialize (int argc, char *argv[])
{
  tPvErr err;

  debug = *(IDL_INT *) argv[0];

  err = PvInitialize();

  return idlPvErrCode(err);
}

//
// idlPvUnInitialize
//
// Uninitialize the PvAPI module, freeing resources.
//
// command line arguments
// argv[0]: IN/FLAG debug
int idlPvUnInitialize (int argc, char *argv[])
{
  debug = *(IDL_INT *) argv[0];

  PvUnInitialize();

  return 0;
}

//
// idlPvCameraCount
//
// Return the number of cameras attached to the PvAPI system.
//
// command line arguments
// argv[0]: IN/FLAG debug
int idlPvCameraCount (int argc, char *argv[])
{
  unsigned long count;

  debug = *(IDL_INT *) argv[0];

  count = PvCameraCount();

  return (int) count;
}

//
// idlPvCameraListEx
//
// List the Prosilica or AVT cameras currently visible to the system.
// 1. Fill up the internal list of structures
// 2. Transfer the list to IDL, element by element.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN Maximum number of cameras to list
unsigned long idlPvCameraListEx (int argc, char *argv[])
{
  unsigned long maxncameras;
  unsigned long ncameras; // number of visible cameras
  unsigned long nentries; // number of valid entries in the info table

  debug = *(IDL_INT *) argv[0];
  maxncameras = *(unsigned long *) argv[1];

  CHECKINDEX(maxncameras);

  nentries = PvCameraListEx(info, maxncameras, &ncameras, 
			    sizeof(tPvCameraInfoEx));

  return nentries;
}

//
// idlTransferCameraListEx
//
// Transfer the information on a specified camera from
// the list populated by idlPvCameraListEx
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera: index to retrieve
// argv[2]: OUT version of the structure
// argv[3]: OUT unique id of the camera
// argv[4]: OUT camera name
// argv[5]: OUT model name
// argv[6]: OUT part number
// argv[7]: OUT serial number
// argv[8]: OUT firmware version
// argv[9]: OUT PermittedAccess flags
// argv[10]: OUT interface ID
// argv[11]: OUT interface type
int idlTransferCameraListEx (int argc, char *argv[])
{
  unsigned long camera;
  tPvCameraInfoEx *thiscamera;

  debug = *(IDL_INT *) argv[0];
  camera = *(unsigned long *) argv[1];

  CHECKINDEX(camera);

  thiscamera = &info[camera];

  *argv[2] = (IDL_ULONG) thiscamera->StructVer;
  *argv[3] = (IDL_ULONG) thiscamera->UniqueId;
  IDL_StrStore((IDL_STRING *) argv[4], thiscamera->CameraName);
  IDL_StrStore((IDL_STRING *) argv[5], thiscamera->ModelName);
  IDL_StrStore((IDL_STRING *) argv[6], thiscamera->PartNumber);
  IDL_StrStore((IDL_STRING *) argv[7], thiscamera->SerialNumber);
  IDL_StrStore((IDL_STRING *) argv[8], thiscamera->FirmwareVersion);
  *argv[9] = (IDL_ULONG) thiscamera->PermittedAccess;
  *argv[10] = (IDL_ULONG) thiscamera->InterfaceId;
  *argv[11] = (IDL_ULONG) thiscamera->InterfaceType;
  
  return 0;
}

//
// idlPvCameraOpen
//
// Open a camera
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN index of camera to be opened
// argv[2]: IN accessflag: 0 for listen-only, 1 for master
int idlPvCameraOpen (int argc, char *argv[])
{
  unsigned long n;
  unsigned long accessflag;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  accessflag = *(unsigned long *) argv[2];

  CHECKINDEX(n);

  err = PvCameraOpen(info[n].UniqueId,
		     (accessflag) ? ePvAccessMaster : ePvAccessMonitor,
		     &camera[n]);

  return idlPvErrCode(err);
}

//
// idlPvCameraClose
//
// Close specified camera
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
int idlPvCameraClose (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  
  CHECKINDEX(n);

  err = PvCameraClose(camera[n]);

  return idlPvErrCode(err);
}

//=========================================================
//
// CAPTURE STREAM
//
//=========================================================

//
// idlPvCaptureStart
//
// Start the image capture stream.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
int idlPvCaptureStart (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];

  CHECKINDEX(n);

  err = PvCaptureStart(camera[n]);

  return idlPvErrCode(err);
}

//
// idlPvCaptureEnd
//
// Shut down the image capture stream.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
int idlPvCaptureEnd (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];

  CHECKINDEX(n);

  err = PvCaptureEnd(camera[n]);

  return idlPvErrCode(err);
}

//
// idlCaptureQueueFrame
//
// Place an image buffer onto the frame queue
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN image buffer
// argv[3]: IN buffersize
// argv[4]: IN flags buffer
int idlPvCaptureQueueFrame (int argc, char *argv[])
{
  unsigned long err;
  unsigned long n;
  char *buf;
  unsigned long buffersize;
  char *flags;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  buf = (char *) argv[2];
  buffersize = *(unsigned long *) argv[3];
  flags = (char *) argv[4];

  CHECKINDEX(n);

  memset((void *) &frame, 0, sizeof(tPvFrame));
  //frame.ImageBuffer = ImageBuffer; // using permanently allocated buffer
  //frame.ImageBufferSize = IMGBUFFERSIZE;
  frame.Context[0] = (void *) flags;
  frame.ImageBuffer = buf;
  frame.ImageBufferSize = buffersize;

  err = PvCaptureQueueFrame(camera[n], &frame, NULL);

  return err;
}

//
// idlPvCaptureWaitForFrameDone
//
// Block the calling thread until a frame is complete
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN timeout in milliseconds
int idlPvCaptureWaitForFrameDone (int argc, char *argv[])
{
  unsigned long err;
  unsigned long n;
  unsigned long timeout;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  timeout = *(unsigned long *) argv[2];

  CHECKINDEX(n);

  err = PvCaptureWaitForFrameDone(camera[n], &frame, timeout);

  return err;
}

//
// idlPvCaptureTransferFrame
//
// Transfer captured image to IDL
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: OUT: image
int idlPvCaptureTransferFrame (int argc, char *argv[])
{
  char * buf;

  debug = *(IDL_INT *) argv[0];
  buf = (char *) argv[1];

  if (frame.Status == ePvErrSuccess) {
    memcpy(buf, frame.ImageBuffer, frame.ImageSize);
  }

  return idlPvErrCode(frame.Status);
}

//
// idlPvCaptureAdjustPacketSize
//
// Adjust the network packet size, up to maximum supported by the network.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN packet size in bytes (up to 8228)
int idlPvCaptureAdjustPacketSize (int argc, char *argv[])
{
  unsigned long err;
  unsigned long n;
  unsigned long packetsize;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  packetsize = *(unsigned long *) argv[2];

  CHECKINDEX(n);

  err = PvCaptureAdjustPacketSize(camera[n], packetsize);

  return err;
}
  
  
//=========================================================
//
// ATTRIBUTES
//
//=========================================================
//
// idlPvCountAttributes
//
// Return the number of attributes applicable to a camera.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: OUT number of attributes
int idlPvCountAttributes (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  tPvAttrListPtr list;
  unsigned long * count;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  count = (unsigned long *) argv[2];

  CHECKINDEX(n);

  err = PvAttrList(camera[n], &list, count);

  return idlPvErrCode(err);
}

//
// idlPvAttrList
//
// List all the attributes applicable to a camera.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: OUT array of attribute names
int idlPvAttrList (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  unsigned long count;
  tPvAttrListPtr list;
  IDL_STRING *idllist;
  int i;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  idllist = (IDL_STRING *) argv[2];

  CHECKINDEX(n);

  err = PvAttrList(camera[n], &list, &count);

  if (err == ePvErrSuccess) {
    for (i = 0; i < count; i++) {
      IDL_StrStore(&idllist[i], (char *) list[i]);
    }
  }

  return idlPvErrCode(err);
}
  
//
// idlPvAttrInfo
//
// Get data type and access mode information for an attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT data type
// argv[4]: OUT flags
int idlPvAttrInfo (int argc, char *argv[])
{
  unsigned long n;
  IDL_STRING * name;
  tPvAttributeInfo info;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];

  CHECKINDEX(n);

  err = PvAttrInfo(camera[n], IDL_STRING_STR(name), &info);

  *(IDL_ULONG *) argv[3] = (IDL_ULONG) info.Datatype;
  *(IDL_ULONG *) argv[4] = (IDL_ULONG) info.Flags;

  return idlPvErrCode(err);
}

//
// idlPvAttrIsAvailable
//
// Determine if the attribute is available for a specified camera
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN index of camera
// argv[2]: IN name of attribute
int idlPvAttrIsAvailable (int argc, char *argv[])
{
  unsigned long n;
  IDL_STRING *attribute;
  unsigned long err;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  attribute = (IDL_STRING *) argv[2];

  CHECKINDEX(n);

  err = PvAttrIsAvailable(camera[n],
			  IDL_STRING_STR(attribute));

  return idlPvErrCode(err);
}

//
// idlPvAttrEnumSet
//
// Set the value of an enumerated attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: IN attribute value
int idlPvAttrEnumSet (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  IDL_STRING *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (IDL_STRING *) argv[3];

  CHECKINDEX(n);

  err = PvAttrEnumSet(camera[n],
		      (const char *) IDL_STRING_STR(name),
		      (const char *) IDL_STRING_STR(value));

  return idlPvErrCode(err);
}

//
// idlPvAttrEnumGet
//
// Get the value of an enumerated attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute value
int idlPvAttrEnumGet (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  IDL_STRING *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (IDL_STRING *) argv[3];

  CHECKINDEX(n);

  err = PvAttrEnumGet(camera[n],
		      (const char *) IDL_STRING_STR(name),
		      buffer, STRBUFFERSIZE, (unsigned long *) NULL);

  IDL_StrStore(value, buffer);
		      
  return idlPvErrCode(err);
}

//
// idlPvAttrEnumRange
//
// Get the possible values of an enumerated attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute values
int idlPvAttrEnumRange (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  IDL_STRING *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (IDL_STRING *) argv[3];

  CHECKINDEX(n);

  err = PvAttrRangeEnum(camera[n],
			(const char *) IDL_STRING_STR(name),
			buffer, STRBUFFERSIZE, (unsigned long *) NULL);

  IDL_StrStore(value, buffer);
		      
  return idlPvErrCode(err);
}

//
// idlPvAttrUint32Set
//
// Set the value of a Uint32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: IN attribute value
int idlPvAttrUint32Set (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  unsigned long value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = *(unsigned long *) argv[3];

  CHECKINDEX(n);

  err = PvAttrUint32Set(camera[n],
			(const char *) IDL_STRING_STR(name),
			(tPvUint32) value);

  return idlPvErrCode(err);
}

//
// idlPvAttrUint32Get
//
// Get the value of a Uint32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute value
int idlPvAttrUint32Get (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  unsigned long *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (unsigned long *) argv[3];

  CHECKINDEX(n);

  err = PvAttrUint32Get(camera[n],
			(const char *) IDL_STRING_STR(name),
			(tPvUint32 *) value);

  return idlPvErrCode(err);
}

//
// idlPvAttrUint32Range
//
// Get the range of values of a Uint32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute range min
// argv[4]: OUT attribute range max
int idlPvAttrUint32Range (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  unsigned long *vmin;
  unsigned long *vmax;
 
  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  vmin = (unsigned long *) argv[3];
  vmax = (unsigned long *) argv[4];

  CHECKINDEX(n);

  err = PvAttrRangeUint32(camera[n],
			  (const char *) IDL_STRING_STR(name),
			  (tPvUint32 *) vmin, (tPvUint32 *) vmax);

  return idlPvErrCode(err);
}

//
// idlPvAttrFloat32Set
//
// Set the value of a Float32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: IN attribute value
int idlPvAttrFloat32Set (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  float value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = *(float *) argv[3];

  CHECKINDEX(n);

  err = PvAttrFloat32Set(camera[n],
			 (const char *) IDL_STRING_STR(name),
			 (tPvFloat32) value);

  return idlPvErrCode(err);
}

//
// idlPvAttrFloat32Get
//
// Get the value of a Float32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute value
int idlPvAttrFloat32Get (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  float *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (float *) argv[3];

  CHECKINDEX(n);

  err = PvAttrFloat32Get(camera[n],
			(const char *) IDL_STRING_STR(name),
			(tPvFloat32 *) value);

  return idlPvErrCode(err);
}

//
// idlPvAttrFloat32Range
//
// Get the range of value of a Float32 attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute range minumum
// argv[4]: OUT attribute range maximum
int idlPvAttrFloat32Range (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  float *vmin;
  float *vmax;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  vmin = (float *) argv[3];
  vmax = (float *) argv[4];

  CHECKINDEX(n);

  err = PvAttrRangeFloat32(camera[n],
			   (const char *) IDL_STRING_STR(name),
			   (tPvFloat32 *) vmin, (tPvFloat32 *) vmax);

  return idlPvErrCode(err);
}

//
// idlPvAttrStringSet
//
// Set the value of a string attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: IN attribute value
int idlPvAttrStringSet (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  IDL_STRING *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (IDL_STRING *) argv[3];

  CHECKINDEX(n);

  err = PvAttrStringSet(camera[n],
			(const char *) IDL_STRING_STR(name),
			(const char *) IDL_STRING_STR(value));

  return idlPvErrCode(err);
}

//
// idlPvAttrStringGet
//
// Get the value of a string attribute
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN attribute name
// argv[3]: OUT attribute value
int idlPvAttrStringGet (int argc, char *argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING *name;
  IDL_STRING *value;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];
  value = (IDL_STRING *) argv[3];

  CHECKINDEX(n);

  err = PvAttrStringGet(camera[n],
			(const char *) IDL_STRING_STR(name),
			buffer, STRBUFFERSIZE, (unsigned long *) NULL);

  IDL_StrStore(value, buffer);
		      
  return idlPvErrCode(err);
}

//
// idlPvCommandRun
//
// Run a command.  A command is an attribute that executes a function
// when written.
//
// command line arguments
// argv[0]: IN/FLAG debug
// argv[1]: IN camera index
// argv[2]: IN command name
int idlPvCommandRun (int argc, char * argv[])
{
  unsigned long n;
  unsigned long err;
  IDL_STRING * name;

  debug = *(IDL_INT *) argv[0];
  n = *(unsigned long *) argv[1];
  name = (IDL_STRING *) argv[2];

  CHECKINDEX(n);

  err = PvCommandRun(camera[n], IDL_STRING_STR(name));

  return idlPvErrCode(err);
}
