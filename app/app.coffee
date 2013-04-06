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
			.when('/second', action: 'page1.second')
      .when('/meetings', action: 'page1.meetings')
      .when('/liders', action: 'page1.liders')
      .when('/cooperation', action: 'page1.cooperation')
      .when('/library', action: 'page1.library')
      .when('/companies', action: 'page1.companies')
      .when('/contact', action: 'contact')

		# Catch all
			.otherwise({redirectTo: '/about'})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(false)



])
