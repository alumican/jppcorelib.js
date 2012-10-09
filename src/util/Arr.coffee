###
Array Util
###
class Arr

	Arr.sequence = (size, start = 0, step = 1) ->
		a = []
		i = 0
		while i < size
			a[i] = i * step
			++i
		return a

	Arr.choose = (array, splice = false) ->
		index = Math.floor(Math.random() * array.length)
		if splice then return array.splice(index, 1)[0] else return array[index]

	Arr.shuffle = (array, overwrite = false) ->
		array = array.concat() if overwrite
		i = n = array.length
		while (i--)
			t = Math.floor(Math.random() * i)
			tmp = array[i]
			array[i] = array[t]
			array[t] = tmp
		return array


#export
Namespace('jpp.util').register('Arr', Arr)