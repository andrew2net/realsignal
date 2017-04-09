angular.module 'app'
.controller 'SubscriptionTypesCtrl', ['$scope', '$editModal', 'SubscriptionType',
($scope, $editModal, SubscriptionType)->
  $scope.itemName = 'Subscription type'
  $scope.subscriptionTypes = []

  $scope.subscriptionTypesGrid = {
    columnDefs: [
      { name: 'Strategy', field: 'portid' }
      { name:'Trading tool', field: 'symid' }
      { field: 'price', type: 'number' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'subscriptionTypes'
  }

  loadItems = ->
    $scope.loadingItems = true
    $scope.subscriptionTypes = SubscriptionType.query ->
      $scope.loadingItems = false

  callbacks = { reloadItems: loadItems }

  templateUrl = 'subscriptionTypeModal.html'
  $scope.addItem = -> $editModal.open new SubscriptionType, templateUrl, callbacks
  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
  $scope.removeItem = (row)-> $editModal.remove(row.entity,
    "#{row.entity.portid} #{row.entity.symid}", callbacks)

  loadItems()
]
