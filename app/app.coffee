'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
	'ngCookies'
	'ngResource'
	'app.controllers'
	'app.directives'
	'app.filters'
	'app.services'
	'ui'
	'parallax'
])

App.config([
	'$routeProvider'
	'$locationProvider'

	($routeProvider, $locationProvider, config) ->
		$routeProvider

			.when('/about', action: 'page1.about')
      .when('/meetings', action: 'page1.meetings')
      .when('/liders', action: 'page1.liders')
      .when('/cooperation', action: 'page1.cooperation')
      .when('/library', action: 'library')
      .when('/companies', action: 'page1.companies')
      .when('/partners', action: 'page1.partners')
      .when('/contact', action: 'contact')
      .when('/meeting/106', action: 'meeting106')
      .when('/meeting/107', action: 'meeting107')
      .when('/meeting/108', action: 'meeting108')
      .when('/meeting/110', action: 'meeting110')
      .when('/meeting/111', action: 'meeting111')
      .when('/meeting/112', action: 'meeting112')
      .when('/meeting/113', action: 'meeting113')

		# Catch all
			.otherwise({redirectTo: '/about'})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(false)




])
