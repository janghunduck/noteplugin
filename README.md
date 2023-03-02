# notepad++ plugin(npp stringworker for only x86(win32))

Notepad++ Plugin  stringworker

## . install

1. mkdir C:\Program Files\Notepad++\plugins\stringworker
2. copy (all file in bin dir) to (mkdir)


![ex_screenshot](./img/screen.png)




## . next code cef3 javascript function return test code <br/>

    procedure Tmainfrm.jsrunbtnClick(Sender: TObject);
    var
      isRecived : Boolean;
      msg : ICefProcessMessage;
      lst : Tstringlist;
      i : integer;
    begin
      if jsedt.Text = '' then exit;

      msg := TCefProcessMessageRef.New('MSG_jsrun');
      lst:= c_splitstring(jsEdt.Text, ',');

      for i:=0 to lst.Count-1 do
      begin
         msg.ArgumentList.SetString(i, lst.Strings[i]);
      end;
      isRecived := crm.browser.SendProcessMessage(PID_RENDERER,msg);

    end;

    procedure Tmainfrm.crmProcessMessageReceived(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);
    begin
      if (message.Name = 'MSG_jsrun') or
         (message.Name = 'MSG_content') then
      begin
        logmemo.Lines.Add('[CEF3-'+ message.Name +']:' + message.ArgumentList.GetString(0))
      end;

      Result := True;
    end;

    { TCustomRenderProcessHandler }

    function TCustomRenderProcessHandler.OnProcessMessageReceived(
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage): Boolean;
    var
      gobj, jsfunc, arg,retval : ICefv8Value;
      context: ICefv8Context;
      args : TCefv8ValueArray;
      msg: ICefProcessMessage;
      isRecived: boolean;
      i : integer;
    begin

      if (message.Name = 'MSG_jsrun') or
         (message.Name = 'MSG_content') then
      begin
        context := browser.MainFrame.GetV8Context;
        context.Enter;
        //context.Eval()

        gobj := context.GetGlobal;
        jsfunc := gobj.GetValueByKey(message.ArgumentList.GetString(0));  // function name
        if jsfunc = nil then context.Exit;

        setlength(args, message.ArgumentList.GetSize-1);
        for i:=1 to message.ArgumentList.GetSize-1 do
        begin
          arg := TCefv8ValueRef.NewString(message.ArgumentList.GetString(i));
          args[i-1] := arg;
        end;
        retval := jsfunc.ExecuteFunction(nil,args);
        context.Exit;

        // retval 의 형 확인이 필요함.

        {  browser send }
        msg := TCefProcessMessageRef.New(message.Name);
        msg.ArgumentList.SetString(0, retval.GetStringValue);
        isRecived := browser.SendProcessMessage(PID_BROWSER, msg);

      end;
    end;



    procedure Tmainfrm.filebtnClick(Sender: TObject);
    var
      isRecived : Boolean;
      msg : ICefProcessMessage;
      lst : Tstringlist;
      i : integer;

      strings: Tstringlist;
      strmodules: string;
      script : string;
    begin
      rtnmemo.Lines.Clear;
      logmemo.Lines.Clear;

      if opendlg.Execute then
      begin
        fileedt.Text := opendlg.FileName;
        if fileedt.Text = '' then exit;

        strings := Tstringlist.Create;
        strings.LoadFromFile(opendlg.FileName);

        msg := TCefProcessMessageRef.New('MSG_content');
        lst := c_splitstring('cef3_file,'+ opendlg.FileName, ',');  //function rv_file(val){
        for i:=0 to lst.Count-1 do
           msg.ArgumentList.SetString(i, lst.Strings[i]);
        isRecived := crm.browser.SendProcessMessage(PID_RENDERER,msg);

        lst := c_splitstring('cef3_contents,' + strings.Text, ',');
        for i:=0 to lst.Count-1 do
           msg.ArgumentList.SetString(i, lst.Strings[i]);
        isRecived := crm.browser.SendProcessMessage(PID_RENDERER,msg);

        msg.ArgumentList.SetString(0, 'cef3_scriptmodules');
        isRecived := crm.browser.SendProcessMessage(PID_RENDERER,msg);
    {
        for i:=0 to strings.Count-1 do
        begin
          rtnmemo.Lines.Add(sendcontent(strings[i]));    // send

          if (i = strings.Count-1) then
          begin
            strmodules := sendcontent('EOF');            // send end of file
            fModules := c_splitstring (strmodules, ',');
            rtnmemo.Lines.Add('next parsing files: ' + strmodules);
          end;
        end;
      }
         // html 안의 scipt part를 parsing 한다.
        //script := 'function sendscriptparse() { status = rv_scriptparse(); } sendscriptparse();';
        //rtnmemo.Lines.Text := runscript(script);
     {
        logmemo.Lines.Text := sendlog();
        sendlogdelete();
            }
      end;
    end;
