object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 584
  ClientWidth = 1119
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1119
    Height = 584
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 536
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ExplicitHeight = 508
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 576
        Height = 556
        Align = alLeft
        Caption = 'Panel1'
        Color = clMenu
        ParentBackground = False
        TabOrder = 0
        ExplicitHeight = 508
        object Label2: TLabel
          Left = 208
          Top = 62
          Width = 46
          Height = 13
          Caption = 'repetition'
        end
        object lblPeriodLength: TLabel
          Left = 208
          Top = 86
          Width = 73
          Height = 13
          Caption = 'lblPeriodLength'
        end
        object Label1: TLabel
          Left = 208
          Top = 27
          Width = 42
          Height = 13
          Caption = 'siteswap'
        end
        object Label3: TLabel
          Left = 209
          Top = 105
          Width = 20
          Height = 13
          Caption = 'nom'
        end
        object vstPattern: TVirtualStringTree
          Left = 5
          Top = 351
          Width = 548
          Height = 194
          Header.AutoSizeIndex = -1
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          TabOrder = 0
          TreeOptions.SelectionOptions = [toExtendedFocus]
          OnCreateEditor = vstPatternCreateEditor
          OnEditing = vstPatternEditing
          OnGetText = vstPatternGetText
          OnGetNodeDataSize = vstPatternGetNodeDataSize
          Columns = <
            item
              Position = 0
            end>
        end
        object btnProcess: TButton
          Left = 334
          Top = 185
          Width = 75
          Height = 25
          Caption = 'btnProcess'
          TabOrder = 1
          OnClick = btnProcessClick
        end
        object vlePos: TValueListEditor
          Left = 429
          Top = 24
          Width = 124
          Height = 201
          KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
          Strings.Strings = (
            'r=32'
            'l=32'
            'c=0'
            'o=0'
            's=5'
            'u=-5')
          TabOrder = 2
          ColWidths = (
            36
            82)
        end
        object testCascadeInverse: TButton
          Left = 320
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testCascadeInverse'
          TabOrder = 3
          OnClick = testTrick
        end
        object testHalfShower: TButton
          Left = 434
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testHalfShower'
          TabOrder = 4
          OnClick = testTrick
        end
        object memoUrl: TMemo
          Left = 206
          Top = 273
          Width = 347
          Height = 56
          Lines.Strings = (
            'mmoResult')
          TabOrder = 5
        end
        object edtSs: TEdit
          Left = 288
          Top = 24
          Width = 120
          Height = 21
          TabOrder = 6
          Text = '423'
        end
        object edtRepetition: TEdit
          Left = 288
          Top = 59
          Width = 121
          Height = 21
          TabOrder = 7
          Text = '1'
        end
        object testCascade: TButton
          Left = 206
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testCascade'
          TabOrder = 8
          OnClick = testTrick
        end
        object Button1: TButton
          Left = 209
          Top = 185
          Width = 75
          Height = 25
          Caption = 'init grid'
          TabOrder = 9
          OnClick = Button1Click
        end
        object mmoResult: TMemo
          Left = 209
          Top = 137
          Width = 200
          Height = 28
          Lines.Strings = (
            'mmoResult')
          TabOrder = 10
        end
        object lstPattern: TListView
          Left = 1
          Top = 1
          Width = 192
          Height = 296
          Columns = <
            item
              AutoSize = True
              Caption = 'Tricks'
            end
            item
              Caption = 'Nom'
              Width = 130
            end>
          GridLines = True
          Groups = <
            item
              GroupID = 0
              State = [lgsNormal]
              HeaderAlign = taLeftJustify
              FooterAlign = taLeftJustify
              TitleImage = -1
            end>
          TabOrder = 11
          ViewStyle = vsReport
          OnClick = lstPatternClick
        end
        object btnLoad: TButton
          Left = 0
          Top = 303
          Width = 43
          Height = 25
          Caption = 'Load'
          TabOrder = 12
          OnClick = btnLoadClick
        end
        object btnAdd: TButton
          Left = 49
          Top = 303
          Width = 40
          Height = 25
          Caption = 'Add'
          TabOrder = 13
          OnClick = btnAddClick
        end
        object btnSave: TButton
          Left = 112
          Top = 303
          Width = 41
          Height = 25
          Caption = 'Save'
          TabOrder = 14
          OnClick = btnSaveClick
        end
        object edtNom: TEdit
          Left = 287
          Top = 102
          Width = 121
          Height = 21
          TabOrder = 15
        end
        object btnDelete: TButton
          Left = 159
          Top = 303
          Width = 41
          Height = 25
          Caption = 'Delete'
          TabOrder = 16
          OnClick = btnDeleteClick
        end
      end
      object WebBrowser1: TWebBrowser
        Left = 576
        Top = 0
        Width = 535
        Height = 556
        Align = alClient
        TabOrder = 1
        ExplicitWidth = 525
        ExplicitHeight = 506
        ControlData = {
          4C0000004B370000773900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126209000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
end
