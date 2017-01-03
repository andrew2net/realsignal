angular.module 'app'
.factory 'SubscriptionType', ['$resource', ($resource)->
  $resource '/admin/subscription_types/:id', id: '@id', {update:{method: 'PUT'}}
]
.factory 'Admin', ['$resource', ($resource)->
  $resource '/admin/admins/:id', id: '@id', {update:{method: 'PUT'}}
]
.factory 'User', ['$resource', ($resource)->
  $resource '/admin/users/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
