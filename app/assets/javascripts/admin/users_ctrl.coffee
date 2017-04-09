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

  templateUrl = 'userModal.html'
  $scope.addItem = -> $editModal.open new User, templateUrl, loadItems

  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, loadItems

  $scope.removeItem = (row)->
    if confirm "Delete #{row.entity.email}. Are you sure?"
      row.entity.$remove -> loadItems()

  loadItems = ->
    $scope.loadingItems = true
    $scope.users = User.query -> $scope.loadingItems = false

  loadItems()
]
