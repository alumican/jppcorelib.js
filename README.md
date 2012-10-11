# jppcorelib.js

## Namespace
`jpp.util.Namespace` provides the name  space system.  
`jpp.util.Namespace`は名前空間の仕組みを提供するクラス。


### Install
`Namespace`クラスはデフォルトで`window`オブジェクトの`jpp.util`名前空間に登録されている。  
`jpp.util.Namespace`ではなく、`Namespace`のみでアクセスしたい場合は以下のコードを書く。

```javascript
jpp.util.Namespace('jpp.util').import('Namespace');
```

#### How to Use
基本的に`Namespace(‘名前空間’)`で任意の名前空間を指定し、そこに対するメソッドを呼び出すことで名前空間を直感的に操作できる。

##### Namespace(‘名前空間’).resister(‘オブジェクト名’, オブジェクト, 上書きフラグ)
‘名前空間’に任意のオブジェクト(関数,クラス,数値,文字列などなんでも)を’オブジェクト名’として登録する。  
ここで登録したオブジェクトには、後述の`use`もしくは`import`するまでアクセスすることはできない。

```javascript
//foo.bar名前空間にHello関数とWorld関数を登録する
Namespace('foo.bar').register('Hello', function Hello() { return 'Hello'; });
Namespace('foo.bar').register('World', function World() { return 'World'; });
```

##### Namespace(‘名前空間’).use()
‘名前空間’に属するオブジェクトをグローバルへインポートする。  
インポート後のオブジェクトには完全修飾名でアクセスできる。

```javascript
Namespace('foo.bar').use();
foo.bar.Hello();
foo.bar.World();
```

##### Namespace(‘名前空間’).import(‘オブジェクト名’)
‘オブジェクト名’を指定して’名前空間’に登録済みのオブジェクトをグローバルへインポートする。  
インポート後のオブジェクトにはオブジェクト名のみでアクセスできる。

```javascript
//オブジェクトを個別にインポートする
Namespace('foo.bar').import('Hello');
Hello();
```

```javascript
//オブジェクトを配列でまとめてインポートする
Namespace('foo.bar').import(['Hello', 'World']);
Hello();
World();
```

```javascript
//指定した名前空間に登録した全てのオブジェクトを'*'でインポートする
Namespace('foo.bar').import('*');
Hello();
World();
```

```javascript
//引数を省略した場合も'*'と同じ挙動になる
Namespace('foo.bar').import();
Hello();
World();
```

##### Namespace(‘名前空間’).scope(スコープ)
`use`もしくは`import`使用時の名前空間およびオブジェクトのインポート先を指定した’スコープ’に変更する。

```javascript
//インポート先をデフォルトのグローバル(window)からmyscopeへ変更する
var myscope = {};
Namespace('foo.bar').scope(myscope).use();
Namespace('foo.bar').scope(myscope).import('Hello');
myscope.foo.bar.Hello();
myscope.foo.bar.World();
myscope.Hello();
```

##### 応用

```javascript
//register, use, import, scopeはメソッドチェーンを備えているため繋げて呼び出すことができる
Namespace('foo.bar').use().import('Hello');
foo.bar.Hello();
foo.bar.World();
Hello();
```

```javascript
//何も登録されてない名前空間をuseするとグローバルに名前空間のみ確保する
Namespace('xxx.yyy').use();
xxx;
xxx.yyy;
```

```javascript
//現在登録されている全てのオブジェクトをconsoleに列挙する
//主にデバッグ用途で使用する
Namespace.enumerate();
```

## Command
`jpp.command.*` provides the sequential command system.  
`jpp.command.*`はProgressionライクなコマンドシステムを提供するクラス群。

### Install
各種`Command`クラスはデフォルトで`jpp.util.Namespace`クラスの`jpp.command`名前空間に登録されている。  
`jpp.command.クラス名`でアクセスしたい場合は以下のコードを書く。

```javascript
jpp.util.Namespace('jpp.command').use();
```

`jpp.command.クラス名`ではなく、クラス名のみでアクセスしたい場合は以下のコードを書く。

```javascript
jpp.util.Namespace('jpp.command').import('*');
```

#### Command Class
各種コマンドクラス

`Break`
`Func`
`JqueryAjax`
`JqueryGet`
`JqueryPost`
`Listen`
`ParallelList`
`Return`
`SerialList`
`Tween`
`Wait`

#### Example

```javascript
jpp.util.Namespace('jpp.command').import('*');
jpp.util.Namespace('jpp.util').import('Easing');

var value0;
var value1 = 100;
var self = this;

var command = new SerialList(
	new Func(function() {
		trace("Start");
	}),
	new Wait(0.5),
	new Func(function() {
		trace("Wait Complete");
	}),
	new JqueryGet('sample.xml', null, function(data) {
		trace(data);
	}),
	new Func(function() {
		trace("Load Complete");
	}),

	new Tween(self, { value0 : 100, value1 : 0 }, { value0 : 0 }, 3, Easing.easeOutExpo,
		function() {
			trace('Tween Start    : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
		},
		function() {
			trace('Tween Update   : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
		},
		function() {
			trace('Tween Complete : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
		}
	),

	new SerialList(
		new Func(function() { trace("A"); }),
		new Func(function() {
			this.getParent().addCommand(
				new Wait(0.2),
				new Func(function() { trace("H"); })
			);
		}),
		new ParallelList(
			new SerialList(
				new Wait(1),
				new Func(function() { trace("C"); })
			),
			new SerialList(
				new Wait(0.5),
				new Func(function() {
					trace("B");
					this.getParent().insertCommand(
						new Wait(2),
						new Func(function() { trace("E"); })
					);
				}),
				new Func(function() { trace("F"); })
			),
			new SerialList(
				new Wait(1.5),
				new Func(function() { trace("D"); })
			)
		),
		new Func(function() { trace("G"); })
	)
);
command.execute();
```


## EventDispatcher
`jpp.event.*` provides the AS3 like event system.  
`jpp.event.*`はAS3ライクなイベントシステムを提供するクラス群。

### Install
各種イベントクラスはデフォルトで`jpp.util.Namespace`クラスの`jpp.event`名前空間に登録されている。  
`jpp.event.クラス名`でアクセスしたい場合は以下のコードを書く。

```javascript
jpp.util.Namespace('jpp.event').use();
```

`jpp.event.クラス名`ではなく、クラス名のみでアクセスしたい場合は以下のコードを書く。

```javascript
jpp.util.Namespace('jpp.event').import('*');
```

#### Example

```javascript
jpp.util.Namespace('jpp.event').import();

function func1(event) { console.log(1, event.type, event.target, event.extra); }
function func2(event) { console.log(2, event.type, event.target, event.extra); }
function func3(event) { console.log(3, event.type, event.target, event.extra); }

dispatcher = new EventDispatcher();

dispatcher.addEventListener('A', func1);
dispatcher.addEventListener('A', func1);
dispatcher.addEventListener('A', func2);
dispatcher.addEventListener('A', func3);
dispatcher.removeEventListener('A', func2);
dispatcher.dispatchEvent('A');

console.log(dispatcher.hasEventListener('A'));
console.log(dispatcher.hasEventListener('B'));

dispatcher.addEventListener('A', func1);
dispatcher.addEventListener('B', func1);
dispatcher.dispatchEvent('A', 'ABCDE');
dispatcher.dispatchEvent('B');

dispatcher.removeAllEventListeners('A');
dispatcher.dispatchEvent('A');
dispatcher.dispatchEvent('B');
```
