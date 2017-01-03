angular.module 'app'
.controller 'MainCtrl', ['$scope', '$http', '$location', '$state',
($scope, $http, $location, $state)->
  $scope.isNavCollapsed = true
  $scope.$state = $state

  $scope.signOut = ->
    $http.delete '/admin/admins/sign_out'
      .then (resp)->
        $location.path '/admin/admins/sign_in' if resp.data.result
    return
]
