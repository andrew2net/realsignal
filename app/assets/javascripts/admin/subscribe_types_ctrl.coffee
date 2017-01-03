angular.module 'app'
.controller 'SubscriptionTypesCtrl', ['$scope', '$uibModal', 'SubscriptionType',
($scope, $uibModal, SubscriptionType)->
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

  openModal = (subscriptionType)->
    editModal = $uibModal.open {
      templateUrl: 'editModal.html'
      controller: 'EditModalCtrl'
      resolve: {
        item: -> subscriptionType
      }
    }
    editModal.result.then ->
      loadItems()

  $scope.addItem = ->
    openModal new SubscriptionType

  $scope.editItem = (row)->
    openModal row.entity

  $scope.removeItem = (row)->
    if confirm "Delete #{row.entity.portid} #{row.entity.symid}. Are you sure?"
      row.entity.$remove -> loadItems()

  loadItems = ->
    $scope.loadingItems = true
    $scope.subscriptionTypes = SubscriptionType.query ->
      $scope.loadingItems = false

  loadItems()
]
