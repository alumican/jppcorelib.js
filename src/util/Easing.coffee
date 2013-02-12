###
Easing
###
class Easing

	###
	Linear
	###
	Easing.Linear = (x, t, b, c, d) ->
		return c * t / d + b

	###
	Quad
	###
	Easing.easeInQuad = (x, t, b, c, d) ->
		return c * (t /= d) * t + b

	Easing.easeOutQuad = (x, t, b, c, d) ->
		return (-c) * (t /= d) * (t - 2) + b

	Easing.easeInOutQuad = (x, t, b, c, d) ->
		return c / 2 * t * t + b if (t /= d / 2) < 1
		return (-c) / 2 * ((--t) * (t - 2) - 1) + b

	###
	Cubic
	###
	Easing.easeInCubic = (x, t, b, c, d) ->
		return c * (t /= d) * t * t + b

	Easing.easeOutCubic = (x, t, b, c, d) ->
		return c * ((t = t / d - 1) * t * t + 1) + b

	Easing.easeInOutCubic = (x, t, b, c, d) ->
		return c / 2 * t * t * t + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * t + 2) + b

	###
	Quart
	###
	Easing.easeInQuart = (x, t, b, c, d) ->
		return c * (t /= d) * t * t * t + b

	Easing.easeOutQuart = (x, t, b, c, d) ->
		return (-c) * ((t = t / d - 1) * t * t * t - 1) + b

	Easing.easeInOutQuart = (x, t, b, c, d) ->
		return c / 2 * t * t * t * t + b if (t /= d / 2) < 1
		return (-c) / 2 * ((t -= 2) * t * t * t - 2) + b

	###
	Quint
	###
	Easing.easeInQuint = (x, t, b, c, d) ->
		return c * (t /= d) * t * t * t * t + b

	Easing.easeOutQuint = (x, t, b, c, d) ->
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b

	Easing.easeInOutQuint = (x, t, b, c, d) ->
		return c / 2 * t * t * t * t * t + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * t * t * t + 2) + b

	###
	Sine
	###
	Easing.easeInSine = (x, t, b, c, d) ->
		return (-c) * Math.cos(t / d * (Math.PI / 2)) + c + b

	Easing.easeOutSine = (x, t, b, c, d) ->
		return c * Math.sin(t / d * (Math.PI / 2)) + b

	Easing.easeInOutSine = (x, t, b, c, d) ->
		return (-c) / 2 * (Math.cos(Math.PI * t / d) - 1) + b

	###
	Expo
	###
	Easing.easeInExpo = (x, t, b, c, d) ->
		return b if t == 0
		return c * Math.pow(2, 10 * (t / d - 1)) + b

	Easing.easeOutExpo = (x, t, b, c, d) ->
		return b + c if t == d
		return c * (-Math.pow(2, -10 * t / d) + 1) + b

	Easing.easeInOutExpo = (x, t, b, c, d) ->
		return b if t == 0
		return b + c if t == d
		return c / 2 * Math.pow(2, 10 * (t - 1)) + b if (t /= d / 2) < 1
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b

	###
	Circ
	###
	Easing.easeInCirc = (x, t, b, c, d) ->
		return (-c) * (Math.sqrt(1 - (t /= d) * t) - 1) + b

	Easing.easeOutCirc = (x, t, b, c, d) ->
		return c * Math.sqrt(1 - (t = t / d - 1) * t) + b

	Easing.easeInOutCirc = (x, t, b, c, d) ->
		return (-c) / 2 * (Math.sqrt(1 - t * t) - 1) + b if (t /= d / 2) < 1
		return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b

	###
	Elastic
	###
	Easing.easeInElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d) == 1
		p = d * 0.3 if p == 0
		if a < Math.abs(c)
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return (-a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p )) + b

	Easing.easeOutElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d) == 1
		p = d * 0.3 if p == 0
		if a < Math.abs(c)
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p ) + c + b

	Easing.easeInOutElastic = (x, t, b, c, d) ->
		s = 1.70158
		p = 0
		a = c
		return b if t == 0
		return b + c if (t /= d / 2) == 2
		p = d * (0.3 * 1.5) if p == 0
		if (a < Math.abs(c))
			a = c
			s = p / 4
		else
			s = p / (2 * Math.PI) * Math.asin(c / a)
		return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b if t < 1
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b

	###
	Back
	###
	Easing.easeInBack = (x, t, b, c, d, s = 1.70158) ->
		return c * (t /= d) * t * ((s + 1) * t - s) + b

	Easing.easeOutBack = (x, t, b, c, d, s = 1.70158) ->
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b

	Easing.easeInOutBack = (x, t, b, c, d, s = 1.70158) ->
		return c / 2 * (t * t * (((s *= 1.525) + 1) * t - s)) + b if (t /= d / 2) < 1
		return c / 2 * ((t -= 2) * t * (((s *= 1.525) + 1) * t + s) + 2) + b

	###
	Bounce
	###
	Easing.easeInBounce = (x, t, b, c, d) ->
		return c - Easing.easeOutBounce(x, d - t, 0, c, d) + b

	Easing.easeOutBounce = (x, t, b, c, d) ->
		if (t /= d) < (1 / 2.75)
			return c * (7.5625 * t * t) + b
		else if t < (2 / 2.75)
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b
		else if t < (2.5 / 2.75)
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b
		else
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b

	Easing.easeInOutBounce = (x, t, b, c, d) ->
		return Easing.easeInBounce(x, t * 2, 0, c, d) * 0.5 + b if t < d / 2
		return Easing.easeOutBounce(x, t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b


#export
Namespace('jpp.util').register('Easing', Easing)
