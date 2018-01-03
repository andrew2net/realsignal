angular.module 'AccountApp'
.factory 'SubscriptionType', ['$resource', ($resource)->
  $resource '/admin/subscription_types/:id.json', id: '@id', { update:{ method: 'PUT' }}
]
