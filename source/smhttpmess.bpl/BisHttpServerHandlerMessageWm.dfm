object BisHttpServerHandlerMessageWebModule: TBisHttpServerHandlerMessageWebModule
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'Message'
      OnAction = BisHttpServerHandlerUpdateWebModuleUpdateAction
    end
    item
      Name = 'Raw'
      PathInfo = '/raw'
      OnAction = BisHttpServerHandlerUpdateWebModuleUpdateAction
    end
    item
      Name = 'Xml'
      PathInfo = '/xml'
      OnAction = BisHttpServerHandlerUpdateWebModuleXmlAction
    end>
  Height = 150
  Width = 215
end
