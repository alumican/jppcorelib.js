/// <reference path="jquery.d.ts" />

declare module JPP
{
	/* ---------------------------------------- *
	   Util
	 * ---------------------------------------- */
	export class Obj
	{
		static close(object:any):any;
	}





	export class Num
	{
		static PI:number;
		static PI2:number;
		static PI_2:number;
		static PI_3:number;
		static PI_4:number;
		static PI_6:number;

		static toRadian(degree:number):number;
		static toDegree(radian:number):number;
		static dist(dx:number, dy:number, squared?:boolean):number;
		static dist2(x0:number, y0:number, x1:number, y1:number, squared?:boolean):number;
		static map(value:number, srcMin:number, srcMax:number, dstMin:number, dstMax:number):number;
		static internallyDividing(p1:number, p2:number, d1:number, d2:number):number;
		static externallyDividing(p1:number, p2:number, d1:number, d2:number):number;
		static sign(value:number):number;
		static choose(...args:any[]):number;
		static combine(value1:number, value2:number, ratio1:number, ratio2?:number):number;
		static range(min:number, max:number):number;
	}





	export class Arr
	{
		static sequence(size:number, start?:number, step?:number):number[];
		static choose(array:any[], splice?:boolean):any;
		static shuffl(array:any[], overwrite?:boolean):any[];
		static clone(array:any[]):any[];
	}





	export class Err
	{
		static build(at:any, text?:string):Error;
		static throw(at:any, text?:string):Error;
	}





	export class Easing
	{
		static Linear(x:number, t:number, b:number, c:number, d:number):number;
		static easeInQuad(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutQuad(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutQuad(x:number, t:number, b:number, c:number, d:number):number;
		static easeInCubic(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutCubic(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutCubic(x:number, t:number, b:number, c:number, d:number):number;
		static easeInQuart(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutQuart(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutQuart(x:number, t:number, b:number, c:number, d:number):number;
		static easeInQuint(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutQuint(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutQuint(x:number, t:number, b:number, c:number, d:number):number;
		static easeInSine(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutSine(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutSine(x:number, t:number, b:number, c:number, d:number):number;
		static easeInExpo(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutExpo(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutExpo(x:number, t:number, b:number, c:number, d:number):number;
		static easeInCirc(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutCirc(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutCirc(x:number, t:number, b:number, c:number, d:number):number;
		static easeInElastic(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutElastic(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutElastic(x:number, t:number, b:number, c:number, d:number):number;
		static easeInBack(x:number, t:number, b:number, c:number, d:number, s?:number):number;
		static easeOutBack(x:number, t:number, b:number, c:number, d:number, s?:number):number;
		static easeInOutBack(x:number, t:number, b:number, c:number, d:number, s?:number):number;
		static easeInBounce(x:number, t:number, b:number, c:number, d:number):number;
		static easeOutBounce(x:number, t:number, b:number, c:number, d:number):number;
		static easeInOutBounce(x:number, t:number, b:number, c:number, d:number):number;
	}





	export class Scope
	{
		static bind(name:string, f:Function):void;
		static clear(name:string):void;
		static temp(f:Function):void;
	}





	export class Namespace
	{
		static enumerate();

		constructor(path:string);

		register(classname:string, object:any, ignoreConflict?:boolean):Namespace;
		import(classname:string):Namespace;
		exist():boolean;
		use():Namespace;
		scope(scope?:any):Namespace;
		getPath():string;
	}





	/* ---------------------------------------- *
	   Event
	 * ---------------------------------------- */
	export class Envet
	{
		static COMPLETE:string;
		static OPEN:string;
		static CLOSE:string;
		static ERROR:string;
		static CANCEL:string;
		static RESIZE:string;
		static INIT:string;
		static CONNECT:string;
		static PROGRESS:string;
		static ADDED:string;
		static REMOVED:string;
		static SELECT:string;
		static FOCUS:string;
		static RENDER:string;

		constructor(type:string, target:any, extra:any);

		type:string;
		target:any;
		extra:any;
	}





	export class EventDispatcher
	{
		constructor(target?:any);

		addEventListener(type:string, listener:Function):void;
		removeEventListener(type:string, listener:Function):void;
		removeAllEventListeners(type?:string):void;
		hasEventListener(type:string):boolean;
		dispatchEvent(type:string, extra?:any):void;
	}





	/* ---------------------------------------- *
	   Command
	 * ---------------------------------------- */

	export class CommandState
	{
		static SLEEPING:number;
		static EXECUTING:number;
		static INTERRUPTING:number;
	}





	export class Command extends EventDispatcher
	{
		constructor(executeFunction?:Function, interruptFunction?:Function, destroyFunction?:Function);

		execute();
		interrupt();
		destroy();
		notifyComplete();

		getExecuteFunction():Function;
		setExecuteFunction(f:Function):void;
		getInterruptFunction():Function;
		setInterruptFunction(f:Function):void;
		getDestroyFunction():Function;
		setDestroyFunction(f:Function):void;
		getState():number;
		getSelf():Command;
		getParent():Command;
		setParent(parent:Command):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class CommandList extends Command
	{
		constructor(...commands:Command[]);

		//addCommand(...commands:Command[]):void;
		//insertCommand(index:number, ...commands:Command[]):void;
		//addCommandArray(commands:Command[]):void;
		//insertCommandArray(index:number, commands:Command[]):void;
		notifyBreak():void;
		notifyReturn():void;

		getCommandByIndex(index:number):Command;
		getCommands():Command[];
		getLength():number;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Parallel extends CommandList
	{
		constructor(...commands:Command[]);

		addCommand(...commands:Command[]):void;
		insertCommand(...commands:Command[]):void;
		_completeHandler(event:Event):void;
		notifyBreak():void;
		notifyReturn():void;

		getCompleteCount():number;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Serial extends CommandList
	{
		constructor(...commands:Command[]);

		addCommand(...commands:Command[]):void;
		insertCommand(...commands:Command[]):void;
		addCommand(...commands:Command[]):void;
		insertCommand(...commands:Command[]):void;
		_next():void;
		_completeHandler(event:Event):void;
		notifyBreak():void;
		notifyReturn():void;

		getPosition():number;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Func extends Command
	{
		constructor(func?:Function, args?:any[], dispatcher?:EventDispatcher, eventType?:string);

		_completeHandler():void;

		getFunction():Function;
		setFunction(func:Function):void;
		getArguments():any[];
		setArguments(args:any[]):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Listen extends Command
	{
		constructor(type?:string, dispatcher?:EventDispatcher);

		_handler(event:Event);

		getType():string;
		setType(type:string):void;
		getDispatcher():EventDispatcher;
		setDispatcher(dispatcher:EventDispatcher):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Wait extends Command
	{
		constructor(time?:number);

		_cancel():void;
		_completeHandler(event:Event);

		getTime():number;
		setTime(time:number):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Break extends Command
	{
		constructor();

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Return extends Command
	{
		constructor();

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Tween extends Command
	{
		constructor(target:any, to:any, from?:any, time?:number, easing?:Function, onStart?:Function, onUpdate?:Function, onComplete?:Function);

		_cancel():void;
		_apply(ratio:number):void;
		_intervalHandler(event:Event):void;

		getTarget():any;
		setTarget(target:any):void;

		getTo():any;
		setTo(to:any):void;

		getFrom():any;
		setFrom(from:any):void;

		getTime():number;
		setTime(time:number):void;

		getEasing():Function;
		setEasing(easing:Function):void;

		getOnStart():Function;
		setOnStart(onStart:Function):void;

		getOnUpdate():Function;
		setOnUpdate(onUpdate:Function):void;

		getOnComplete():Function;
		setOnComplete(onComplete:Function):void;
		getRatio():number;
		getTimeRatio():number;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class Trace extends Command
	{
		constructor(message:any);

		getMessage():any;
		setMessage(message:any):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class RequireScript extends Command
	{
		constructor(url:string);

		_completeHandler(event:Event);
		_cancel():void;

		getUrl():string;
		setUrl(url:string):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class DoTweenJS extends Command
	{
		constructor(tweenProvider:any);

		_completeHandler(tween:any);
		_cancel():void;

		getTween():any;
		setTween(tween:any);

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class JqueryAjax extends Command
	{
		constructor(options?:any);

		_completeHandler(XMLHttpRequest:any, status:string);

		getOptions():any;
		setOptions(options:any):void;
		getUrl():string;
		setUrl(url:string):void;
		getMethod():string;
		setMethod(method):void;
		getData():any;
		setData(data:any):void;
		getDataType():string;
		setDataType(dataType:string):void;
		getOnSuccess():Function;
		setOnSuccess(callback:Function):void;
		getOnError():Function;
		setOnError(callback:Function):void;
		getOnComplete():Function;
		setOnComplete(callback:Function):void;

		getStatus():string;
		getIsSucceed():boolean;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}





	export class JqueryGet extends JqueryAjax
	{
		constructor(url?:string, data?:any, onSuccess?:Function, onError?:Function, dataType?:string);
	}





	export class JqueryPost extends JqueryAjax
	{
		constructor(url?:string, data?:any, onSuccess?:Function, onError?:Function, dataType?:string);
	}





	export class JqueryAnimate extends Command
	{
		constructor(target:JQuery, params:any, options?:any);

		_completeHandler(...p:any[]):void;
		_cancel():void;

		getTarget():JQuery;
		setTarget(target:JQuery):void;
		getParams():any;
		setParams(params:any):void;
		getOptions():any;
		setOptions(options:any):void;

		_executeFunction(command:Command):void;
		_interruptFunction(command:Command):void;
		_destroyFunction(command:Command):void;
	}

}





declare module 'jpp' {
	export = JPP;
}

