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

  tool = {}
  tool_name_generate = (newVal, oldVal)->
    return unless newVal and newVal != oldVal
    tool.name = tool_name newVal

  tool_name = (tool_papers)->
    sorted = angular.copy tool_papers
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

    name = pos.join ' + '
    name += " - #{neg.join ' - '}" if neg.length
    name

  $scope.$watch ->
    tool.papers
  , tool_name_generate, true

  loadItems = ->
    $scope.loadingItems = true
    $scope.tools = Tool.query (tls)->
      for t in tls
        t.name = tool_name t.papers
      $scope.loadingItems = false

  addPaper = (t)->
    tool = t
    tool.papers.push { paper_id: null, volume: 1 }

  removePaper = (t, p, form)->
    tool = t
    i = tool.papers.indexOf p
    tool.papers.splice i, 1
    form.$setDirty()

  callbacks = {
    reloadItems: loadItems
    addPaper: addPaper
    removePaper: removePaper
    papers: papers
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

  papers = Paper.query ->
    loadItems()
]
