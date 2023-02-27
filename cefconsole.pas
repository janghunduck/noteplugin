unit cefconsole;

interface

uses Classes,
     Windows,
     Messages,
     ceflib,
     ceffilescheme;

type
  TCustomClient = class(TCefClientOwn)
  private
    FLifeSpan: ICefLifeSpanHandler;
    FLoad: ICefLoadHandler;
    FDisplay: ICefDisplayHandler;
  protected
    function GetLifeSpanHandler: ICefLifeSpanHandler; override;
    function GetLoadHandler: ICefLoadHandler; override;
    function GetDisplayHandler: ICefDisplayHandler; override;
  public
    constructor Create; override;
  end;

  TCustomLifeSpan = class(TCefLifeSpanHandlerOwn)
  protected
    procedure OnAfterCreated(const browser: ICefBrowser); override;
    function OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
      const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
      userGesture: Boolean; var popupFeatures: TCefPopupFeatures;
      var windowInfo: TCefWindowInfo; var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean): Boolean; override;
    procedure OnBeforeClose(const browser: ICefBrowser); override;
    function DoClose(const browser: ICefBrowser): Boolean; override;
  end;

  TCustomLoad = class(TCefLoadHandlerOwn)
  protected
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame); override;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame;
      httpStatusCode: Integer); override;
  end;

  TCustomDisplay = class(TCefDisplayHandlerOwn)
  protected
    procedure OnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring); override;
    procedure OnTitleChange(const browser: ICefBrowser; const title: ustring); override;
  end;


{ WinConsole }
type

  //TWindowProc = LongInt;  //FPC
  TWindowProc = Pointer;
  WNDPROC = Pointer;

var
  Window : HWND;
  handl: ICefClient = nil;
  brows: ICefBrowser = nil;
  browserId: Integer = 0;
  navigateto: ustring = 'http://www.google.com';

  backWnd, forwardWnd, reloadWnd, stopWnd, editWnd: HWND;
  editWndOldProc: TWindowProc;
  isLoading, canGoBack, canGoForward: Boolean;

const
  MAX_LOADSTRING = 100;
  MAX_URL_LENGTH = 255;
  BUTTON_WIDTH = 72;
  URLBAR_HEIGHT = 24;

  IDC_NAV_BACK = 200;
  IDC_NAV_FORWARD = 201;
  IDC_NAV_RELOAD = 202;
  IDC_NAV_STOP = 203;

var
  setting: TCefBrowserSettings;
{ WinConsole end }

implementation

{ TCustomClient }

constructor TCustomClient.Create;
begin
  inherited;
  FLifeSpan := TCustomLifeSpan.Create;
  FLoad := TCustomLoad.Create;
  FDisplay := TCustomDisplay.Create;
end;

function TCustomClient.GetDisplayHandler: ICefDisplayHandler;
begin
  Result := FDisplay;
end;

function TCustomClient.GetLifeSpanHandler: ICefLifeSpanHandler;
begin
  Result := FLifeSpan;
end;

function TCustomClient.GetLoadHandler: ICefLoadHandler;
begin
  Result := FLoad;
end;

{ TCustomLifeSpan }

function TCustomLifeSpan.DoClose(const browser: ICefBrowser): Boolean;
begin
  if browser.Identifier = browserId then
  begin
    PostMessage(Window, WM_CLOSE, 0, 0);
    Result := True;
  end else
    Result := False;
end;

procedure TCustomLifeSpan.OnAfterCreated(const browser: ICefBrowser);
begin
  if not browser.IsPopup then
  begin
    // get the first browser
    brows := browser;
    browserId := brows.Identifier;
  end;
end;

procedure TCustomLifeSpan.OnBeforeClose(const browser: ICefBrowser);
begin
  if browser.Identifier = browserId then
    brows := nil;
end;

function TCustomLifeSpan.OnBeforePopup(const browser: ICefBrowser; const frame: ICefFrame;
  const targetUrl, targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; var popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient; var settings: TCefBrowserSettings;
  var noJavascriptAccess: Boolean): Boolean;
begin
  if targetUrl = 'about:blank' then
    result := False else
    begin
      Result := True;
      brows.MainFrame.LoadUrl(targetUrl);
    end;
end;

{ TCustomLoad }

procedure TCustomLoad.OnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  if browser.Identifier = browserId then
    isLoading := False;
end;

procedure TCustomLoad.OnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  if browser.Identifier = browserId then
  begin
    isLoading := True;
    canGoBack := browser.CanGoBack;
    canGoForward := browser.CanGoForward;
  end;
end;

{ TCustomDisplay }

procedure TCustomDisplay.OnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring);
begin
  if (browser.Identifier = browserId) and frame.IsMain then
    SetWindowTextW(editWnd, PWideChar(url));
end;

procedure TCustomDisplay.OnTitleChange(const browser: ICefBrowser;
  const title: ustring);
begin
  if browser.Identifier = browserId then
    SetWindowTextW(Window, PWideChar(title));
end;

end.
 