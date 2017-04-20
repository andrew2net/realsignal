angular.module 'app'
.controller 'StrategiesCtrl', [
  '$scope'
  '$editModal'
  'Strategy'
  'PortfolioStrategy'
  ($scope, $editModal, Strategy, PortfolioStrategy)->
    $scope.itemName = 'Strategy'
    $scope.strategies = []

    $scope.strategiesGrid = {
      columnDefs: [
        { name: 'Name', field: 'name' }
        { name: 'Leverage', field: 'leverage', type: 'number'}
        {
          displayName: 'Portfolio'
          field: 'portfolio_strategy_id'
          cellTemplate: """
          <div class="ui-grid-cell-contents"
          ng-bind="grid.appScope.getPortfolio(row.entity.portfolio_strategy_id)">
          </div>
          """
        }
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

    $scope.getPortfolio = (id)->
      portfolio = portfolioStrategies.filter (p)-> p.id == id
      if portfolio.length
        portfolio[0].name
      else
        ''

    loadItems = ->
      $scope.loadItems = true
      $scope.strategies = Strategy.query -> $scope.loadingItems = false

    portfolioStrategies = PortfolioStrategy.query -> loadItems()

    callbacks = {reloadItems: loadItems, portfolioStrategies: portfolioStrategies}

    templateUrl = 'strategyModal.html'
    $scope.addItem = -> $editModal.open new Strategy, templateUrl, callbacks
    $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
    $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
      loadItems)

    # loadItems()
  ]
