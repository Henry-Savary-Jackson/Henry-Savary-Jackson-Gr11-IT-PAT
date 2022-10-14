object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 427
  Width = 638
  object DSTeamTB: TDataSource
    Left = 128
    Top = 312
  end
  object ADOConnection1: TADOConnection
    Left = 304
    Top = 48
  end
  object TeamTB: TADOTable
    Left = 112
    Top = 208
  end
  object MatchTB: TADOTable
    Left = 168
    Top = 200
  end
  object MatchAllocTB: TADOTable
    Left = 288
    Top = 224
  end
  object OrganiserTB: TADOTable
    Left = 360
    Top = 240
  end
  object SupervisorTB: TADOTable
    Left = 472
    Top = 248
  end
  object DSMatchTB: TDataSource
    Left = 192
    Top = 320
  end
  object DSMatchAllocTB: TDataSource
    Left = 280
    Top = 328
  end
  object DSOrganiserTB: TDataSource
    Left = 368
    Top = 336
  end
  object DSSupervisorTB: TDataSource
    Left = 472
    Top = 344
  end
end
