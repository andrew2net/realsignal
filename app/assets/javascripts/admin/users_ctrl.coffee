angular.module 'app'
.controller 'UsersCtrl', ['$scope', '$uibModal', 'User',
($scope, $uibModal, User)->
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

  openModal = (user)->
    editModal = $uibModal.open {
      templateUrl: 'userModal.html'
      controller: 'EditModalCtrl'
      resolve: { item: -> user }
    }
    editModal.result.then -> loadItems()

  $scope.addItem = -> openModal new User

  $scope.editItem = (row)-> openModal row.entity

  $scope.removeItem = (row)->
    if confirm "Delete #{row.entity.email}. Are you sure?"
      row.entity.$remove -> loadItems()

  loadItems = ->
    $scope.loadingItems = true
    $scope.users = User.query -> $scope.loadingItems = false

  loadItems()
]
