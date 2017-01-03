angular.module 'app'
.controller 'AdminsCtrl', ['$scope', 'Admin', '$uibModal',
($scope, Admin, $uibModal)->
  $scope.itemName = 'Admin'
  $scope.admins = []

  $scope.adminsGrid = {
    columnDefs: [
      { field: 'email' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'admins'
  }

  openModal = (admin)->
    editModal = $uibModal.open {
      templateUrl: 'adminModal.html'
      controller: 'EditModalCtrl'
      resolve: {
        item: -> admin
      }
    }
    editModal.result.then ->
      loadItems()

  $scope.addItem = ->
    openModal new Admin

  $scope.editItem = (row)->
    openModal row.entity

  $scope.removeItem = (row)->
    if confirm "Delete #{row.entity.email}. Are you sure?"
      row.entity.$remove -> loadItems()

  loadItems = ->
    $scope.loadingItems = true
    $scope.admins = Admin.query ->
      $scope.loadingItems = false

  loadItems()
]
