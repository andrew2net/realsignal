angular.module 'app'
.factory 'SubscriptionType', ['$resource', ($resource)->
  $resource '/admin/subscription_types/:id.json', id: '@id', {
    update:{method: 'PUT'}
  }
]
.factory 'Admin', ['$resource', ($resource)->
  $resource '/admin/admins/:id.json', id: '@id', {update:{method: 'PUT'}}
]
.factory 'User', ['$resource', ($resource)->
  $resource '/admin/users/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
.factory 'Paper', ['$resource', ($resource)->
  $resource '/admin/papers/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
.factory 'Tool', ['$resource', ($resource)->
  $resource '/admin/tools/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
.factory 'Strategy', ['$resource', ($resource)->
  $resource '/admin/strategies/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
