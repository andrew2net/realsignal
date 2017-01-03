angular.module 'app'
.controller 'EditModalCtrl', ['$scope', '$uibModalInstance', 'item',
($scope, $uibModalInstance, item)->
  $scope.item = angular.copy item

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
