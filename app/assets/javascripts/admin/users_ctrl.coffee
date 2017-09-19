angular.module 'app'
.controller 'UsersCtrl', ['$scope', '$editModal', 'User',
($scope, $editModal, User)->
  $scope.itemName = 'User'
  $scope.users = []

  $scope.usersGrid = {
    columnDefs: [
      { field: 'first_name' }
      { field: 'last_name' }
      { field: 'email' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'users'
  }

  loadItems = ->
    $scope.loadingItems = true
    $scope.users = User.query -> $scope.loadingItems = false

  callbacks = { reloadItems: loadItems }

  templateUrl = 'userModal.html'
  $scope.addItem = -> $editModal.open new User, templateUrl, callbacks

  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks

  $scope.removeItem = (row)-> $editModal.remove(row.entity,
  "Delete #{row.entity.first_name} #{row.entity.last_name}.", callbacks)

  loadItems()
]
