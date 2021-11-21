{ *********************************************************************** }
{                                                                         }
{   Total Commander file system plugins (version 2.1 SE) header file      }
{                                                                         }
{   Éè¼Æ£ºLsuper 2015.02.14                                               }
{   ±¸×¢£º                                                                }
{   ÉóºË£º                                                                }
{         Contents of fsplugin.h  version 2.1 (27.April.2010)             }
{                                                                         }
{   Copyright (c) 1998-2015 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit fsplugin; { Plugin definitions version 2.1 }

interface

uses
  Windows;

{ ids for FsGetFile }

const
  FS_FILE_OK            = 0;
  FS_FILE_EXISTS        = 1;
  FS_FILE_NOTFOUND      = 2;
  FS_FILE_READERROR     = 3;
  FS_FILE_WRITEERROR    = 4;
  FS_FILE_USERABORT     = 5;
  FS_FILE_NOTSUPPORTED  = 6;
  FS_FILE_EXISTSRESUMEALLOWED = 7;

  FS_EXEC_OK            = 0;
  FS_EXEC_ERROR         = 1;
  FS_EXEC_YOURSELF      = -1;
  FS_EXEC_SYMLINK       = -2;

  FS_COPYFLAGS_OVERWRITE = 1;
  FS_COPYFLAGS_RESUME   = 2;
  FS_COPYFLAGS_MOVE     = 4;
  FS_COPYFLAGS_EXISTS_SAMECASE = 8;
  FS_COPYFLAGS_EXISTS_DIFFERENTCASE = 16;

{ flags for tRequestProc }

const
  RT_Other              = 0;
  RT_UserName           = 1;
  RT_Password           = 2;
  RT_Account            = 3;
  RT_UserNameFirewall   = 4;
  RT_PasswordFirewall   = 5;
  RT_TargetDir          = 6;
  RT_URL                = 7;
  RT_MsgOK              = 8;
  RT_MsgYesNo           = 9;
  RT_MsgOKCancel        = 10;

{ flags for tLogProc }

const
  msgtype_connect       = 1;
  msgtype_disconnect    = 2;
  msgtype_details       = 3;
  msgtype_transfercomplete = 4;
  msgtype_connectcomplete = 5;
  msgtype_importanterror = 6;
  msgtype_operationcomplete = 7;

{ flags for FsStatusInfo }

const
  FS_STATUS_START       = 0;
  FS_STATUS_END         = 1;

  FS_STATUS_OP_LIST     = 1;
  FS_STATUS_OP_GET_SINGLE = 2;
  FS_STATUS_OP_GET_MULTI = 3;
  FS_STATUS_OP_PUT_SINGLE = 4;
  FS_STATUS_OP_PUT_MULTI = 5;
  FS_STATUS_OP_RENMOV_SINGLE = 6;
  FS_STATUS_OP_RENMOV_MULTI = 7;
  FS_STATUS_OP_DELETE   = 8;
  FS_STATUS_OP_ATTRIB   = 9;
  FS_STATUS_OP_MKDIR    = 10;
  FS_STATUS_OP_EXEC     = 11;
  FS_STATUS_OP_CALCSIZE = 12;
  FS_STATUS_OP_SEARCH   = 13;
  FS_STATUS_OP_SEARCH_TEXT = 14;
  FS_STATUS_OP_SYNC_SEARCH = 15;
  FS_STATUS_OP_SYNC_GET = 16;
  FS_STATUS_OP_SYNC_PUT = 17;
  FS_STATUS_OP_SYNC_DELETE = 18;
  FS_STATUS_OP_GET_MULTI_THREAD = 19;
  FS_STATUS_OP_PUT_MULTI_THREAD = 20;

{ Flags for FsExtractCustomIcon }

const
  FS_ICONFLAG_SMALL     = 1;
  FS_ICONFLAG_BACKGROUND = 2;

  FS_ICON_USEDEFAULT    = 0;
  FS_ICON_EXTRACTED     = 1;
  FS_ICON_EXTRACTED_DESTROY = 2;
  FS_ICON_DELAYED       = 3;

const
  FS_BITMAP_NONE        = 0;
  FS_BITMAP_EXTRACTED   = 1;
  FS_BITMAP_EXTRACT_YOURSELF = 2;
  FS_BITMAP_EXTRACT_YOURSELF_ANDDELETE = 3;
  FS_BITMAP_CACHE       = 256;

{ Flags for crypto callback function }

  FS_CRYPT_SAVE_PASSWORD = 1;
  FS_CRYPT_LOAD_PASSWORD = 2;
  FS_CRYPT_LOAD_PASSWORD_NO_UI = 3; { Load password only if master password has already been entered! }
  FS_CRYPT_COPY_PASSWORD = 4;       { Copy encrypted password to new connection name }
  FS_CRYPT_MOVE_PASSWORD = 5;       { Move password when renaming a connection }
  FS_CRYPT_DELETE_PASSWORD = 6;     { Delete password }

  FS_CRYPTOPT_MASTERPASS_SET = 1; { The user already has a master password defined }

  BG_DOWNLOAD           = 1;      { Plugin supports downloads in background }
  BG_UPLOAD             = 2;      { Plugin supports uploads in background }
  BG_ASK_USER           = 4;      { Plugin requires separate connection for background transfers -> ask user first }

type
  PRemoteInfo = ^TRemoteInfo;
  TRemoteInfo = record
    SizeLow, SizeHigh: LongInt;
    LastWriteTime: TFileTime;
    Attr: LongInt;
  end;

  PFsDefaultParamStruct = ^TFsDefaultParamStruct;
  TFsDefaultParamStruct = record
    size,
      PluginInterfaceVersionLow,
      PluginInterfaceVersionHi: LongInt;
    DefaultIniName: array[0..MAX_PATH - 1] of AnsiChar;
  end;

{ callback functions }

type
  TProgressProc = function(PluginNr: Integer; SourceName,
    TargetName: PAnsiChar; PercentDone: Integer): Integer; stdcall;
  TProgressProcW = function(PluginNr: Integer; SourceName,
    TargetName: pwidechar; PercentDone: Integer): Integer; stdcall;
  TLogProc = procedure(PluginNr, MsgType: Integer; LogString: PAnsiChar); stdcall;
  TLogProcW = procedure(PluginNr, MsgType: Integer; LogString: pwidechar); stdcall;
  TRequestProc = function(PluginNr, RequestType: Integer; CustomTitle, CustomText,
    ReturnedText: PAnsiChar; MaxLen: Integer): bool; stdcall;
  TRequestProcW = function(PluginNr, RequestType: Integer; CustomTitle, CustomText,
    ReturnedText: pwidechar; MaxLen: Integer): bool; stdcall;
  PCryptProc = ^TCryptProc;
  TCryptProc = function(PluginNr, CryptoNumber: Integer; mode: Integer; ConnectionName,
    Password: PAnsiChar; MaxLen: Integer): Integer; stdcall;
  PCryptProcW = ^TCryptProcW;
  TCryptProcW = function(PluginNr, CryptoNumber: Integer; mode: Integer; ConnectionName,
    Password: pwidechar; MaxLen: Integer): Integer; stdcall;

{ Function prototypes - the callback functions MUST be implemented exactly like this! }

{
  function FsInit(PluginNr: Integer; pProgressProc: tProgressProc; pLogProc: tLogProc;
    pRequestProc: tRequestProc): Integer; stdcall;
  function FsInitW(PluginNr: Integer; pProgressProcW: tProgressProcW; pLogProcW: tLogProcW;
    pRequestProcW: tRequestProcW): Integer; stdcall;
  procedure FsSetCryptCallback(CryptProc: TCryptProc; CryptoNr, Flags: Integer); stdcall;
  procedure FsSetCryptCallbackW(CryptProcW: TCryptProcW; CryptoNr, Flags: Integer); stdcall;
  function FsFindFirst(path: PAnsiChar; var FindData: tWIN32FINDDATA): thandle; stdcall;
  function FsFindFirstW(path: PWideChar; var FindData: tWIN32FINDDATAW): thandle; stdcall;
  function FsFindNext(Hdl: thandle; var FindData: tWIN32FINDDATA): BOOL; stdcall;
  function FsFindNextW(Hdl: thandle; var FindDataW: tWIN32FINDDATAW): BOOL; stdcall;
  function FsFindClose(Hdl: thandle): Integer; stdcall;
  function FsMkDir(RemoteDir: PAnsiChar): BOOL; stdcall;
  function FsMkDirW(RemoteDir: PWideChar): BOOL; stdcall;
  function FsExecuteFile(MainWin: thandle; RemoteName, Verb: PAnsiChar): Integer; stdcall;
  function FsExecuteFileW(MainWin: thandle; RemoteName, Verb: PWideChar): Integer; stdcall;
  function FsRenMovFile(OldName, NewName: PAnsiChar; Move, OverWrite: BOOL;
    RemoteInfo: PRemoteInfo): Integer; stdcall;
  function FsRenMovFileW(OldName, NewName: PWideChar; Move, OverWrite: BOOL;
    RemoteInfo: PRemoteInfo): Integer; stdcall;
  function FsGetFile(RemoteName, LocalName: PAnsiChar; CopyFlags: Integer;
    RemoteInfo: PRemoteInfo): Integer; stdcall;
  function FsGetFileW(RemoteName, LocalName: PWideChar; CopyFlags: Integer;
    RemoteInfo: PRemoteInfo): Integer; stdcall;
  function FsPutFile(LocalName, RemoteName: PAnsiChar; CopyFlags: Integer): Integer; stdcall;
  function FsPutFileW(LocalName, RemoteName: PWideChar; CopyFlags: Integer): Integer; stdcall;
  function FsDeleteFile(RemoteName: PAnsiChar): BOOL; stdcall;
  function FsDeleteFileW(RemoteName: PWideChar): BOOL; stdcall;
  function FsRemoveDir(RemoteName: PAnsiChar): BOOL; stdcall;
  function FsRemoveDirW(RemoteName: PWideChar): BOOL; stdcall;
  function FsDisconnect(DisconnectRoot: PAnsiChar): BOOL; stdcall;
  function FsDisconnectW(DisconnectRoot: PWideChar): BOOL; stdcall;
  function FsSetAttr(RemoteName: PAnsiChar; NewAttr: Integer): BOOL; stdcall;
  function FsSetAttrW(RemoteName: PWideChar; NewAttr: Integer): BOOL; stdcall;
  function FsSetTime(RemoteName: PAnsiChar; CreationTime, LastAccessTime,
    LastWriteTime: PFileTime): BOOL; stdcall;
  function FsSetTimeW(RemoteName: PWideChar; CreationTime, LastAccessTime,
    LastWriteTime: PFileTime): BOOL; stdcall;
  procedure FsStatusInfo(RemoteDir: PAnsiChar; InfoStartEnd, InfoOperation: Integer); stdcall;
  procedure FsStatusInfoW(RemoteDir: PWideChar; InfoStartEnd, InfoOperation: Integer); stdcall;
  procedure FsGetDefRootName(DefRootName: PAnsiChar; MaxLen: Integer); stdcall;
  function FsExtractCustomIcon(RemoteName: PAnsiChar; ExtractFlags: Integer;
    var TheIcon: hicon): Integer; stdcall;
  function FsExtractCustomIconW(RemoteName: PWideChar; ExtractFlags: Integer;
    var TheIcon: hicon): Integer; stdcall;
  procedure FsSetDefaultParams(dps: PFsDefaultParamStruct); stdcall;
  function FsGetPreviewBitmap(RemoteName: PAnsiChar; Width, Height: Integer,
    var ReturnedBitmap: hbitmap): Integer; stdcall;
  function FsGetPreviewBitmapW(RemoteName: PWideChar; Width, Height: Integer,
    var ReturnedBitmap: hbitmap): Integer; stdcall;
  function FsLinksToLocalFiles: BOOL; stdcall;
  function FsGetLocalName(RemoteName: PAnsiChar; MaxLen: Integer): BOOL; stdcall;
  function FsGetLocalNameW(RemoteName: PWideChar; MaxLen: Integer): BOOL; stdcall;
}

{ ****************************** content plugin part ***************************** }

const
  ft_nomorefields       = 0;
  ft_numeric_32         = 1;
  ft_numeric_64         = 2;
  ft_numeric_floating   = 3;
  ft_date               = 4;
  ft_time               = 5;
  ft_boolean            = 6;
  ft_multiplechoice     = 7;
  ft_string             = 8;
  ft_fulltext           = 9;
  ft_datetime           = 10;
  ft_stringw            = 11; { Should only be returned by Unicode function }

  // for ContentGetValue
  ft_nosuchfield        = -1; { error, invalid field number given }
  ft_fileerror          = -2; { file i/o error }
  ft_fieldempty         = -3; { field valid, but empty }
  ft_ondemand           = -4; { field will be retrieved only when user presses <SPACEBAR> }
  ft_delayed            = 0;  { field takes a long time to extract -> try again in background }

  // for ContentSetValue
  ft_setsuccess         = 0; { setting of the attribute succeeded }

  // for FsContentGetSupportedFieldFlags
  contflags_edit        = 1;
  contflags_substsize   = 2;
  contflags_substdatetime = 4;
  contflags_substdate   = 6;
  contflags_substtime   = 8;

  contflags_substattributes = 10;

  contflags_substattributestr = 12;
  contflags_substmask   = 14;

  // for FsContentSetValue
  setflags_first_attribute = 1; { First attribute of this file }
  setflags_last_attribute = 2;  { Last attribute of this file }
  setflags_only_date    = 4;    { Only set the date of the datetime value! }

  CONTENT_DELAYIFSLOW   = 1; { ContentGetValue called in foreground }

type
  PContentDefaultParamStruct = ^TContentDefaultParamStruct;
  TContentDefaultParamStruct = record
    size,
      PluginInterfaceVersionLow,
      PluginInterfaceVersionHi: LongInt;
    DefaultIniName: array[0..MAX_PATH - 1] of AnsiChar;
  end;

  PDateFormat = ^TDateFormat;
  TDateFormat = record
    wYear, wMonth, wDay: Word;
  end;

  PTimeFormat = ^TTimeFormat;
  TTimeFormat = record
    wHour, wMinute, wSecond: Word;
  end;

{ Function prototypes: }

{
  procedure FsContentGetDetectString(DetectString: PAnsiChar; MaxLen: Integer); stdcall;
  function FsContentGetSupportedField(FieldIndex: Integer; FieldName: PAnsiChar;
    Units: PAnsiChar; MaxLen: Integer): Integer; stdcall;
  function FsContentGetValue(FileName: PAnsiChar; FieldIndex, UnitIndex: Integer; FieldValue: pbyte;
    MaxLen, flags: Integer): Integer; stdcall;
  function FsContentGetValueW(FileName: PWideChar; FieldIndex, UnitIndex: Integer; FieldValue: pbyte;
    MaxLen, flags: Integer): Integer; stdcall;
  procedure FsContentSetDefaultParams(dps: PContentDefaultParamStruct); stdcall;
  procedure FsContentStopGetValue(FileName: PAnsiChar); stdcall;
  procedure FsContentStopGetValueW(FileName: PWideChar); stdcall;
  function FsContentGetDefaultSortOrder(FieldIndex: Integer): Integer; stdcall;
  function FsContentGetSupportedFieldFlags(FieldIndex: Integer): Integer; stdcall;
  function FsContentSetValue(FileName: PAnsiChar; FieldIndex, UnitIndex, FieldType: Integer;
    FieldValue: pbyte; flags: Integer): Integer; stdcall;
  function FsContentSetValueW(FileName: PWideChar; FieldIndex, UnitIndex, FieldType: Integer;
    FieldValue: pbyte; flags: Integer): Integer; stdcall;
  function FsContentGetDefaultView(ViewContents, ViewHeaders, ViewWidths,
    ViewOptions: PAnsiChar; MaxLen: Integer): BOOL; stdcall;
  function FsContentGetDefaultViewW(ViewContents, ViewHeaders, ViewWidths,
    ViewOptions: PWideChar; MaxLen: Integer): BOOL; stdcall;
  function FsGetBackgroundFlags: Integer; stdcall;
}

implementation

end.
