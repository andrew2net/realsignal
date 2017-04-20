angular.module 'app'
.controller 'ToolsCtrl', ['$scope', '$editModal', '$filter', 'Tool', 'Paper',
($scope, $editModal, $filter, Tool, Paper)->
  $scope.itemName = 'Tool'
  $scope.tools = []

  $scope.toolsGrid = {
    columnDefs: [
      { name: 'Name', field: 'name' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'tools'
  }

  # Generate name of the tool.
  toolName = (tool)->
    sorted = angular.copy tool.papers
    sorted.sort (a, b)->
      if a.volume < 0 and b.volume < 0 or a.volume >= 0 and b.voume >= 0
        0
      else
        a.volume
    pos = []
    neg = []
    for el in sorted
      if el.paper_id
        p = $filter('filter')(papers, {id: el.paper_id})
        if p.length
          if el.volume < 0
            neg.push "#{p[0].name}*#{-el.volume}"
          else
            pos.push "#{p[0].name}*#{el.volume}"

    tool.name = pos.join ' + '
    tool.name += " - #{neg.join ' - '}" if neg.length

  loadItems = ->
    $scope.loadingItems = true
    $scope.tools = Tool.query (tls)-> $scope.loadingItems = false

  addPaper = (tool)-> tool.papers.push { paper_id: null, volume: 1 }

  removePaper = (tool, paper, form)->
    i = tool.papers.indexOf paper
    tool.papers.splice i, 1
    toolName tool
    form.$setDirty()

  papers = Paper.query ->
    loadItems()

  callbacks = {
    reloadItems: loadItems
    addPaper: addPaper
    removePaper: removePaper
    papers: papers
    toolName: toolName
  }

  templateUrl = 'toolModal.html'

  $scope.addItem = ->
    tool = new Tool(papers: [])
    $editModal.open tool, templateUrl, callbacks

  $scope.editItem = (row)->
    tool = row.entity
    $editModal.open tool, templateUrl, callbacks

  $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
    loadItems)
]
