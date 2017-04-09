angular.module 'app'
.controller 'AdminsCtrl', ['$scope', 'Admin', '$editModal',
($scope, Admin, $editModal)->
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

  loadItems = ->
    $scope.loadingItems = true
    $scope.admins = Admin.query ->
      $scope.loadingItems = false

  callbacks = { reloadItems: loadItems }

  templateUrl = 'adminModal.html'
  $scope.addItem = -> $editModal.open new Admin, templateUrl, callbacks
  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
  $scope.removeItem = (row)-> $editModal.remove(row.entity, row.entity.email,
    callbacks)

  loadItems()
]
