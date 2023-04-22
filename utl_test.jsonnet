local utl = import 'utl.libjsonnet';

local test_empty() =
	assert utl.empty(null);
	assert utl.empty('');
	assert utl.empty([]);
	assert utl.empty({});
	assert !utl.empty(false);
	assert !utl.empty(0);
	assert !utl.empty('x');
	assert !utl.empty([0]);
	assert !utl.empty({'x':0});
	true;

local test_no() =
	assert utl.no(null);
	assert utl.no('');
	assert utl.no([]);
	assert utl.no({});
	assert utl.no(false);
	assert utl.no(0);
	assert !utl.no('x');
	assert !utl.no([0]);
	assert !utl.no({'x':0});
	assert !utl.no(true);
	assert !utl.no(1);
	true;

local test_yes() =
	assert !utl.yes(null);
	assert !utl.yes('');
	assert !utl.yes([]);
	assert !utl.yes({});
	assert !utl.yes(false);
	assert !utl.yes(0);
	assert utl.yes('x');
	assert utl.yes([0]);
	assert utl.yes({'x':0});
	assert utl.yes(true);
	assert utl.yes(1);
	true;

local test_log() =
	assert utl.info('x') == {INFO: "x"};
	assert utl.info('x', true) == {INFO: "x", data: true};
	assert utl.info('x', {y: true}) == {INFO: "x", y: true};
	assert utl.warn('x') == {WARN: "x"};
	assert utl.warn('x', true) == {WARN: "x", data: true};
	assert utl.warn('x', {y: true}) == {WARN: "x", y: true};
	assert utl.err('x') == {ERROR: "x"};
	assert utl.err('x', true) == {ERROR: "x", data: true};
	assert utl.err('x', {y: true}) == {ERROR: "x", y: true};
	assert utl.fatal('x') == {FATAL: "x"};
	assert utl.fatal('x', true) == {FATAL: "x", data: true};
	assert utl.fatal('x', {y: true}) == {FATAL: "x", y: true};
	assert utl.info('') == {INFO: '""'};
	assert utl.info([0]) == {INFO: "[0]"};
	true;

local test_badVal() =
	assert utl.badVal('s', 0, 'f', 'int', ['john']) == {ERROR: "'int' value '[\"john\"]' is not valid",
		Field: "f", Index: "0", Source: "s"};
	true;

local test_warnVal() =
	assert utl.warnVal('s', 0, 'f', 'int', 42, 'is the Ultimate Answer') == {WARN:
		"'int' value '42' is the Ultimate Answer", Field: "f", Index: "0", Source: "s"};
	true;

local test_hasErrors() =
	assert !utl.hasErrors({});
	assert !utl.hasErrors({"errors": []});
	assert !utl.hasErrors({"errors": [utl.info('x')]});
	assert !utl.hasErrors({"errors": [utl.warn('x')]});
	assert utl.hasErrors({"errors": [utl.err('x')]});
	assert utl.hasErrors({"errors": [utl.fatal('x')]});

	assert !utl.hasErrors([]);
	assert !utl.hasErrors([{}]);
	assert !utl.hasErrors([{"errors": []}]);
	assert !utl.hasErrors([{"errors": [utl.info('x')]}]);
	assert !utl.hasErrors([{"errors": [utl.warn('x')]}]);
	assert utl.hasErrors([{"errors": [utl.err('x')]}]);
	assert utl.hasErrors([{"errors": [utl.fatal('x')]}]);
	true;

local func0() =
	'func0()';

local func1(a) =
	assert std.type(a) == 'string';
	'func1(a)';

local func2(a,b) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	'func2(a,b)';

local func3(a,b,c) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	'func3(a,b,c)';

local func4(a,b,c,d) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	'func4(a,b,c,d)';

local func5(a,b,c,d,e) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	assert std.type(e) == 'string';
	'func5(a,b,c,d,e)';

local func6(a,b,c,d,e,f) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	assert std.type(e) == 'string';
	assert std.type(f) == 'string';
	'func6(a,b,c,d,e,f)';

local func7(a,b,c,d,e,f,g) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	assert std.type(e) == 'string';
	assert std.type(f) == 'string';
	assert std.type(g) == 'string';
	'func7(a,b,c,d,e,f,g)';

local func8(a,b,c,d,e,f,g,h) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	assert std.type(e) == 'string';
	assert std.type(f) == 'string';
	assert std.type(g) == 'string';
	assert std.type(h) == 'string';
	'func8(a,b,c,d,e,f,g,h)';

local func9(a,b,c,d,e,f,g,h,i) =
	assert std.type(a) == 'string';
	assert std.type(b) == 'string';
	assert std.type(c) == 'string';
	assert std.type(d) == 'string';
	assert std.type(e) == 'string';
	assert std.type(f) == 'string';
	assert std.type(g) == 'string';
	assert std.type(h) == 'string';
	assert std.type(i) == 'string';
	'func9(a,b,c,d,e,f,g,h,i)';

local test_apply() =
	assert utl.apply(func0,[]) == 'func0()';
	assert utl.apply(func1,['a']) == 'func1(a)';
	assert utl.apply(func2,['a','b']) == 'func2(a,b)';
	assert utl.apply(func3,['a','b','c']) == 'func3(a,b,c)';
	assert utl.apply(func4,['a','b','c','d']) == 'func4(a,b,c,d)';
	assert utl.apply(func5,['a','b','c','d','e']) == 'func5(a,b,c,d,e)';
	assert utl.apply(func6,['a','b','c','d','e','f']) == 'func6(a,b,c,d,e,f)';
	assert utl.apply(func7,['a','b','c','d','e','f','g']) == 'func7(a,b,c,d,e,f,g)';
	assert utl.apply(func8,['a','b','c','d','e','f','g','h']) == 'func8(a,b,c,d,e,f,g,h)';
	assert utl.apply(func9,['a','b','c','d','e','f','g','h','i']) == 'func9(a,b,c,d,e,f,g,h,i)';
	true;

local test_matchAny() =
	local t(x) = (x == true);
	assert utl.matchAny(t, [0,true,'']);
	assert !utl.matchAny(t, [0,false,'']);
	true;

local test_mergeOnlyErrors() =
	assert utl.mergeOnlyErrors([{ result: true, errors: ['a'] }, { result: false, errors: ['b'] }]) ==
		{ result: [true, false], errors: ['a','b'] };
	true;

local test_mergeContentAndErrors() =
	assert utl.mergeContentAndErrors([{ result: {a:'a'}, errors: ['a'] },
		{ result: {b:'b'}, errors: ['b'] }]) == { result: {a:'a',b:'b'}, errors: ['a','b'] };
	true;

local test_sum() =
	assert utl.sum([1,2,3],-2) == 4;
	assert utl.sum(['a','b'],'*') == 'ab*';
	true;

local test_object2Array() =
	assert utl.object2Array(null) == null;
	assert utl.object2Array({}) == [];
	assert utl.object2Array({'1':'a','3':'b'}) == [null,'a',null,'b'];
	true;

local test_makeObject() =
	assert utl.makeObject([], []) == {};
	assert utl.makeObject(['a','b','c'], [0,true,'']) == {'a':0,'b':true,'c':''};
	assert utl.makeObject(['a','b','c','d','e','f'], [0,1,2,3,4,5]) == {'a':0,'b':1,'c':2,'d':3,'e':4,'f':5};
	assert utl.makeObject(['a'], [null],false) == {} : std.toString(utl.makeObject(['a'], [null],false));
	true;

{
	result: test_empty() && test_no() && test_yes() && test_log() && test_badVal() && test_warnVal() &&
		test_hasErrors() && test_apply() && test_matchAny() && test_mergeOnlyErrors() &&
		test_mergeContentAndErrors() && test_sum() && test_object2Array() && test_makeObject()
}
