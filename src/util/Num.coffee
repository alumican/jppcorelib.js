###
Number Util
###
class Num

	#constant
	Num.PI   = Math.PI;
	Num.PI2  = Num.PI * 2
	Num.PI_2 = Num.PI / 2
	Num.PI_3 = Num.PI / 3
	Num.PI_4 = Num.PI / 4
	Num.PI_6 = Num.PI / 6

	#convert degree to radian
	Num.toRadian = (degree) ->
		return degree * PI / 180

	#convert radian to degree
	Num.toDegree = (radian) ->
		return radian * 180 / PI

	#calc distance from dx dy
	Num.dist = (dx, dy, squared = true) ->
		if squared then return Math.sqrt(dx * dx + dy * dy) else return dx * dx + dy * dy

	#calc distance from x0 x1 y0 y1
	Num.dist2 = (x0, y0, x1, y1, squared = true) ->
		return dist(x1 - x0, y1 - y0, squared)

	#値を指定区間内に丸める
	Num.map = (value, srcMin, srcMax, dstMin, dstMax) ->
		value = srcMin if value < srcMin
		value = srcMax if value > srcMax
		return (value - srcMin) * (dstMax - dstMin) / (srcMax - srcMin) + dstMin

	#2点(p1, p2)をd1:d2に内分する点を求める
	Num.internallyDividing = (p1, p2, d1, d2) ->
		if p1 == p2 then return p1 else return (d2 * p1 + d1 * p2) / (d1 + d2)

	#2点(p1, p2)をd1:d2に外分する点を求める
	Num.externallyDividing = (p1, p2, d1, d2) ->
		if p1 == p2 then return p1 else return (d2 * p1 - d1 * p2) / (d2 - d1)

	#符号を求める
	Num.sign = (value) ->
		return value < 0 ? -1 : 1

	#ランダムに選ぶ
	Num.choose = (args...) ->
		return args[Math.floor(Math.random() * args.length)]

	#value1とvalue2をratio1:ratio2の割合で混合する
	Num.combine = (value1, value2, ratio1, ratio2 = null) ->
		if ratio1 > 1 then ratio2 ?= 1 else ratio2 ?= 1 - ratio1
		t = ratio1 + ratio2
		return value1 * ratio1 / t + value2 * (1 - ratio1 / t)

	#[min, max)の範囲の値をランダムに選択する
	Num.range = (min, max) ->
		return Math.random() * (max - min) + min

#export
Namespace('jpp.util').register('Num', Num)
