{ *********************************************************************** }
{                                                                         }
{   Total Commander packer plugins (version 2.21 SE) header file          }
{                                                                         }
{   Éè¼Æ£ºLsuper 2021.11.05                                               }
{   ±¸×¢£º                                                                }
{   ÉóºË£º                                                                }
{         Contents of wcxhead.h  version 2.21                             }
{         Contents of file wcxhead.pas                                    }
{         It contains definitions of error codes, flags and callbacks     }
{                                                                         }
{   Copyright (c) 1998-2021 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit wcxhead;

interface

uses
  Windows;

const
  { Returned }
  E_SUCCESS             = 0;            { Success }

  { Error codes returned to calling application }
  E_END_ARCHIVE         = 10;           { No more files in archive }
  E_NO_MEMORY           = 11;           { Not enough memory }
  E_BAD_DATA            = 12;           { CRC error in the data of the currently unpacked file }
  E_BAD_ARCHIVE         = 13;           { The archive as a whole is bad, e.g. damaged headers }
  E_UNKNOWN_FORMAT      = 14;           { Archive format unknown }
  E_EOPEN               = 15;           { Cannot open existing file }
  E_ECREATE             = 16;           { Cannot create file }
  E_ECLOSE              = 17;           { Error closing file }
  E_EREAD               = 18;           { Error reading from file }
  E_EWRITE              = 19;           { Error writing to file }
  E_SMALL_BUF           = 20;           { Buffer too small }
  E_EABORTED            = 21;           { Function aborted by user }
  E_NO_FILES            = 22;           { No files found }
  E_TOO_MANY_FILES      = 23;           { Too many files to pack }
  E_NOT_SUPPORTED       = 24;           { Function not supported }

  { Flags for Unpacking }
  PK_OM_LIST            = 0;
  PK_OM_EXTRACT         = 1;

  { Flags for ProcessFile }
  PK_SKIP               = 0;            { Skip file (no unpacking) }
  PK_TEST               = 1;            { Test file integrity }
  PK_EXTRACT            = 2;            { Extract file to disk }

  { Flags passed through ChangeVolProc }
  PK_VOL_ASK            = 0;            { Ask user for location of next volume }
  PK_VOL_NOTIFY         = 1;            { Notify app that next volume will be unpacked }

  { Flags for packing }

  { For PackFiles }
  PK_PACK_MOVE_FILES    = 1;            { Delete original after packing }
  PK_PACK_SAVE_PATHS    = 2;            { Save path names of files }
  PK_PACK_ENCRYPT       = 4;            { Ask user for password, then encrypt }

  { Returned by GetPackCaps }
  PK_CAPS_NEW           = 1;            { Can create new archives }
  PK_CAPS_MODIFY        = 2;            { Can modify exisiting archives }
  PK_CAPS_MULTIPLE      = 4;            { Archive can contain multiple files }
  PK_CAPS_DELETE        = 8;            { Can delete files }
  PK_CAPS_OPTIONS       = 16;           { Supports the options dialogbox }
  PK_CAPS_MEMPACK       = 32;           { Supports packing in memory }
  PK_CAPS_BY_CONTENT    = 64;           { Detect archive type by content }
  PK_CAPS_SEARCHTEXT    = 128;          { Allow searching for text in archives
                                        { created with this plugin }
  PK_CAPS_HIDE          = 256;          { Show as normal files (hide packer icon) }
                                        { open with Ctrl+PgDn, not Enter }
  PK_CAPS_ENCRYPT       = 512;          { Plugin supports PK_PACK_ENCRYPT option }

  BACKGROUND_UNPACK     = 1;            { Which operations are thread-safe? }
  BACKGROUND_PACK       = 2;
  BACKGROUND_MEMPACK    = 4;            { For tar.pluginext in background }

  { Flags for packing in memory }
  MEM_OPTIONS_WANTHEADERS = 1;          { Return archive headers with packed data }

  { Errors returned by PackToMem }
  MEMPACK_OK            = 0;            { Function call finished OK, but there is more data }
  MEMPACK_DONE          = 1;            { Function call finished OK, there is no more data }

  { Flags for PkCryptProc callback }
  PK_CRYPT_SAVE_PASSWORD = 1;
  PK_CRYPT_LOAD_PASSWORD = 2;
  PK_CRYPT_LOAD_PASSWORD_NO_UI = 3;     { Load password only if master password has already been entered! }
  PK_CRYPT_COPY_PASSWORD = 4;           { Copy encrypted password to new archive name }
  PK_CRYPT_MOVE_PASSWORD = 5;           { Move password when renaming an archive }
  PK_CRYPT_DELETE_PASSWORD = 6;         { Delete password }

  PK_CRYPTOPT_MASTERPASS_SET = 1;       { The user already has a master password defined }

type
  { Definition of callback functions called by the DLL }

  { Ask to swap disk for multi-volume archive }
  PChangeVolProc  = ^TChangeVolProc;
  TChangeVolProc  = function(ArcName: PAnsiChar; Mode: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  PChangeVolProcW = ^TChangeVolProcW;
  TChangeVolProcW = function(ArcName: PWideChar; Mode: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  { Notify that data is processed - used for progress dialog }
  PProcessDataProc  = ^TProcessDataProc;
  TProcessDataProc  = function(FileName: PAnsiChar; Size: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  PProcessDataProcW = ^TProcessDataProcW;
  TProcessDataProcW = function(FileName: PWideChar; Size: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  { Pack crypt info callback }
  PPkCryptProc  = ^TPkCryptProc;
  TPkCryptProc  = function(CryptoNr: Integer; mode: Integer;
    ArchiveName, Password: PAnsiChar; maxlen: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  PPkCryptProcW = ^TPkCryptProcW;
  TPkCryptProcW = function(CryptoNr: Integer; mode: Integer;
    ArchiveName, Password: PWideChar; maxlen: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

type
  THeaderData = packed record
    ArcName: array[0..259] of AnsiChar;
    FileName: array[0..259] of AnsiChar;
    Flags,
    PackSize,
    UnpSize,
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: Integer;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: Integer;
  end;

  THeaderDataEx = packed record
    ArcName: array[0..1023] of AnsiChar;
    FileName: array[0..1023] of AnsiChar;
    Flags: Integer;
    PackSize,
    PackSizeHigh,
    UnpSize,
    UnpSizeHigh: LongWord;
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: Integer;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: Integer;
    Reserved: array[0..1023] of AnsiChar;
  end;

  THeaderDataExW = packed record
    ArcName: array[0..1023] of WideChar;
    FileName: array[0..1023] of WideChar;
    Flags: Integer;
    PackSize,
    PackSizeHigh,
    UnpSize,
    UnpSizeHigh: LongWord;
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: Integer;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: Integer;
    Reserved: array[0..1023] of AnsiChar;
  end;

  TOpenArchiveData = packed record
    ArcName: PAnsiChar;
    OpenMode,
    OpenResult: Integer;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: Integer;
  end;

  TOpenArchiveDataW = packed record
    ArcName: PWideChar;
    OpenMode,
    OpenResult: Integer;
    CmtBuf: PWideChar;
    CmtBufSize,
    CmtSize,
    CmtState: Integer;
  end;

  TPackDefaultParamStruct = record
    Size: Integer;
    PluginInterfaceVersionLow,
    PluginInterfaceVersionHi: LongWord;
    DefaultIniName: array[0..259] of AnsiChar;
  end;
  PPackDefaultParamStruct = ^TPackDefaultParamStruct;

type
  { Function prototypes }

  { Mandatory }
  TOpenArchive = function(var ArchiveData: TOpenArchiveData): THandle; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TReadHeader = function(hArcData: THandle; var HeaderData: THeaderData): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TProcessFile = function(hArcData: THandle; Operation: Integer; DestPath: PAnsiChar; DestName: PAnsiChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TCloseArchive = function(hArcData: THandle): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  { Optional }
  TPackFiles = function(PackedFile: PAnsiChar; SubPath: PAnsiChar; SrcPath: PAnsiChar; AddList: PAnsiChar; Flags: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TDeleteFiles = function(PackedFile: PAnsiChar; DeleteList: PAnsiChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TGetPackerCaps = function(): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TConfigurePacker = procedure(Parent: HWND; DllInstance: THandle); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TSetChangeVolProc = procedure(hArcData: THandle; ChangeVolProc: TChangeVolProc); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TSetProcessDataProc = procedure(hArcData: THandle; ProcessDataProc: TProcessDataProc); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TStartMemPack = function(Options: Integer; FileName: PAnsiChar): THandle; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TPackToMem = function(hMemPack: THandle; BufIn: PByte; InLen: Integer; Taken: PInteger; BufOut: PByte; OutLen: Integer; Written: PInteger; SeekBy: PInteger): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TDoneMemPack = function(hMemPack: THandle): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TCanYouHandleThisFile = function(FileName: PAnsiChar): Boolean; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TPackSetDefaultParams = procedure(dps: PPackDefaultParamStruct); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TReadHeaderEx = function(hArcData: THandle; var HeaderDataEx: THeaderDataEx): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TPkSetCryptCallback = procedure(PkCryptProc: TPkCryptProc; CryptoNr, Flags: Integer); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TGetBackgroundFlags = function(): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  { Unicode }
  TOpenArchiveW = function(var ArchiveData: TOpenArchiveDataW): THandle; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TReadHeaderExW = function(hArcData: THandle; var HeaderDataExW: THeaderDataExW): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TProcessFileW = function(hArcData: THandle; Operation: Integer; DestPath, DestName: PWideChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TSetChangeVolProcW = procedure(hArcData: THandle; ChangeVolProc: TChangeVolProcW); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TSetProcessDataProcW = procedure(hArcData: THandle; ProcessDataProc: TProcessDataProcW); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TPackFilesW = function(PackedFile, SubPath, SrcPath, AddList: PWideChar; Flags: Integer): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TDeleteFilesW = function(PackedFile, DeleteList: PWideChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TStartMemPackW = function(Options: Integer; FileName: PWideChar): THandle; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TCanYouHandleThisFileW = function(FileName: PWideChar): Boolean; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  TPkSetCryptCallbackW = procedure(PkCryptProc: TPkCryptProcW; CryptoNr, Flags: Integer); {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

implementation

end.
