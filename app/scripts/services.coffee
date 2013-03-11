'use strict'

### Sevices ###

angular.module('app.services', [])

	.value("RenderContext", (requestContext, actionPrefix, paramNames) ->
		getNextSection = -> requestContext.getNextSection actionPrefix

		isChangeLocal = ->
			requestContext.startsWith actionPrefix

		# I determine if the last change in the request context is relevant to
		# the action and route params being observed in this render context.
		isChangeRelevant = ->

			# If the action is not local to the action prefix, then we don't even
			# want to bother checking the params.
			return (false)  unless requestContext.startsWith(actionPrefix)

			# If the action has changed, we don't need to bother checking the params.
			return (true)  if requestContext.hasActionChanged()

			# If we made it this far, we know that the action has not changed. As such, we''ll
			# have to make the change determination based on the observed parameters.
			paramNames.length and requestContext.haveParamsChanged(paramNames)

		# ---------------------------------------------- //
		# ---------------------------------------------- //

		# Private variables...

		# ---------------------------------------------- //
		# ---------------------------------------------- //

		# Return the public API.
		getNextSection: getNextSection
		isChangeLocal: isChangeLocal
		isChangeRelevant: isChangeRelevant
	)

	.service("requestContext", [
		'RenderContext'

		(RenderContext) ->

			# Store the current action path.
			action = ""

			# Store the action as an array of parts so we can more easily examine
			# parts of it.
			sections = []

			# Store the current route params.
			params = {}

			# Store the previous action and route params. We'll use these to make
			# a comparison from one route change to the next.
			previousAction = ""
			previousParams = {}


			getAction = -> action

			# I get the next section at the given location on the action path.
			getNextSection = (prefix) ->
				# Make sure the prefix is actually in the current action.
				return (null)  unless startsWith(prefix)
				# If the prefix is empty, return the first section.
				return (sections[0])  if prefix is ""

				# Now that we know the prefix is valid, lets figure out the depth
				# of the current path.
				depth = prefix.split(".").length

				# If the depth is out of bounds, meaning the current action doesn't
				# define sections to that path (they are equal), then return null.
				return (null)  if depth is sections.length

				# Return the section.
				sections[depth]

			# I return the param with the given name, or the default value (or null).
			getParam = (name, defaultValue) ->
				defaultValue = null  if angular.isUndefined(defaultValue)
				params[name] or defaultValue

			# I return the param as an int. If the param cannot be returned as an
			# int, the given default value is returned. If no default value is
			# defined, the return will be zero.
			getParamAsInt = (name, defaultValue) ->

				# Try to parse the number.
				valueAsInt = (getParam(name, defaultValue or 0) * 1)

				# Check to see if the coersion failed. If so, return the default.
				if isNaN(valueAsInt)
					defaultValue or 0
				else
					valueAsInt

			# I return the render context for the given action prefix and sub-set of
			# route params.
			getRenderContext = (requestActionLocation, paramNames) ->

				# Default the requestion action.
				requestActionLocation = (requestActionLocation or "")

				# Default the param names.
				paramNames = (paramNames or [])

				# The param names can be passed in as a single name; or, as an array
				# of names. If a single name was provided, let's convert it to the array.
				paramNames = [paramNames]  unless angular.isArray(paramNames)
				new RenderContext(this, requestActionLocation, paramNames)

			# I determine if the action has changed in this particular request context.
			hasActionChanged = ->
				action isnt previousAction

			# I determine if the given param has changed in this particular request
			# context. This change comparison can be made against a specific value
			# (paramValue); or, if only the param name is defined, the comparison will
			# be made agains the previous snapshot.
			hasParamChanged = (paramName, paramValue) ->

				# If the param value exists, then we simply want to use that to compare
				# against the current snapshot.
				return (not isParam(paramName, paramValue))  unless angular.isUndefined(paramValue)

				# If the param was NOT in the previous snapshot, then we'll consider
				# it changing.
				if not previousParams.hasOwnProperty(paramName) and params.hasOwnProperty(paramName)
					return (true)

					# If the param was in the previous snapshot, but NOT in the current,
					# we'll consider it to be changing.
				else return (true)  if previousParams.hasOwnProperty(paramName) and not params.hasOwnProperty(paramName)

				# If we made it this far, the param existence has not change; as such,
				# let's compare their actual values.
				previousParams[paramName] isnt params[paramName]

			# I determine if any of the given params have changed in this particular
			# request context.
			haveParamsChanged = (paramNames) ->
				i = 0
				length = paramNames.length

				while i < length

					# If one of the params has changed, return true - no need to
					# continue checking the other parameters.
					return (true)  if hasParamChanged(paramNames[i])
					i++

				# If we made it this far then none of the params have changed.
				false

			# I check to see if the given param is still the given value.
			isParam = (paramName, paramValue) ->

				# When comparing, using the coersive equals since we may be comparing
				# parsed value against non-parsed values.
				return (true)  if params.hasOwnProperty(paramName) and (params[paramName] is paramValue)

				# If we made it this far then param is either a different value; or,
				# is no longer available in the route.
				false

			# I set the new request context conditions.
			setContext = (newAction, newRouteParams) ->

				# Copy the current action and params into the previous snapshots.
				previousAction = action
				previousParams = params

				# Set the action.
				action = newAction

				# Split the action to determine the sections.
				sections = action.split(".")
				# Update the params collection.
				params = angular.copy(newRouteParams)

			# I determine if the current action starts with the given path.
			startsWith = (prefix) ->

				# When checking, we want to make sure we don't match partial sections for false
				# positives. So, either it matches in entirety; or, it matches with an additional
				# dot at the end.
				return (true)  if not prefix.length or (action is prefix) or (action.indexOf(prefix + ".") is 0)
				false

			# ---------------------------------------------- //
			# ---------------------------------------------- //



			# Return the public API.
			getNextSection: getNextSection
			getParam: getParam
			getParamAsInt: getParamAsInt
			getRenderContext: getRenderContext
			hasActionChanged: hasActionChanged
			hasParamChanged: hasParamChanged
			haveParamsChanged: haveParamsChanged
			isParam: isParam
			setContext: setContext
			startsWith: startsWith
	])