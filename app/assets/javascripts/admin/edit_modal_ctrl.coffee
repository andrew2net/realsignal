angular.module 'app'
.provider '$editModal', ->
  this.$get = ['$uibModal', ($uibModal)->
    {
      open: (item, templateUrl, callbacks)->
        editModal = $uibModal.open {
          templateUrl: templateUrl
          controller: 'EditModalCtrl'
          resolve: {
            item: -> item
            callbacks: -> callbacks
          }
        }
        editModal.result.then -> callbacks.reloadItems()
      remove: (item, name, reloadItems)->
        if confirm "Delete #{name}. Are you sure?"
          item.$remove -> reloadItems()
    }
  ]
  return
.controller 'EditModalCtrl', ['$scope', '$uibModalInstance', 'item', 'callbacks',
($scope, $uibModalInstance, item, callbacks)->
  $scope.item = angular.copy item
  $scope.callbacks = callbacks

  close = ->
    $uibModalInstance.close $scope.item
    $scope.saving = false

  error = -> $scope.saving = false

  $scope.ok = ->
    $scope.saving = true
    if $scope.item.id
      $scope.item.$update close, error
    else
      $scope.item.$save close, error

  $scope.cancel = -> $uibModalInstance.dismiss()
  return
]
