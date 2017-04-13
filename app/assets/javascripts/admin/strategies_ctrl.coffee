angular.module 'app'
.controller 'StrategiesCtrl', ['$scope', '$editModal', 'Strategy',
($scope, $editModal, Strategy)->
  $scope.itemName = 'Strategy'
  $scope.strategies = []

  $scope.strategiesGrid = {
    columnDefs: [
      { name: 'Name', field: 'name' }
      { name: 'Leverage', field: 'leverage', type: 'number'}
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'strategies'
  }

  loadItems = ->
    $scope.loadItems = true
    $scope.strategies = Strategy.query -> $scope.loadingItems = false

  callbacks = { reloadItems: loadItems }

  templateUrl = 'strategyModal.html'
  $scope.addItem = -> $editModal.open new Strategy, templateUrl, callbacks
  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
  $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
    loadItems)

  loadItems()
]
