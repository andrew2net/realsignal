angular.module 'app'
.controller 'MainCtrl', ['$scope', '$http', '$location', '$state',
($scope, $http, $location, $state) ->
  $scope.isNavCollapsed = true
  $scope.$state = $state

  $http.get '/admin/api/current_admin_email'
  .then (resp) -> $scope.admin_email = resp.data

  $scope.signOut = ->
    $http.delete '/admin/admins/sign_out'
      .then (resp) ->
        $location.path '/admin/admins/sign_in' if resp.data.result
    return
]
