/// <reference path="jppcorelib.d.ts" />
function trace(message) {
    console.log(message);
}
var value0;
var value1 = 100;
var self = this;
var command = new JPP.Serial(new JPP.Func(function () {
    trace("Start");
}), new JPP.Wait(0.5), new JPP.Func(function () {
    trace("Wait Complete");
}), new JPP.JqueryGet('sample.xml', null, function (data) {
    trace(data);
}), new JPP.Func(function () { trace("Load Complete"); }), 
//function() { trace("Load Complete (js function)"); },
new JPP.Tween(self, { value0: 100, value1: 0 }, { value0: 0 }, 1, JPP.Easing.easeOutExpo, function () {
    trace('Tween Start    : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
}, function () {
    trace('Tween Update   : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
}, function () {
    trace('Tween Complete : ' + this.getTimeRatio() + ' ' + this.getRatio() + ' ' + value0 + ' ' + value1);
}), new JPP.Serial(new JPP.Func(function () { trace("A"); }), new JPP.Func(function () {
    this.getParent().addCommand(new JPP.Wait(0.2), "AAAAA", function () { trace("H (js function)"); });
}), new JPP.Parallel(new JPP.Serial(new JPP.Wait(1), new JPP.Func(function () { trace("C"); }), new JPP.Break(), new JPP.Func(function () { trace("Never"); })), new JPP.Serial(new JPP.Wait(0.5), new JPP.Func(function () {
    trace("B");
    this.getParent().insertCommand(new JPP.Wait(2), new JPP.Func(function () { trace("E"); }));
}), new JPP.Func(function () { trace("F"); })), new JPP.Serial(new JPP.Wait(1.5), new JPP.Func(function () { trace("D"); }))), new JPP.Func(function () { trace("G"); })));
command.execute();
//# sourceMappingURL=example.js.map