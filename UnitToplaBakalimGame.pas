var
 GameForm : TclGameForm;
 PanelTop,PanelCenter : TclProPanel;
 
 ImageBack,ImageTime,ImageScore,ImageNutrients,ImageBesinTikla,
ImageBasket,ImageLeft,ImageRight,ImageY1,ImageY2,ImageAnm: TClProImage;
 
 LblPlayerName,LblTime,LblScore,LblImageY1,LblImageY2,LblConnection,LblEndScore : TClProLabel;
 
 Score,Time,RandomHealthyIndex,RandomUnHealthyIndex,Distance1,Distance2,
PlayerDirection,ImageY1Speed,ImageY2Speed,PlayerSpeed: Integer;
 
 TimerGame , TimerClock,sendTimer : TCLTimer;
 MqttGame : TclMQTT;
 AnimationStart : Boolean;
 Vibrate : TclDeviceManager;
 FormExe : TclGameForm;
 UsersList : TClProListView;
 DesignerListPanel : TClProListViewDesignerPanel;
 LabelConnection : TClProLabel;
 BtnSira,BtnOyuncuPuani,BtnOyuncuAdi: TClProButton;
 MqttEkran : TclMQTT;
 Qry : TCLJSONQuery;
 nameArray,guidArray,ScoreArray,ListFoods : TclArrayString;
 ImgBack : TClProImage;
 JsonStr , GelenIsim , GelenGUID : String;
 GelenScore: String;
 ListContainer : TclStringList;

procedure CloseForm;
  begin
    CallerForm.clShow;
    ButtonPlay.Enabled := True;
    TClProButton(GameForm.clFindComponent('BtnGoBack')).Click;
  end;

procedure OpenFoodImage;
  begin
   if(ImageNutrients.Visible = False)then
   begin
     ImageNutrients.Visible := true;
   end;
   else
   begin
     ImageNutrients.Visible := False;
   end;
  end;
  
procedure MqttGameChanged;
  begin
    if not MqttGame.Connected then
    begin
      MqttGame.Connect;
      LblConnection.Text := 'Not Connected';
      clComponent.SetupComponent(LblConnection , '{"TextColor":"#DA1212"}');
    end;
    else
    begin
      LblConnection.Text := 'Connected';
      clComponent.SetupComponent(LblConnection , '{"TextColor":"#00A9FF"}');
    end;
  end;

procedure FoodPoint;
  
  begin
    Case RandomHealthyIndex Of
     0:
     begin
      LblImageY1.Text := '2';
     end;
     1:
     begin
      LblImageY1.Text := '4';
     end;
     2:
     begin
      LblImageY1.Text := '6';
     end;
     3:
     begin
      LblImageY1.Text := '8';
     end;
     4:
     begin
      LblImageY1.Text := '10';
     end;
     5:
     begin
      LblImageY1.Text := '12';
     end;
     6:
     begin
      LblImageY1.Text := '14';
     end;
     7:
     begin
      LblImageY1.Text := '16';
     end;
     8:
     begin
      LblImageY1.Text := '18';
     end;
     9:
     begin
      LblImageY1.Caption := '20';
     end;
    end;
    Case RandomUnHealthyIndex Of
     10:
     begin
      LblImageY2.Caption := '-2';
     end;
     11:
     begin
      LblImageY2.Caption := '-4';
     end;
     12:
     begin
      LblImageY2.Caption := '-6';
     end;
     13:
     begin
      LblImageY2.Caption := '-8';
     end;
     14:
     begin
      LblImageY2.Caption := '-10';
     end;
     15:
     begin
      LblImageY2.Caption := '-12';
     end;
     16:
     begin
      LblImageY2.Caption := '-14';
     end;
     17:
     begin
      LblImageY2.Text := '-16';
     end;
     18:
     begin
      LblImageY2.Text := '-18';
     end;
     19:
     begin
      LblImageY2.Text := '-20';
     end;
    end;
  end;
  
procedure FillBasket;
  
  begin
   if(TimerClock.Enabled = true)then
   begin
    if(Score > 0) and(Score < 150)then
    begin
      clComponent.SetupComponent(ImageBasket , '{"ImgUrl":"https://clomosy.com/demos/foodBasket.png"}');
      TimerGame.Interval := 5;
      clComponent.SetupComponent(LblScore , '{"TextSize":20}');
    end;
    if(Score > 150) and(Score < 300)then
    begin
      clComponent.SetupComponent(ImageBasket , '{"ImgUrl":"https://clomosy.com/demos/foodBasket2.png"}');
      TimerGame.Interval := 3;
      ImageY1Speed := 7;
      ImageY2Speed := 6;
      PlayerSpeed := 7;
    end;
    if(Score > 300)then
    begin
      TimerGame.Interval := 1;
      clComponent.SetupComponent(ImageBasket , '{"ImgUrl":"https://clomosy.com/demos/foodBasket3.png"}');
      if(Score > 300) and (Score < 450)then
      begin
        ImageY1Speed := 8;
        ImageY2Speed := 7;
        PlayerSpeed := 8;
        ImageY1.Width := TForm(GameForm).ClientWidth / 6;
        ImageY1.Height := TForm(GameForm).ClientHeight / 12; 
        ImageY2.Width := TForm(GameForm).ClientWidth / 5;
        ImageY2.Height := TForm(GameForm).ClientHeight / 10; 
      end;
      if(Score > 450) and (Score < 600)then
      begin
        ImageY1Speed := 8;
        ImageY2Speed := 9;
        PlayerSpeed := 9;
        ImageBasket.Width := TForm(GameForm).ClientWidth / 3;
      end;
      if(Score > 600) and (Score < 750)then
      begin
        ImageY1Speed := 9;
        ImageY2Speed := 7;
        PlayerSpeed := 9
      end;
      if(Score > 750) and (Score < 1000)then
      begin
        ImageY1Speed := 10;
        ImageY2Speed := 8;
        PlayerSpeed := 10;
      end;
      if(Score > 1000)then
      begin
        ImageY1Speed := 11;
        ImageY2Speed := 9;
        PlayerSpeed := 10;
        clComponent.SetupComponent(LblScore , '{"TextSize":18}');
        if(Score > 1000)and(Score < 10000)then
        begin
         clComponent.SetupComponent(LblScore , '{"TextSize":16}');
        end;
        else if(Score > 10000)and(Score < 100000)then
        begin
         clComponent.SetupComponent(LblScore , '{"TextSize":14}');
        end;
      end;
    end;
   end;
  end;

procedure ScoreAnimation;
  begin
    if(AnimationStart = true)then
    begin
      ImageAnm.Visible := False;
      if(ImageAnm.Position.Y < 50)then
      begin
        ImageAnm.Visible := False;
        ImageAnm.Position.Y := 250;
        AnimationStart := False;
      end;
      else
      begin
       ImageAnm.Visible := true;
       ImageAnm.Position.Y := ImageAnm.Position.Y - 5; 
      end;
    end;
  end;
  
procedure FoodCollection;
  
  begin
    Distance1 := Sqrt(Sqr(ImageBasket.Position.X - ImageY1.Position.X) + Sqr(ImageBasket.Position.Y - ImageY1.Position.Y));
    Distance2 := Sqrt(Sqr(ImageBasket.Position.X - ImageY2.Position.X) + Sqr(ImageBasket.Position.Y - ImageY2.Position.Y));
    if(Distance1 > 0) and (Distance1 <= 45)then
    begin
      AnimationStart := true;
      Case RandomHealthyIndex Of
       0:
       begin
        Score := Score + 2;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/cheese.png"}');
       end;
       1:
       begin
        Score := Score + 4;
       LblScore.Text := IntToStr(Score);
       clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/meat.png"}');
       end;
       2:
       begin
        Score := Score + 6;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/milk.png"}');
       end;
       3:
       begin
        Score := Score + 8;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/fish.png"}');
       end;
       4:
       begin
        Score := Score + 10;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/sweetcorn.png"}');
       end;
       5:
       begin
        Score := Score + 12;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/watermelon.png"}');
       end;
       6:
       begin
        Score := Score + 14;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/apple.png"}');
       end;
       7:
       begin
        Score := Score + 16;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/carrot.png"}');
       end;
       8:
       begin
        Score := Score + 18;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/strawberry.png"}');
       end;
       9:
       begin
        Score := Score + 20;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/aubergine.png"}');
       end;
      end;
      ImageY1.Position.Y := 50;
      ImageY1.Position.X := clMath.GenerateRandom(60 , TForm(GameForm).ClientWidth - 60);
      RandomHealthyIndex := clMath.GenerateRandom(0,9);
      clComponent.SetupComponent(ImageY1 , '{"ImgUrl":"'+ListFoods.GetItem(RandomHealthyIndex)+'"}');
      FillBasket;
    end;
    if(Distance2 > -10) and (Distance2 <= 45)then
    begin
      AnimationStart := true;
      Case RandomUnHealthyIndex Of
       10:
       begin
        Score := Score - 2;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/noddle.png"}');
       end;
       11:
       begin
        Score := Score - 4;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/toast.png"}');
       end;
       12:
       begin
        Score := Score - 6;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/hamburger.png"}');
       end;
       13:
       begin
        Score := Score - 8;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/chips.png"}');
       end;
       14:
       begin
        Score := Score - 10;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/fruitJuice.png"}');
       end;
       15:
       begin
        Score := Score - 12;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/iceCream.png"}');
       end;
       16:
       begin
        Score := Score - 14;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/chocolate.png"}');
       end;
       17:
       begin
        Score := Score - 16;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/pie.png"}');
       end;
       18:
       begin
        Score := Score - 18;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/cake.png"}');
       end;
       19:
       begin
        Score := Score - 20;
        LblScore.Text := IntToStr(Score);
        clComponent.SetupComponent(ImageAnm , '{"ImgUrl":"https://clomosy.com/demos/topitop.png"}');
       end;
      end;
      if(Score < 0)then
      begin
       Score := 0;
       LblScore.Text := IntToStr(Score);
      end;
      ImageY2.Position.Y := 50;
      ImageY2.Position.X := clMath.GenerateRandom(60 , TForm(GameForm).ClientWidth - 60);
      RandomUnHealthyIndex := clMath.GenerateRandom(10,20);
      clComponent.SetupComponent(ImageY2 , '{"ImgUrl":"'+ListFoods.GetItem(RandomUnHealthyIndex)+'"}');
      FillBasket;
    end;
  end;

procedure CreateGameForm
  begin
    GameForm := TclGameForm.Create(Self);
    GameForm.SetFormBGImage('https://clomosy.com/demos/fooodBg.png');
    GameForm.AddNewEvent(GameForm,tbeOnFormCloseQuery,'CloseForm');
    
    Vibrate := TclDeviceManager.Create;
    
    Time := 60;
    Score := 0;
  
    ImageY1Speed := 6;
    ImageY2Speed := 5;
    PlayerSpeed := 6;
    
    ListFoods := TclArrayString.Create;
    //Sağlıklılar
    ListFoods.Add('https://clomosy.com/demos/cheese.png');
    ListFoods.Add('https://clomosy.com/demos/meat.png');
    ListFoods.Add('https://clomosy.com/demos/milk.png');
    ListFoods.Add('https://clomosy.com/demos/fish.png');
    ListFoods.Add('https://clomosy.com/demos/sweetcorn.png');
    ListFoods.Add('https://clomosy.com/demos/watermelon.png');
    ListFoods.Add('https://clomosy.com/demos/apple.png');
    ListFoods.Add('https://clomosy.com/demos/carrot.png');
    ListFoods.Add('https://clomosy.com/demos/strawberry.png');
    ListFoods.Add('https://clomosy.com/demos/aubergine.png');
    //Sağlıksızlar : 
    ListFoods.Add('https://clomosy.com/demos/noddle.png');
    ListFoods.Add('https://clomosy.com/demos/toast.png');
    ListFoods.Add('https://clomosy.com/demos/hamburger.png');
    ListFoods.Add('https://clomosy.com/demos/chips.png');
    ListFoods.Add('https://clomosy.com/demos/fruitJuice.png');
    ListFoods.Add('https://clomosy.com/demos/iceCream.png');
    ListFoods.Add('https://clomosy.com/demos/chocolate.png');
    ListFoods.Add('https://clomosy.com/demos/pie.png');
    ListFoods.Add('https://clomosy.com/demos/cake.png');
    ListFoods.Add('https://clomosy.com/demos/topitop.png');
    
    RandomHealthyIndex := clMath.GenerateRandom(0 , 9);
    RandomUnHealthyIndex := clMath.GenerateRandom(10,20);
    
    PanelTop := GameForm.AddNewProPanel(GameForm , 'PanelTop');
    PanelTop.Align := alMostTop;
    PanelTop.Margins.Left := 10;
    PanelTop.Margins.Right := 10;
    PanelTop.Margins.top := -10;
    PanelTop.Height := TForm(GameForm).ClientHeight / 6;
    //clComponent.SetupComponent(PanelTop , '{"BackgroundColor":"#000000"}');
    
    PanelCenter := GameForm.AddNewProPanel(GameForm , 'PanelCenter');
    PanelCenter.Align := alCenter;
    PanelCenter.Margins.Left := 10;
    PanelCenter.Margins.Right := 10;
    PanelCenter.Margins.Top := 250;
    PanelCenter.Height := TForm(GameForm).ClientHeight / 8;
    PanelCenter.Width := TForm(GameForm).ClientWidth;
    //clComponent.SetupComponent(PanelCenter , '{"BackgroundColor":"#000000"}');
    
    ImageBack := GameForm.AddNewProImage(PanelTop, 'ImageBack');
    ImageBack.Align := alMostLeft;
    ImageBack.Width := TForm(GameForm).ClientWidth / 7;
    ImageBack.Height := TForm(GameForm).ClientHeight / 7;
    ImageBack.Margins.Left := 5;
    clComponent.SetupComponent(ImageBack , '{"ImgUrl":"https://clomosy.com/demos/XoXback.png"}');
    GameForm.AddNewEvent(ImageBack , tbeOnClick , 'CloseForm');
    
    ImageNutrients := GameForm.AddNewProImage(GameForm , 'ImageNutrients');
    ImageNutrients.Align := alClient;
    clComponent.SetupComponent(ImageNutrients , '{"ImgUrl":"https://clomosy.com/demos/FoodPointsTable.png","RoundWidth":10 , "RoundHeight":10}');
    ImageNutrients.Visible := False;
    ImageNutrients.Margins.Left := 20;
    ImageNutrients.Margins.Right := 20;
    GameForm.AddNewEvent(ImageNutrients , tbeOnClick , 'OpenFoodImage');
    
    ImageBesinTikla := GameForm.AddNewProImage(PanelTop , 'ImageBesinTikla');
    ImageBesinTikla.Align := alMostRight;
    clComponent.SetupComponent(ImageBesinTikla , '{"ImgUrl":"https://clomosy.com/demos/RopeQuestionMark.png"}');
    ImageBesinTikla.Width := PanelTop.Width / 8;
    ImageBesinTikla.Height := PanelTop.Height / 4;
    GameForm.AddNewEvent(ImageBesinTikla , tbeOnClick , 'OpenFoodImage');
    
    ImageBasket := GameForm.AddNewProImage(GameForm , 'ImageBasket');
    ImageBasket.Align := alNone;
    ImageBasket.Position.Y := TForm(GameForm).ClientHeight - 100;
    ImageBasket.Position.X := TForm(GameForm).ClientWidth / 3;
    ImageBasket.Width := TForm(GameForm).ClientWidth / 4;
    ImageBasket.Height := TForm(GameForm).ClientHeight / 8;
    clComponent.SetupComponent(ImageBasket , '{"ImgUrl":"https://clomosy.com/demos/foodBasket.png"}');
    clRTMethod(ImageBasket, 'BringToFront');
  
    ImageTime := GameForm.AddNewProImage(PanelTop , 'ImageTime');
    clComponent.SetupComponent(ImageTime , '{"ImgUrl":"https://clomosy.com/demos/foodInformationBox.png"}');
    ImageTime.Align := alCenter;
    ImageTime.Width := PanelTop.Width / 3.25;
    ImageTime.Height := PanelTop.Height;
    ImageTime.Margins.Right := 25;
  
    ImageScore := GameForm.AddNewProImage(PanelTop , 'ImageScore');
    clComponent.SetupComponent(ImageScore , '{"ImgUrl":"https://clomosy.com/demos/foodInformationPointBox.png"}');
    ImageScore.Align := alMostRight;
    ImageScore.Width := PanelTop.Width / 6;
    ImageScore.Height := PanelTop.Height;
    ImageScore.Margins.Right := 25;
  
    ImageLeft := GameForm.AddNewProImage(PanelCenter , 'ImageLeft');
    ImageLeft.Align := alLeft;
    ImageLeft.Margins.Left := 10;
    clComponent.SetupComponent(ImageLeft , '{"ImgUrl":"https://clomosy.com/demos/RopeLeft.png"}');
    GameForm.AddNewEvent(ImageLeft , tbeOnClick , 'PlayerMoveLeft');
  
    ImageRight := GameForm.AddNewProImage(PanelCenter , 'ImageRight');
    ImageRight.Align := alRight;
    ImageRight.Margins.Right := 10;
    clComponent.SetupComponent(ImageRight , '{"ImgUrl":"https://clomosy.com/demos/RopeRight.png"}');
    GameForm.AddNewEvent(ImageRight , tbeOnClick , 'PlayerMoveRight');
  
    ImageY1 := GameForm.AddNewProImage(GameForm , 'ImageY1');
    ImageY1.Align := alNone;
    clComponent.SetupComponent(ImageY1 , '{"Width":100}');
    ImageY1.Width := TForm(GameForm).ClientWidth / 6;
    ImageY1.Height := TForm(GameForm).ClientHeight / 12; 
    ImageY1.Position.Y := 50;
    clRTMethod(ImageY1, 'SendToBack');
    RandomHealthyIndex := clMath.GenerateRandom(0,9);
    clComponent.SetupComponent(ImageY1 , '{"ImgUrl":"'+ListFoods.GetItem(RandomHealthyIndex)+'"}');
  
    ImageY2 := GameForm.AddNewProImage(GameForm , 'ImageY2');
    ImageY2.Align := alNone;
    clComponent.SetupComponent(ImageY2 , '{"Width":100}');
    ImageY2.Width := TForm(GameForm).ClientWidth / 6;
    ImageY2.Height := TForm(GameForm).ClientHeight / 12; 
    ImageY2.Position.Y := 50;
    clRTMethod(ImageY2, 'SendToBack');
    RandomUnHealthyIndex := clMath.GenerateRandom(10,20);
    clComponent.SetupComponent(ImageY2 , '{"ImgUrl":"'+ListFoods.GetItem(RandomUnHealthyIndex)+'"}');
  
    LblTime := GameForm.AddNewProLabel(ImageTime , 'LblTime' , ''+IntToStr(Time)+'');
    LblTime.Align := alCenter;
    clComponent.SetupComponent(LblTime , '{"TextBold":"yes" , "TextSize":25 , "TextVerticalAlign":"center" , "TextHorizontalAlign":"center"}');
  
    LblScore := GameForm.AddNewProLabel(ImageScore , 'LblScore' , ''+IntToStr(Score)+'');
    LblScore.Align := alCenter;
    LblScore.Properties.AutoSize := True;
    clComponent.SetupComponent(LblScore , '{"TextBold":"yes" , "TextSize":20 , "TextVerticalAlign":"center" , "TextHorizontalAlign":"center"}');
  
    TimerGame := GameForm.AddNewTimer(GameForm , 'TimerGame' , 4);
    TimerGame.Interval := 5;
    TimerGame.Enabled := True;
    GameForm.AddNewEvent(TimerGame , tbeOnTimer , 'GameOperations');
  
    TimerClock := GameForm.AddNewTimer(GameForm , 'TimerClock' , 1000);
    GameForm.AddNewEvent(TimerClock , tbeOnTimer , 'TimePass');
    TimerClock.Enabled := True;
  
    LblConnection := GameForm.AddNewProLabel(GameForm , 'LblConnection' , 'NOT CONNECTED');
    clComponent.SetupComponent(LblConnection , '{"TextSize":20 ,  "TextBold":"yes" , "TextColor":"#FFFFFF" , "TextHorizontalAlign":"center" , "TextVerticalAlign":"top"}');
    LblConnection.Align := alMostTop;
  
    LblPlayerName := GameForm.AddNewProLabel(ImageBasket , 'LblPlayerName' , Clomosy.AppUserDisplayName);
    LblPlayerName.Align := alCenter;
    LblPlayerName.Margins.Bottom := 100;
    clComponent.SetupComponent(LblPlayerName , '{"TextSize":20 ,  "TextBold":"yes" , "TextColor":"#ffffff" , "TextHorizontalAlign":"center" , "TextVerticalAlign":"center"}');
  
    LblImageY1 := GameForm.AddNewProLabel(ImageY1 , 'LblImageY1' , '');
    LblImageY1.Align := alCenter;
    LblImageY1.Margins.Bottom := 90;
    LblImageY1.Height := 200;
    clComponent.SetupComponent(LblImageY1 , '{"TextSize":35 ,  "TextBold":"yes" , "TextColor":"#539165" , "TextHorizontalAlign":"center" , "TextVerticalAlign":"center"}');
  
    LblImageY2 := GameForm.AddNewProLabel(ImageY2 , 'LblImageY2' , '');
    LblImageY2.Align := alCenter;
    LblImageY2.Margins.Bottom := 90;
    LblImageY2.Height := 200;
    clComponent.SetupComponent(LblImageY2 , '{"TextSize":35 ,  "TextBold":"yes" , "TextColor":"#C51605" , "TextHorizontalAlign":"center" , "TextVerticalAlign":"center"}');
  
    ImageAnm := GameForm.AddNewProImage(GameForm , 'ImageAnm');
    ImageAnm.Align := alNone;
    ImageAnm.Visible := False;
    ImageAnm.Position.Y := 250;
    ImageAnm.Position.X := 250;
    ImageAnm.Width := TForm(GameForm).ClientWidth / 10;
    ImageAnm.Height := TForm(GameForm).ClientHeight / 20;
  
    MqttGame := GameForm.AddNewMQTTConnection(GameForm , 'MqttGame');
    GameForm.AddNewEvent(MqttGame , tbeOnMQTTStatusChanged , 'MqttGameChanged');
    MqttGame.Channel := 'Room';
    MqttGame.Connect;
  
    LblEndScore := GameForm.AddNewProLabel(GameForm , 'LblEndScore' , 'DENEME');
    clComponent.SetupComponent(LblEndScore , '{"TextSize":30 ,  "TextBold":"yes" , "TextColor":"#ffffff" , "TextHorizontalAlign":"center" , "TextVerticalAlign":"center"}');
    LblEndScore.Align := alCenter;
    LblEndScore.Visible := False;
    LblEndScore.Width := TForm(GameForm).ClientWidth;
    LblEndScore.Height := TForm(GameForm).ClientHeight / 6;
  
    GameForm.Run;
  end;

procedure FoodPosition;
  begin
    if(ImageY1.Position.Y) > TForm(GameForm).ClientHeight then
    begin
      ImageY1.Position.Y := 50; 
      ImageY1.Position.X := clMath.GenerateRandom(80 , TForm(GameForm).ClientWidth - 80);
      RandomHealthyIndex := clMath.GenerateRandom(0,9);
      clComponent.SetupComponent(ImageY1 , '{"ImgUrl":"'+ListFoods.GetItem(RandomHealthyIndex)+'"}');
    end
    else
    begin
      ImageY1.Position.Y := ImageY1.Position.Y + ImageY1Speed;
    end;
    if(ImageY2.Position.Y) > TForm(GameForm).ClientHeight then
    begin
      ImageY2.Position.Y := 50;
      ImageY2.Position.X := clMath.GenerateRandom(80 , TForm(GameForm).ClientWidth - 80);
      RandomUnHealthyIndex := clMath.GenerateRandom(10,20);
      clComponent.SetupComponent(ImageY2 , '{"ImgUrl":"'+ListFoods.GetItem(RandomUnHealthyIndex)+'"}');
    end;
    else
    begin
      ImageY2.Position.Y := ImageY2.Position.Y + ImageY2Speed;
    end;
  end;
  
procedure PlayerMoveLeft;
  begin
    PlayerDirection := -1;
  end;
  
procedure PlayerMoveRight;
  begin
    PlayerDirection := 1;
  end;

procedure PlayerMove;
  begin
    if(TimerGame.Enabled = true)then
    begin
      if(PlayerDirection = -1)then
      begin
        ImageBasket.Position.X := ImageBasket.Position.X - PlayerSpeed;
        if(ImageBasket.Position.X) < 0 then
        begin
          ImageBasket.Position.X := 0;
        end;
      end;
      else if(PlayerDirection = 1)then
      begin
        ImageBasket.Position.X := ImageBasket.Position.X + PlayerSpeed;
        if(ImageBasket.Position.X + ImageBasket.Width) > TForm(GameForm).ClientWidth then
        begin
          ImageBasket.Position.X := TForm(GameForm).ClientWidth - ImageBasket.Width;
        end;
      end;
    end;
  end;

procedure TimePass;
  begin
    if(Time > 0)then
    begin
      Time := Time - 1;
      LblTime.Text := IntToStr(Time);
    end;
    else
    begin
      //MqttGame.Send(Clomosy.AppUserDisplayName + '+' + IntToStr(Score) + '+' + Clomosy.AppUserGUID); 
      TimerGame.Enabled := False;
      TimerClock.Enabled := False;
      ImageY1.Visible := False;
      ImageY2.Visible := False;
      ImageAnm.Visible := False;
      //ShowMessage('Süreniz Doldu !  '); 
      Vibrate.Vibrate(300);
      ImageBasket.Visible := False;
      PanelCenter.Visible := False;
      LblEndScore.Visible := True;
      LblEndScore.Text := 'Skorunuz : ' + IntToStr(Score);
      //Score := 0;
      LblScore.Text := IntToStr(Score);
      ImageNutrients.Visible := False;
      
      sendTimer := GameForm.AddNewTimer(GameForm,'sendTimer',1000);
      sendTimer.Enabled := True;
      GameForm.AddNewEvent(sendTimer,tbeOnTimer,'SendMsj');
    end;
  end;

procedure SendMsj;
  begin
    if MqttGame.ReceivedMessage = Clomosy.AppUserGUID then
      begin
        ShowMessage('Gönderen:PC ----- Skorunuz Alındı');
        sendTimer.Enabled := False;
      end;
    else
      begin
        MqttGame.Send(Clomosy.AppUserDisplayName + '+' + IntToStr(Score) + '+' + Clomosy.AppUserGUID);
      end;
  end;

procedure GameOperations;
  begin
    PlayerMove;
    FoodPosition;
    FoodCollection;
    FoodPoint;
    ScoreAnimation;
  end;
  
procedure MqttEkranChanged;
  begin
    if(not MqttEkran.Connected)then
      begin
        MqttEkran.Connect;
        LabelConnection.Text := 'Not Connected';
        clComponent.SetupComponent(LabelConnection , '{"TextColor":"#DA1212"}');
      end;
    
    else
      begin
        LabelConnection.Text := 'Connected';
        clComponent.SetupComponent(LabelConnection , '{"TextColor":"#0079FF"}');
      end;
  end;
  
procedure SortArr;
  var
    X, Y: Integer;
    TempName,TempScore,TempGuid: string;
  
  begin
    try
      for X := 0 to  ScoreArray.Count - 1 do
      begin
        for Y := X + 1 to ScoreArray.Count - 1 do
        begin
          // sıralama: Büyükten küçüğe doğru sıralama yapacak  
          if StrToInt(ScoreArray.GetItem(X)) < StrToInt(ScoreArray.GetItem(Y)) then
          begin
            // Swap scores
            TempScore := ScoreArray.GetItem(X);
            ScoreArray.SetItem(X, ScoreArray.GetItem(Y));
            ScoreArray.SetItem(Y, TempScore);
  
            // Swap names
            TempName := NameArray.GetItem(X);
            NameArray.SetItem(X, NameArray.GetItem(Y));
            NameArray.SetItem(Y, TempName);
  
            // Swap GUIDs
            TempGuid := GuidArray.GetItem(X);
            GuidArray.SetItem(X, GuidArray.GetItem(Y));
            GuidArray.SetItem(Y, TempGuid);
          end;
        end;
      end;
    
    except
      begin
        ShowMessage('Exception Class: '+LastExceptionClassName+' Exception Message: '+LastExceptionMessage);
      end;
    
    end;
  end;

procedure Dnm;
  var
   J : Integer;
  begin
    ShowMessage(IntToStr(nameArray.Count));
    For J := 0 to nameArray.Count - 1 do
    begin
     ShowMessage(nameArray.GetItem(J));
    end;
  end;
  
procedure MqttScreenPublish;
  var
   J , X: Integer;
   OldScore : String;
   ScoreState : Boolean;
  begin 
    try
      try
        if(MqttEkran.ReceivedAlRight) then
        begin
          
          ListContainer.Delimiter := '+';
          ListContainer.DelimitedText := MqttEkran.ReceivedMessage; 
  
          GelenIsim := ListContainer[0];
          GelenScore := ListContainer[1];
          GelenGUID := ListContainer[2];
          MqttEkran.Send(GelenGUID);
         //ShowMessage('GelenIsim :'+ GelenIsim);
          //ShowMessage('GelenScore :'+ GelenScore);
         //ShowMessage('GelenGUID :'+ GelenGUID);
          ScoreState := True; //oyuncu kontrolü
          
          //ShowMessage(ScoreState);
          
          For X := 0 to ScoreArray.Count - 1 do
            begin
              if(guidArray.GetItem(X) = GelenGUID)then
                begin
                  OldScore := ScoreArray.GetItem(X);
                 // ShowMessage('OldScore: '+ OldScore);
                 // ShowMessage('eşitler girdi');
                  ScoreState := False;
                  
                  if StrToInt(GelenScore) > StrToInt(OldScore) then 
                    
                    begin
                      //ShowMessage('GelenScore > OldScore');
                      ScoreArray.SetItem(X,GelenScore);
                      break;
                    end;
                end;
            end;
    
          if ScoreState then
          begin
  
            nameArray.Add(GelenIsim);
            guidArray.Add(GelenGUID);
            ScoreArray.Add(GelenScore);
            
          end;
          
          JsonStr := '';
          JsonStr := '[';
          SortArr;
          For J := 0 to nameArray.Count - 1 do
          begin
            
            JsonStr := JsonStr + '{"BtnSira":'+IntToStr(J + 1)+'';
            JsonStr := JsonStr + ',"BtnOyuncuAdi":"'+nameArray.GetItem(J)+'"';
            if J = nameArray.Count - 1 then
            begin
              JsonStr := JsonStr + ',"BtnOyuncuPuani":'+ScoreArray.GetItem(J)+'}';
            end;
            else
            begin
              JsonStr := JsonStr + ',"BtnOyuncuPuani":'+ ScoreArray.GetItem(J)+'},';
            end;
          end;
          JsonStr := JsonStr + ']';
          
          Qry := Clomosy.ClDataSetFromJSON(JsonStr);
          UsersList.clLoadProListViewDataFromDataset(Qry);
          
        end;
      
      except
        ShowMessage('Exception Class: '+LastExceptionClassName+' Exception Message: '+LastExceptionMessage);
      end;
    
    finally
    end;
  end;

procedure CloseForm2;
  begin
    CallerForm.clShow;
    ButtonPlay.Enabled := True;
    TClProButton(FormExe.clFindComponent('BtnGoBack')).Click;
  end;
  
procedure CreateExeForm;
  begin
    FormExe := TclGameForm.Create(Self);
    FormExe.SetFormBGImage('https://clomosy.com/demos/fooodBg.png');
  
    LabelConnection := FormExe.AddNewProLabel(FormExe , 'LabelConnection' , 'NOT CONNECTED');
    clComponent.SetupComponent(LabelConnection , '{"TextSize":20 ,  "TextBold":"yes" , "TextColor":"#000000" , "TextHorizontalAlign":"right" , "TextVerticalAlign":"center"}');
    LabelConnection.Align := alTop;
    LabelConnection.Margins.Top := 25;
    LabelConnection.Margins.right := 20;
    FormExe.AddNewEvent(LabelConnection , tbeOnClick , 'Dnm');
  
    UsersList := FormExe.AddNewProListView(FormExe , 'UsersList');
    UsersList.Align := alTop;
    UsersList.Height := TForm(FormExe).ClientHeight / 1.25;
    UsersList.Properties.ItemSpace := 10;
    clComponent.SetupComponent(UsersList,'{"MarginBottom":20,"MarginTop":20,"MarginRight":20,"MarginLeft":20,"ItemHeight" :75,"ItemWidth":75,"BackgroundColor":"#557C55", "RoundWidth":15, "RoundHeight":15}');
  
    DesignerListPanel := FormExe.AddNewProListViewDesignerPanel(UsersList , 'DesignerListPanel');
    UsersList.SetDesignerPanel(DesignerListPanel);
    clComponent.SetupComponent(DesignerListPanel , '{"BackgroundColor":"#A6CF98" , "RoundHeight":10 , "RoundWidth":10}');
  
    Qry := TCLJSONQuery.Create(nil);
  
    BtnOyuncuAdi := FormExe.AddNewProButton(DesignerListPanel , 'BtnOyuncuAdi' , '');
    clComponent.SetupComponent(BtnOyuncuAdi , '{"TextSize":20 ,  "TextBold":"yes" ,  "ImgUrl":"https://clomosy.com/demos/foodInformationBox.png"}');
    BtnOyuncuAdi.Align := alCenter;
    BtnOyuncuAdi.Width := 200;
    BtnOyuncuAdi.Height := 65;
    DesignerListPanel.AddPanelObject(BtnOyuncuAdi , clText1);
  
    BtnSira := FormExe.AddNewProButton(DesignerListPanel , 'BtnSira' , '');
    BtnSira.Margins.Top := 3;
    BtnSira.Margins.Bottom := 3;
    BtnSira.Margins.Left := 10;
    BtnSira.Margins.Right := 10;
    BtnSira.Align := alLeft;
    clComponent.SetupComponent(BtnSira , '{"ImgUrl":"https://clomosy.com/demos/foodInformationPointBox.png" , "TextSize":30 , "TextBold":"yes"}');
    DesignerListPanel.AddPanelObject(BtnSira , clText3);
  
    BtnOyuncuPuani := FormExe.AddNewProButton(DesignerListPanel , 'BtnOyuncuPuani' , '');
    clComponent.SetupComponent(BtnOyuncuPuani , '{"TextSize":30 ,  "ImgUrl":"https://clomosy.com/demos/foodInformationBox.png", "TextBold":"yes"}');
    BtnOyuncuPuani.Align := alRight;
    BtnOyuncuPuani.Margins.Right := 10;
    BtnOyuncuPuani.Margins.Left := 10;
    BtnOyuncuPuani.Margins.Top := 3;
    BtnOyuncuPuani.Margins.Bottom := 3;
    DesignerListPanel.AddPanelObject(BtnOyuncuPuani , clText2);
  
    nameArray := TclArrayString.Create;
    ScoreArray := TclArrayString.Create;
    guidArray := TclArrayString.Create;
    ListContainer := Clomosy.StringListNew;
  
    MqttEkran := FormExe.AddNewMQTTConnection(FormExe , 'MqttEkran');
    FormExe.AddNewEvent(MqttEkran , tbeOnMQTTStatusChanged , 'MqttEkranChanged');
    FormExe.AddNewEvent(MqttEkran , tbeOnMQTTPublishReceived , 'MqttScreenPublish');
    MqttEkran.Channel := 'Room';
    MqttEkran.Connect;
  
    ImgBack := FormExe.AddNewProImage(FormExe , 'ImgBack');
    ImgBack.Align := alNone;
    clComponent.SetupComponent(ImgBack , '{"ImgUrl":"https://clomosy.com/demos/XoXback.png"}');
    ImgBack.Width := TForm(FormExe).ClientWidth / 6;
    ImgBack.Height := TForm(FormExe).ClientHeight / 12;
    FormExe.AddNewEvent(ImgBack , tbeOnClick , 'CloseForm2');
    ImgBack.Position.X := -10;
    ImgBack.Position.Y := 10;
    
    FormExe.Run;
  end;

// ---------------------MAIN CODE BLOCK------------------------------------------------------------
begin
  if(Clomosy.PlatformIsMobile)then
  begin
    CreateGameForm;
  end;
  else
  begin
    CreateExeForm;
    //CreateGameForm
  end;
end;
// ---------------------------------------------------------------------------------------------------
