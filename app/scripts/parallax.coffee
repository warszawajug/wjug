'use strict'

angular.module('parallax', [])
	.factory('sectionScroller', [
		'$window'

		($window) ->
			(id, t) ->
				target = $("##{id}")
				win = angular.element($window)
				return unless target.length
				if target.outerHeight() < win.height() then position = target.offset().top + target.outerHeight() / 2 - win.height() / 2
				else position = target.offset().top
				position = Math.max position, 0
				$.scrollTo position, t,
					easing: 'easeInOutExpo'
	])
	.factory('idGenerator', [
		->
			generateId: (element, prefix) ->
				unless (id = element.attr 'id')?
					loop
						id = prefix + Math.floor(Math.random()*1000)
						break unless document.getElementById(id)?
					element.attr 'id', id
				return id
	])
	.directive('parallax', [
		'$window'
		'$location'
		'$rootScope'
		'idGenerator'

		($window, $location, $rootScope, idGenerator) ->
			(scope, element, attrs) ->
				newPos = (x, firstTop, pos, speedFactor) ->
					"#{x}% #{Math.floor((firstTop - pos) * speedFactor)}px"

				win = angular.element($window)

				id = idGenerator.generateId element, 'parallax'

				eventSuffix = "prlx#{id}"

				move = (forced) ->
					if element.hasClass 'inview' or forced
						scrollTop = win.scrollTop()
						firstTop = element.offset().top
						newPosition = newPos 50, firstTop, scrollTop, attrs.parallax
						element.css	backgroundPosition: newPosition

				win.bind "scroll.#{eventSuffix}", -> do move
				win.bind "resize.#{eventSuffix}", -> do move

				element.bind 'inview', (event, visible) ->
					element.toggleClass 'inview', visible

				element.bind '$destroy', ->
					win.unbind "scroll.#{eventSuffix}"
					win.unbind "resize.#{eventSuffix}"

				forced = yes
				move forced
	])
	.directive('page', [
		'$window'

		($window) ->
			(scope, element, attrs) ->
				win = angular.element($window)

				win.bind 'resize.page', -> do resize

				resize = ->
					pt = parseInt element.css 'paddingTop'
					pb = parseInt element.css 'paddingBottom'
					newHeight = (win.height() * attrs.page) - pt - pb
					element.css height: if newHeight > 0 then newHeight else 'auto'

				do resize
	])
	.directive('scrollSpy', [
		'$location'
		'$rootScope'

		($location, $rootScope) ->
			(scope, element, attrs) ->
				return unless (id = attrs.id)?

				changePath = ->
					$location.path("/"+id).replace()
					$rootScope.isUrlChangeIrrelevant = yes
					scope.$apply()
					$rootScope.isUrlChangeIrrelevant = undefined

				element.find('[class*=span]').bind 'inview', (event, visible, visiblePartHorizontal, visiblePartVertical) ->
					event.stopPropagation()
					changePath() if visible and visiblePartVertical is 'both'
	])

