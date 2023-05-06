/*
Copyright 2023 Sebastien Diot. All rights reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

local utl = import 'utl.libjsonnet';


local test_force() =
	assert utl.force(std.length([0,1,3])) == 3;
	true;

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

local func0() =
	'func0()';

local func1(a) =
	assert std.assertEqual(std.type(a), 'string');
	'func1(a)';

local func2(a,b) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	'func2(a,b)';

local func3(a,b,c) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	'func3(a,b,c)';

local func4(a,b,c,d) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	'func4(a,b,c,d)';

local func5(a,b,c,d,e) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	assert std.assertEqual(std.type(e), 'string');
	'func5(a,b,c,d,e)';

local func6(a,b,c,d,e,f) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	assert std.assertEqual(std.type(e), 'string');
	assert std.assertEqual(std.type(f), 'string');
	'func6(a,b,c,d,e,f)';

local func7(a,b,c,d,e,f,g) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	assert std.assertEqual(std.type(e), 'string');
	assert std.assertEqual(std.type(f), 'string');
	assert std.assertEqual(std.type(g), 'string');
	'func7(a,b,c,d,e,f,g)';

local func8(a,b,c,d,e,f,g,h) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	assert std.assertEqual(std.type(e), 'string');
	assert std.assertEqual(std.type(f), 'string');
	assert std.assertEqual(std.type(g), 'string');
	assert std.assertEqual(std.type(h), 'string');
	'func8(a,b,c,d,e,f,g,h)';

local func9(a,b,c,d,e,f,g,h,i) =
	assert std.assertEqual(std.type(a), 'string');
	assert std.assertEqual(std.type(b), 'string');
	assert std.assertEqual(std.type(c), 'string');
	assert std.assertEqual(std.type(d), 'string');
	assert std.assertEqual(std.type(e), 'string');
	assert std.assertEqual(std.type(f), 'string');
	assert std.assertEqual(std.type(g), 'string');
	assert std.assertEqual(std.type(h), 'string');
	assert std.assertEqual(std.type(i), 'string');
	'func9(a,b,c,d,e,f,g,h,i)';

local test_apply() =
	assert std.assertEqual(utl.apply(func0,[]), 'func0()');
	assert std.assertEqual(utl.apply(func1,['a']), 'func1(a)');
	assert std.assertEqual(utl.apply(func2,['a','b']), 'func2(a,b)');
	assert std.assertEqual(utl.apply(func3,['a','b','c']), 'func3(a,b,c)');
	assert std.assertEqual(utl.apply(func4,['a','b','c','d']), 'func4(a,b,c,d)');
	assert std.assertEqual(utl.apply(func5,['a','b','c','d','e']), 'func5(a,b,c,d,e)');
	assert std.assertEqual(utl.apply(func6,['a','b','c','d','e','f']), 'func6(a,b,c,d,e,f)');
	assert std.assertEqual(utl.apply(func7,['a','b','c','d','e','f','g']), 'func7(a,b,c,d,e,f,g)');
	assert std.assertEqual(utl.apply(func8,['a','b','c','d','e','f','g','h']), 'func8(a,b,c,d,e,f,g,h)');
	assert std.assertEqual(utl.apply(func9,['a','b','c','d','e','f','g','h','i']), 'func9(a,b,c,d,e,f,g,h,i)');
	true;

local test_matchAny() =
	local t(x) = (x == true);
	assert utl.matchAny(t, [0,true,'']);
	assert !utl.matchAny(t, [0,false,'']);
	true;

local test_sum() =
	assert std.assertEqual(utl.sum([1,2,3],-2), 4);
	assert std.assertEqual(utl.sum(['a','b'],'*'), 'ab*');
	true;

local test_object2Array() =
	assert std.assertEqual(utl.object2Array(null), null);
	assert std.assertEqual(utl.object2Array({}), []);
	assert std.assertEqual(utl.object2Array({'1':'a','3':'b'}), [null,'a',null,'b']);
	true;

local test_makeObject() =
	assert std.assertEqual(utl.makeObject([], []), {});
	assert std.assertEqual(utl.makeObject(['a','b','c'], [0,true,'']), {'a':0,'b':true,'c':''});
	assert std.assertEqual(utl.makeObject(['a','b','c','d','e','f'], [0,1,2,3,4,5]), {'a':0,'b':1,'c':2,'d':3,'e':4,'f':5});
	assert std.assertEqual(utl.makeObject(['a'], [null],false), {});
	true;

local test_extendStr() =
	assert std.assertEqual(utl.extendStr('a',3,'x',true), 'xxa');
	assert std.assertEqual(utl.extendStr('a',3,'x',false), 'axx');
	assert std.assertEqual(utl.extendStr('abc',3,'x',true), 'abc');
	assert std.assertEqual(utl.extendStr('abcd',3,'x',true), 'abcd');
	assert std.assertEqual(utl.extendStr('',3,'x',false), 'xxx');
	true;

local test_while() =
	local cd(x) = (x < 999);
	local wk(x) = (x + 1);
	assert std.assertEqual(utl.while(cd, wk, 0), 999);
	true;

{
	result: test_force() && test_empty() && test_no() && test_yes() && test_apply() &&
		test_matchAny() &&  test_sum() && test_object2Array() && test_makeObject() &&
		test_extendStr() && test_while()
}
