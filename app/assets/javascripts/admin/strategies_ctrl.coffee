angular.module 'app'
.controller 'StrategiesCtrl', [
  '$scope'
  '$editModal'
  'Strategy'
  'PortfolioStrategy'
  'Tool'
  ($scope, $editModal, Strategy, PortfolioStrategy, Tool)->
    $scope.itemName = 'Strategy'
    $scope.strategies = []

    $scope.strategiesGrid = {
      columnDefs: [
        { name: 'Name', field: 'name' }
        { name: 'Leverage', field: 'leverage', type: 'number'}
        {
          name: 'Tool'
          # field: 'portfolio_strategy_id'
          cellTemplate: """
          <div class="ui-grid-cell-contents"
          ng-bind="grid.appScope.getTool(row.entity.tool_id)">
          </div>
          """
        }
        {
          name: 'Portfolio'
          # field: 'portfolio_strategy_id'
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

    $scope.getTool = (id)->
      tool = tools.filter (t)-> t.id == id
      if tool.length
        tool[0].name
      else
        ''

    $scope.getPortfolio = (id)->
      portfolio = portfolioStrategies.filter (p)-> p.id == id
      if portfolio.length
        portfolio[0].name
      else
        ''

    loadItems = ->
      $scope.loadItems = true
      $scope.strategies = Strategy.query -> $scope.loadingItems = false

    portfolioStrategies = PortfolioStrategy.query -> loadItems() if tools
    tools = Tool.query -> loadItems() if portfolioStrategies

    callbacks = {
      reloadItems: loadItems
      portfolioStrategies: portfolioStrategies
      tools: tools
    }

    templateUrl = 'strategyModal.html'
    $scope.addItem = -> $editModal.open new Strategy, templateUrl, callbacks
    $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
    $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.name,
      loadItems)

    # loadItems()
  ]
