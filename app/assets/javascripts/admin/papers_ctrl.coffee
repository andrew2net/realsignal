angular.module 'app'
.controller 'PapersCtrl', ['$scope', '$editModal', 'Paper',
($scope, $editModal, Paper)->
  $scope.itemName = 'Paper'
  $scope.papers = []

  $scope.papersGrid = {
    columnDefs: [
      { name: 'Name', field: 'name' }
      { name: 'Tick size', field: 'tick_size', type: 'number' }
      { name: 'Tick cost', field: 'tick_cost', type: 'number' }
      { name: 'Price format', field: 'price_format' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'papers'
  }

  loadItems = ->
    $scope.loadingItems = true
    $scope.papers = Paper.query -> $scope.loadingItems = false

  callbacks = { reloadItems: loadItems }

  templateUrl = 'paperModal.html'
  $scope.addItem = -> $editModal.open new Paper, templateUrl, callbacks
  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
  $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
    loadItems)

  loadItems()
]
