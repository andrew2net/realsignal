angular.module 'app'
.controller 'MainCtrl', ['$scope', '$http', ($scope, $http)->
  # $scope.signOut = ->
  #   $http.delete '/users/sign_out'
  #   .then -> window.location = window.location
  # sections = document.getElementsByTagName 'section'
  #
  # checkScroll = ->
  #   for s in sections
  #     rect = s.getBoundingClientRect()
  #     if window.scrollY > rect.top
  #       return
  #
  # stout = null
  # window.addEventListener 'scroll', (event)->
  #   clearTimeout stout if stout
  #   stout = setTimeout checkScroll, 200
  #
  # $scope.showEm = false
  # sprt = 'support'
  # $scope.openEm = ->
  #   $scope.showEm = sprt + String.fromCharCode(64) + 'real-signal.com'
  #   return
  # return
]
