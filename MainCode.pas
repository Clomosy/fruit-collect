var
 Form : TclGameForm;
 ImageFullBasket , ImageBack : TClProImage;
 LabelGameName : TClProLabel;
 ButtonPlay : TClProButton;
 UnitGame : TclUnit;
procedure Play;
begin
    ButtonPlay.Enabled := false;
    UnitGame.UnitName := 'UnitToplaBakalimGame';
    UnitGame.CallerForm := Form;
    UnitGame.Run;
  
end;
procedure CloseForm;
begin
  TClProButton(Form.clFindComponent('BtnGoBack')).Click;
end;
begin
  Form := TclGameForm.Create(Self);
  Form.SetFormBGImage('https://clomosy.com/demos/FooodBg.png');

  UnitGame := TclUnit.Create;
 
  ImageFullBasket := Form.AddNewProImage(Form , 'ImageFullBasket');
  ImageFullBasket.Align := alCenter;
  clComponent.SetupComponent(ImageFullBasket , '{"ImgUrl":"https://clomosy.com/demos/FoodBasket4.png"}');
  ImageFullBasket.Width := TForm(Form).ClientWidth / 2.5;
  ImageFullBasket.Height := TForm(Form).ClientHeight / 2.5;
  ImageFullBasket.Margins.Top := 25;
  clrtMethod(ImageFullBasket , 'SendToBack');

  ImageBack := Form.AddNewProImage(Form , 'ImageBack');
  ImageBack.Align := alNone;
  clComponent.SetupComponent(ImageBack , '{"ImgUrl":"https://clomosy.com/demos/XoXback.png"}');
  ImageBack.Width := TForm(Form).ClientWidth / 6;
  ImageBack.Height := TForm(Form).ClientHeight / 12;
  Form.AddNewEvent(ImageBack , tbeOnClick , 'CloseForm');
  if(TForm(Form).ClientWidth > TForm(Form).ClientHeight)then
  begin
   ImageBack.Position.X := 10;
   ImageBack.Position.Y := 10;
  end;
  else
  begin
   ImageBack.Position.X := 10;
   ImageBack.Position.Y := 10;
  end;
  
  LabelGameName := Form.AddNewProLabel(Form , 'LabelGameName' , 'TOPLA BAKALIM');
  LabelGameName.Align := alTop;
  LabelGameName.Height := TForm(Form).ClientHeight / 4.5;
  clComponent.SetupComponent(LabelGameName , '{"TextSize":40 , "TextColor":"#ffffff" , "TextBold":"yes" , "TextVerticalAlign":"center" , "TextHorizontalAlign":"center"}');
  LabelGameName.Margins.Top := 50;

  ButtonPlay := Form.AddNewProButton(Form , 'ButtonPlay' , '');
  clComponent.SetupComponent(ButtonPlay , '{"Align":"Bottom","TextSize":25 , "TextBold":"yes" , "caption":"OYNA",
    "ImgUrl":"https://clomosy.com/demos/foodInformationBox.png","ImgFit":"yes"}');
  ButtonPlay.Text := 'OYNA';
  ButtonPlay.Height := TForm(Form).ClientHeight / 6;
  ButtonPlay.Margins.Right := Form.clWidth / 6;
  ButtonPlay.Margins.Left := Form.clWidth / 6;
  ButtonPlay.Enabled := true;
  Form.AddNewEvent(ButtonPlay , tbeOnClick , 'Play');
  
  Form.Run;
end;