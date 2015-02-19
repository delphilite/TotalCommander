{ *********************************************************************** }
{                                                                         }
{   Total Commander content plugins (version 2.10 SE) header file         }
{                                                                         }
{   Éè¼Æ£ºLsuper 2015.02.14                                               }
{   ±¸×¢£º                                                                }
{   ÉóºË£º                                                                }
{         Contents of file contplug.h version 2.10                        }
{                                                                         }
{   Copyright (c) 1998-2015 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit contplug;

{ Contents of file contplug.pas }

interface

uses
  Windows;

const
  ftNoMoreFields        = 0;
  ftNumeric32           = 1;
  ftNumeric64           = 2;
  ftNumericFloating     = 3;
  ftDate                = 4;
  ft_Time               = 5;
  ft_Boolean            = 6;
  ft_MultipleChoice     = 7;
  ft_String             = 8;
  ft_Fulltext           = 9;
  ft_DateTime           = 10;
  ft_StringW            = 11;
  ft_comparecontent     = 100;

  // for ContentGetValue

  ft_NoSuchField        = -1;
  ft_FileError          = -2;
  ft_FieldEmpty         = -3;
  ft_OnDemand           = -4;
  ft_NotSupported       = -5;
  ft_SetCancel          = -6;
  ft_Delayed            = 0;

  // for ContentSetValue

  ft_SetSuccess         = 0; { setting of the attribute succeeded }

  // for ContentGetSupportedFieldFlags

  contFlags_Edit        = 1;
  contFlags_SubstSize   = 2;
  contFlags_SubstDateTime = 4;
  contFlags_SubstDate   = 6;
  contFlags_SubstTime   = 8;
  contFlags_SubstAttributes = 10;
  contFlags_SubstAttributeStr = 12;
  contFlags_PassThrough_Size_Float = 14;
  contFlags_SubstMask   = 14;
  contFlags_FieldEdit   = 16;

  // for ContentSendStateInformation

  contst_ReadNewDir     = 1;
  contst_RefreshPressed = 2;
  contst_ShowHint       = 4;

  // First attribute of this file
  setflags_First_Attribute = 1;
  // Last attribute of this file
  setflags_Last_Attribute = 2;
  // Only set the date of the datetime value!
  setflags_Only_Date    = 4;

  // ContentGetValue called in foreground
  CONTENT_DELAYIFSLOW   = 1;
  // If requested via contflags_passthrough_size_float: The size
  // is passed in as floating value, TC expects correct value
  // from the given units value, and optionally a text string
  CONTENT_PASSTHROUGH   = 2;

type
  PContentDefaultParamStruct = ^TContentDefaultParamStruct;
  TContentDefaultParamStruct = record
    Size,
    PluginInterfaceVersionLow,
    PluginInterfaceVersionHi: LongInt;
    DefaultIniName: array[0..MAX_PATH - 1] of AnsiChar;
  end;

  PDateFormat = ^TDateFormat;
  TDateFormat = record
    wYear,
    wMonth,
    wDay: Word;
  end;

  PTimeFormat = ^TTimeFormat;
  TTimeFormat = record
    wHour,
    wMinute,
    wSecond: Word;
  end;

  PFileDetailsStruct = ^TFileDetailsStruct;
  TFileDetailsStruct = record
    FileSize1Lo,
    FileSize1Hi: DWORD;
    FileSize2Lo,
    FileSize2Hi: DWORD;
    FileTime1: TFileTime;
    FileTime2: TFileTime;
    Attr1,
    Attr2: DWORD;
  end;

  TProgressCallbackProc = function(NextBlockData: Integer): Integer; stdcall;

{ Function prototypes: }

{
  procedure ContentGetDetectString(DetectString: PAnsiChar; MaxLen: Integer); stdcall;
  function ContentGetSupportedField(FieldIndex: Integer; FieldName, Units: PAnsiChar;
    MaxLen: Integer): Integer; stdcall;
  function ContentGetValue(FileName: PAnsiChar; FieldIndex, UnitIndex: Integer; FieldValue: PByte;
    MaxLen, Flags: Integer): Integer; stdcall;
  function ContentGetValueW(FileName: PWideChar; FieldIndex, UnitIndex: Integer; FieldValue: PByte;
    MaxLen, Flags: Integer): Integer; stdcall;
  procedure ContentSetDefaultParams(Dps: PContentDefaultParamStruct); stdcall;
  procedure ContentPluginUnloading; stdcall;
  procedure ContentStopGetValue(FileName: PAnsiChar); stdcall;
  procedure ContentStopGetValueW(FileName: PWideChar); stdcall;
  function ContentGetDefaultSortOrder(FieldIndex: Integer): Integer; stdcall;
  function ContentGetSupportedFieldFlags(FieldIndex: Integer): Integer; stdcall;
  function ContentSetValue(FileName: PAnsiChar; FieldIndex, UnitIndex, FieldType: Integer;
    FieldValue: PByte; Flags: Integer): Integer; stdcall;
  function ContentSetValueW(FileName: PWideChar; FieldIndex, UnitIndex, FieldType: Integer;
    FieldValue: PByte; Flags: Integer): Integer; stdcall;
  procedure ContentSendStateInformation(State: Integer; Path: PAnsiChar); stdcall;
  procedure ContentSendStateInformationW(State: Integer; Path: PWideChar); stdcall;
  function ContentEditValue(Handle: THandle; FieldIndex, UnitIndex, FieldType: Integer;
    FieldValue: PAnsiChar; MaxLen: Integer; Flags: Integer; LangIdentifier: PAnsiChar): Integer; stdcall;
  function ContentCompareFiles(ProgressCallback: TProgressCallbackProc; CompareIndex: Integer;
    FileName1, FileName2: PAnsiChar; FileDetails: PFileDetailsStruct): Integer; stdcall;
  function ContentCompareFilesW(ProgressCallback: TProgressCallbackProc; CompareIndex: Integer;
    FileName1, FileName2: PWideChar; FileDetails: PFileDetailsStruct): Integer; stdcall;
}

implementation

end.

