library stringworker;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Winapi.Messages,
  NppPlugin in 'Lib\NppPlugin.pas',
  SciSupport in 'Lib\SciSupport.pas',
  NppPluginForms in 'Lib\NppPluginForms.pas' {NppPluginForm},
  NppPluginDockingForms in 'Lib\NppPluginDockingForms.pas' {NppPluginDockingForm},
  NppSupport in 'Lib\NppSupport.pas',
  NppMenuCmdID in 'Lib\NppMenuCmdID.pas',
  FileVersionInfo in 'Lib\FileVersionInfo.pas' {stringworkerplugin in 'src\stringworkerplugin.pas',
  aboutforms in 'src\aboutforms.pas' {Form1},
  stringworkerplugin in 'src\stringworkerplugin.pas',
  aboutforms in 'src\aboutforms.pas' {AboutForm},
  jsconsoleforms in 'src\jsconsoleforms.pas' {consoleforms},
  logger in 'src\logger.pas',
  jsfunction in 'src\jsfunction.pas';

{$R *.res}

{$Include 'Lib\NppPluginInclude.pas'}


begin
  // Propagate DLL entry point to RTL
  DLLProc := @DLLEntryPoint;

  // Create plugin instance
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
