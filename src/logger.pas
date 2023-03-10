unit logger;

interface

uses classes;

const
 EWriteLogVars = 'ERROR : Calling WriteLogVars with empty Level and Msg vars';

type

 TLogLevel = byte;
 TLogger = class
  public
    Mask       : string;     //File Creation mask ( see FormatDateTime masks )
    LogDir     : string;
    WFileLevel : TLogLevel;  //Max file logging level (logged events with level [0-WFileLevel] )
                             //NOTE: AutiSwitch & AutoRote consume some disk i/o use with caution
    AutoSwitch : boolean;    //Automatic log shitch in every WriteLog call  //(def=true)
    AutoRotate : boolean;    //Auto Check for deleting old logs in every WriteLog //(def=true)
    AutoSync   : boolean;    //Auto flush buffers after each WriteLog (!!!) consumes _many_ disk i/o // (def=false)
                             // Do not use if you do not _realy_ need it
    DelEmpty   : boolean;    //Delete empty log file (def=true)
    KeepTime   : word;       //Time to keep log file in hours. (1 mean 1 hour) / max ~7 years ;-) 과거파일 유지기간
    RefList    : TStrings;
    WListLevel : TLogLevel;  //Max level to log. Just like WFileLevel
    MaxLength  : word;       //Maximum list length  //[0-(2^16-1)] realy I use <1000
    SelfLog    : boolean;    //Log TLogger events&  (def=true)
    Level      : byte;       //Make simple - logging via Syncronize with method // WriteLogVars
    Msg        : string;
    LogFileName : string;
    LogFile     : TFileStream;
   constructor Create ( AMask       : string;
                        ALogDir     : string;
                        AWFileLevel : TLogLevel;
                        AKeepTime   : word;
                        ARefList    : TStrings;
                        AWListLevel : TLogLevel;
                        AMaxLength  : word
                        );
    procedure WriteLog ( S : string ; ALevel : byte ); overload;//Write some message to log
    procedure WriteLog ( S : string ); overload;
    procedure WriteLog ( Val : Integer); overload;
    procedure WriteLog ( Tit: string; Val: integer); overload;

    procedure WriteLogVars;                            //Write message to log from Level &  Msg
    procedure SyncLogFile;                             //Flush file buffers to disk
    procedure CheckLogSwitch;                          //Check if we must switch log files&
    procedure RotateLog;                               //find and delete all old log files
    function FormatMsg ( S : string ; ALevel : TLogLevel ):string;virtual;  //format message before writing to log.
    destructor  Free;
  private


 end;
 
 function getLogger(AMask:string; ALogDir:string; AWFileLevel:TLogLevel; AKeepTime:word; ARefList:TStrings; AWListLevel:TLogLevel; AMaxLength:word) : TLogger; forward;
 function fsLogger(): TLogger; forward;
 
implementation

uses Dialogs, windows, SysUtils, Forms;

var
  _Logger : TLogger;
  _FreeShipLogger: TLogger;
  
function getlogger(AMask:string; ALogDir:string; AWFileLevel:TLogLevel; AKeepTime:word; ARefList:TStrings; AWListLevel:TLogLevel; AMaxLength:word): TLogger;
begin
  if _Logger = nil then
  begin
    if not DirectoryExists(ALogDir) then CreateDir(ALogDir);
    _Logger := TLogger.create(AMask, ALogDir, AWFileLevel, AKeepTime, ARefList, AWListLevel, AMaxLength);
  end;
  result := _Logger;
end;


function fsLogger(): TLogger;
begin
        if _FreeShipLogger = nil then
           _FreeShipLogger := TLogger.create('yyyy-mm-dd_hh"$freeship.log"', ExtractFilePath(Application.ExeName)+'Log\FreeShip\', 3, 10, NIL, 5, 300);
        result := _FreeShipLogger;
end;

constructor TLogger.Create ( AMask       : string;
                             ALogDir     : string;
                             AWFileLevel : TLogLevel;
                             AKeepTime   : word;
                             ARefList    : TStrings;
                             AWListLevel : TLogLevel;
                             AMaxLength  : word
                            );
begin
        Mask       := AMask;
        LogDir     :=  ALogDir;
        WFileLevel := AWFileLevel;
        AutoSwitch := True;
        AutoRotate := True;
        AutoSync   := False;
        DelEmpty   := True;
        KeepTime   := AKeepTime;
        RefList    := ARefList;
        WListLevel := AWListLevel;
        MaxLength  := AMaxLength;
        SelfLog    := true;
        Level      := 0;
        Msg        := EWriteLogVars;
        
        LogFile     := NIL;
        LogFileName := ALogDir + Mask;
        
        CheckLogSwitch; //if file pointer is NIL simply create and open log file
        RotateLog;
        
        if SelfLog then WriteLog ( 'Log system started.' , 0 );

end;

// =====================================================
//   Core
// =====================================================
procedure TLogger.WriteLog ( S : string ; ALevel : byte );
        procedure WL ( s : string );
        begin
             try
                 RefList.Add ( s );
             except
                 on E : Exception do
                 begin
                      beep;
                      ShowMessage ( 'TLogger : Erroe while writing to TStrings List' + E.Message );
                 end;
             end;
        end;
begin
        
        S := FormatMsg ( S , ALevel ); //1. Write to TString List
                
        if RefList <> NIL then begin
        
        //Check if we must clear list?
        if RefList.Count > MaxLength then
           try
              RefList.Clear;
           except
              on E : Exception do
              begin
                   beep; //attract user attention
                   ShowMessage ( 'TLogger : Error while cleaning TStrings List' + E.Message );
              end;
           end;
        
           if ALevel <= WListLevel then
              WL ( S );
        end;  //if RefList <> NIL
        
        //2. Write to file
        if LogFile <> NIL then
           if ALevel <= WFileLevel then
           try
              S := S + #13 + #10;
              if AutoSwitch then CheckLogSwitch;
              if AutoRotate then RotateLog;
              LogFile.WriteBuffer ( PChar ( S )^ , Length ( S ) );
              if AutoSync then SyncLogFile;
           except
              on E : Exception do
              if RefLIst <> NIL then
                 WL ( 'Error Writeing to log file ' + LogFileName );
           end;
end;


procedure TLogger.WriteLog ( S : string );
begin
  WriteLog(S, 0);
end;

procedure TLogger.WriteLog ( Val: Integer );
begin
  WriteLog(Inttostr(Val), 0);
end;

procedure TLogger.WriteLog ( Tit: string; Val: integer);
begin
  WriteLog(Tit + '=' + Inttostr(Val), 0);
end;


//Do the same from Level & Msg variables
procedure TLogger.WriteLogVars;
begin
     WriteLog ( Msg , Level );
     Level := 0;
     Msg   := EWriteLogVars;
end;

//Flush file buffers
procedure TLogger.SyncLogFile;
begin
     FlushFileBuffers ( LogFile.Handle );
end;

//Check if we must switch files
procedure TLogger.CheckLogSwitch;
        
     function GetLogFileName ( ATime : TDateTime ) : string;
     begin
          Result := LogDir + FormatDateTime ( Mask , ATime );
     end;
        
var
     mdel : boolean;
begin
        
     if ( LogFile = NIL ) or ( LogFileName <> GetLogFileName ( Now ) ) then
     begin
          if LogFile <> NIL then
          try
             if LogFile.Size = 0 then mdel := true
                               else mdel := false;
             SyncLogFile;
             LogFile.Free;
             LogFile := NIL;
             if mdel then DeleteFile ( LogFileName )
          except
             on E : Exception do
             begin
                  LogFile := NIL;
                  ShowMessage ( 'Can''t close old log file. Logging to file stopped.' );
             end;
          end;
                
          //Open new file
          try
           LogFileName := GetLogFileName ( Now );
           LogFile     := TFileStream.Create ( LogFileName ,fmCreate or fmShareExclusive );
           LogFile.Free;
           LogFile     := TFileStream.Create ( LogFileName ,fmOpenWrite or fmShareDenyWrite );
          except
             on E : Exception do
             begin
                  LogFile := NIL;
                  ShowMessage ( 'Can''t create new log file: ' + LogFileName );
                  LogFilename := '';
             end;
          end;
    end;
end;


//find and delete all old log files
procedure TLogger.RotateLog;
var
 FR : TSearchRec;
begin
  if FindFirst ( LogDir + '*' , faAnyFile , FR ) = 0 then
  Repeat
        if ( FR.Name <> '.' ) and ( FR.Name <> '..' ) then
        begin
             if ( Now - FileDateToDateTime ( FR.Time ) ) > KeepTime then
                DeleteFile ( LogDir + FR.Name );
        end;
  Until FindNext ( FR ) <> 0 ;
  FindClose ( FR );
end;

function TLogger.FormatMsg ( S : string ; ALevel : TLogLevel ):string;
begin
     Result := '[' + IntToStr ( ALevel ) + ']' +
     FormatDateTime ( 'yyyy-mm-dd hh.nn.ss' , Now ) + '_' + S;
end;

destructor TLogger.Free;
begin
 if LogFile <> NIL then
 begin
  if SelfLog then WriteLog ( 'Log system closed.' , 0 );
  SyncLogFile;
  LogFile.Free;
  LogFile := NIL;
 end;
end;



end.

