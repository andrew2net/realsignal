angular.module 'app'
  .controller 'MainCtrl', ['$scope', ($scope)->
    $scope.showEm = false
    sprt = 'support'

    $scope.openEm = ->
      $scope.showEm = sprt + String.fromCharCode(64) + 'real-signal.com'
      return
    return
  ]
