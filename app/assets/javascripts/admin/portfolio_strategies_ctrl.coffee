angular.module 'app'
.controller 'PortfolioStrategiesCtrl', [
  '$scope',
  '$editModal',
  'PortfolioStrategy',
  ($scope, $editModal, PortfolioStrategy)->
    $scope.itemName = 'Portfolio strategies'
    $scope.portfolioStrategies = []

    $scope.portfolioStrategiesGrid = {
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
      data: 'portfolioStrategies'
    }

    loadItems = ->
      $scope.loadingItems = true
      $scope.portfolioStrategies = PortfolioStrategy.query ->
        $scope.loadingItems = false

    callbacks = { reloadItems: loadItems }

    templateUrl = 'portfolioStrategyModal.html'
    $scope.addItem = -> $editModal.open(new PortfolioStrategy, templateUrl,
      callbacks)
    $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
    $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
      loadItems)

    loadItems()
  ]
