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

local spr = import 'spr.libjsonnet';

local test_str2Lines() =
	assert std.assertEqual(spr.str2Lines(''), []);
	assert std.assertEqual(spr.str2Lines('x'), ['x']);
	assert std.assertEqual(spr.str2Lines('y\n'), ['y']);
	assert std.assertEqual(spr.str2Lines('y\nz'), ['y', 'z']);
	true;

local test_str2TSV() =
	assert std.assertEqual(spr.str2TSV(''), []);
	assert std.assertEqual(spr.str2TSV('x'), [['x']]);
	assert std.assertEqual(spr.str2TSV('y\n'), [['y']]);
	assert std.assertEqual(spr.str2TSV('y\nz'), [['y'], ['z']]);
	assert std.assertEqual(spr.str2TSV('x\ty\nz'), [['x','y'], ['z']]);
	assert std.assertEqual(spr.str2TSV('x\t\nz'), [['x',''], ['z']]);
	assert std.assertEqual(spr.str2TSV('\ty\nz'), [['','y'], ['z']]);
	true;

local test_isJSONStr() =
	assert !spr.isJSONStr('');
	
	assert spr.isJSONStr('null');
	assert spr.isJSONStr('true');
	assert spr.isJSONStr('false');
	assert spr.isJSONStr('123.456');
	assert spr.isJSONStr('""');

	assert spr.isJSONStr('[]');
	assert spr.isJSONStr('[null]');
	assert spr.isJSONStr('[true]');
	assert spr.isJSONStr('[false]');
	assert spr.isJSONStr('[123.456]');
	assert spr.isJSONStr('[""]');

	assert spr.isJSONStr('{}');
	assert spr.isJSONStr('{"f":null}');
	assert spr.isJSONStr('{"f":true}');
	assert spr.isJSONStr('{"f":false}');
	assert spr.isJSONStr('{"f":123.456}');
	assert spr.isJSONStr('{"f":""}');

	# TODO spr.isJSONStr() is NOT implemented and so always returns true
	#assert spr.isJSONStr('{');
	#assert spr.isJSONStr('}');
	#assert spr.isJSONStr('[');
	#assert spr.isJSONStr(']');
	#assert spr.isJSONStr('$');
	true;

local test_safeParseJSON() =
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",""), {"errors": [{"ERROR":
		"'JSON' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}], "result":
		null});
	
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","null"), { result: null, errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","true"), { result: true, errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","false"), { result: false, errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","123.456"), { result: 123.456, errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'""'), { result: '', errors: [] });
	
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","[]"), { result: [], errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","[null]"), { result: [null], errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","[true]"), { result: [true], errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","[false]"), { result: [false], errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","[123.456]"), { result: [123.456], errors:
		[] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'[""]'), { result: [''], errors: [] });
	
	assert std.assertEqual(spr.safeParseJSON("test",0,"f","{}"), { result: {}, errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'{"f":null}'), { result: {"f":null}, errors:
		 [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'{"f":true}'), { result: {"f":true}, errors:
		[] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'{"f":false}'), { result: {"f":false},
		errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'{"f":123.456}'), { result: {"f":123.456},
		errors: [] });
	assert std.assertEqual(spr.safeParseJSON("test",0,"f",'{"f":""}'), { result: {"f":''}, errors:
		[] });
	
	# TODO Validate bad JSON too
	true;

local test_safeParseString() =
	assert std.assertEqual(spr.safeParseString("test",0,"f","xxx"), { result: ":xxx", errors: [] });

	assert std.assertEqual(spr.safeParseString("test",0,"f","\\n"), { result: ":\n", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","z\\r"), { result: ":z\r", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","\\tn"), { result: ":\tn", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","\\\\n"), { result: ":\\n", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","r\\\\"), { result: ":r\\", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","\\'z"), { result: ":'z", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f","z\\'"), { result: ":z'", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f",'\\"z'), { result: ":\"z", errors: [] });
	assert std.assertEqual(spr.safeParseString("test",0,"f",'z\\"'), { result: ":z\"", errors: [] });

	assert std.assertEqual(spr.safeParseString("test",0,"f","\\n\\z\\t"), { result: ":\nz\t",
		errors: [ {"Field": "f", "Index": "0", "Source": "test", "WARN": "'string' value '\\n\\z\\t' : Do not escape z"} ] });

	assert std.assertEqual(spr.safeParseString("test",0,"f","z\\"), { result: null,
		errors: [ {"Field": "f", "Index": "0", "Source": "test", "ERROR": "'string' value 'z\\' : Cannot end with a single \\"} ] });
	true;

local test_safeParse() =
	assert std.assertEqual(spr.safeParse("test",0,"f","boolean","true"), { result: true, errors: [] });
	assert std.assertEqual(spr.safeParse("test",0,"f","number","123.456"), { result: 123.456, errors:
		[] });
	assert std.assertEqual(spr.safeParse("test",0,"f","int","42"), { result: 42, errors: [] });
	assert std.assertEqual(spr.safeParse("test",0,"f","hex","0xFF"), { result: 255, errors: [] });
	assert std.assertEqual(spr.safeParse("test",0,"f","json",'{"json":true}'), { result: {"json":true},
		errors: [] });
	assert std.assertEqual(spr.safeParse("test",0,"f","string","xxx"), { result: ":xxx", errors: [] });
	
	assert std.assertEqual(spr.safeParse("test",0,"f","boolean","Z"), {"errors":
		[{"ERROR": "'boolean' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null});
	assert std.assertEqual(spr.safeParse("test",0,"f","number","Z"), {"errors":
		[{"ERROR": "'number' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null});
	assert std.assertEqual(spr.safeParse("test",0,"f","int","Z"), {"errors":
		[{"ERROR": "'integer' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null});
	assert std.assertEqual(spr.safeParse("test",0,"f","hex","Z"), {"errors":
		[{"ERROR": "'hex' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null});
	assert std.assertEqual(spr.safeParse("test",0,"f","json",""), {"errors":
		[{"ERROR": "'JSON' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null});
	# "string" is always valid
	
	local et = spr.buildEnum("test", 'ad', ['a',null,'','d']).result;
	local bet = spr.buildBoolEnum("test", 'ab', ['a','b']).result;
	local cts = { et: et, bet: bet };
	assert std.assertEqual(spr.safeParse("test", 1,'f', 'et', 'a', cts), {errors: [], result: 0});
	assert std.assertEqual(spr.safeParse("test", 1,'f', 'et', '2', cts), {result: null, errors: [
		{ERROR: "'enum' value '2' is not valid", Field: "f", Index: "1", Source: "test"} ]});
	assert std.assertEqual(spr.safeParse("test", 1,'f', 'bet', 'a', cts), {errors: [], result: false});
	assert std.assertEqual(spr.safeParse("test", 1,'f', 'bet', 'true', cts), {errors: [], result:
		true});
	assert std.assertEqual(spr.safeParse("test", 1,'f', 'bet', 'x', cts), {result: null, errors: [
		{ERROR: "'enum' value 'x' is not valid", Field: "f", Index: "1", Source: "test"} ]});

	assert std.assertEqual(spr.safeParse("test",0,"f","complex","zzz"), {"errors":
		[{"ERROR": "'complex(unknown type)' value 'zzz' is not valid", "Field": "f", "Index": "0",
			"Source": "test"}], "result": null});
	assert std.assertEqual(spr.safeParse("test",0,"f","complex","zzz", {complex: false}), {"errors":
		[{"ERROR": "'complex(unknown custom type)' value 'zzz' is not valid", "Field": "f", "Index": "0",
			"Source": "test"}], "result": null});
	true;

local test_isIdentifier() =
	assert !spr.isIdentifier("");
	assert spr.isIdentifier("test");
	assert spr.isIdentifier("test123");
	assert !spr.isIdentifier("123test");
	assert !spr.isIdentifier("a.b");
	assert !spr.isIdentifier("5");

	assert spr.isIdentifier("x=y");

	assert spr.isIdentifier("!");
	assert spr.isIdentifier("%");
	assert spr.isIdentifier("&");
	assert spr.isIdentifier("*");
	assert spr.isIdentifier("+");
	assert spr.isIdentifier("-");
	assert spr.isIdentifier("/");
	assert spr.isIdentifier("<");
	assert spr.isIdentifier("=");
	assert spr.isIdentifier(">");
	assert spr.isIdentifier("?");
	assert spr.isIdentifier("^");
	assert spr.isIdentifier("|");
	assert spr.isIdentifier("~");
	assert spr.isIdentifier("$");
	assert spr.isIdentifier("#");
	assert spr.isIdentifier(";");
	assert spr.isIdentifier("@");
	assert spr.isIdentifier("°");
	assert spr.isIdentifier("\\");
	true;

local test_isIdentifierPath() =
	assert !spr.isIdentifierPath("");
	assert spr.isIdentifierPath("test");
	assert spr.isIdentifierPath("te_st");
	assert spr.isIdentifierPath("_test");
	assert spr.isIdentifierPath("test123");
	assert !spr.isIdentifierPath("123test");
	assert !spr.isIdentifierPath("5");
	assert !spr.isIdentifierPath("5.a");
	assert spr.isIdentifierPath("a.b");
	assert spr.isIdentifierPath("a.b.c");
	assert spr.isIdentifierPath("a.5");
	assert spr.isIdentifierPath("a.5.c");
	assert spr.isIdentifierPath("test123.b");
	assert !spr.isIdentifierPath("a.123test");

	assert spr.isIdentifierPath("<.=.>");
	true;

local test_tsv2TypedTSV() =
	assert std.assertEqual(spr.tsv2TypedTSV("test", spr.str2TSV('x\nz')), {"errors": [ ], "result":
		[["x"], ["z"]]});
	assert std.assertEqual(spr.tsv2TypedTSV("test", spr.str2TSV('x:int\n0')), {"errors": [ ], "result":
		[["x:int"], [0]]});
	assert std.assertEqual(spr.tsv2TypedTSV("test",
		spr.str2TSV(
			'b:boolean\tn:number\ti:int\th:hex\tj:json\ts:string\ntrue\t12.34\t42\t0xF\t[true]\tx')),
		{"errors": [ ], "result": [["b:boolean", "n:number", "i:int", "h:hex", "j:json", "s:string"],
			[true, 12.34, 42, 15, [true], "x"]]});
	assert std.assertEqual(spr.tsv2TypedTSV("test", 'x\nz'), {"errors": [ ], "result": [["x"],
		["z"]]});
	true;

local test_tsv2Obj() =
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('')), { "test": { result: null, errors:
		["FATAL: test is empty"] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('\n')), { "test": { result: null, errors:
		["FATAL: test has no field name defined in header row"] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('\tx\n')), { "test": { result: null, errors:
		["FATAL: test has empty field name(s) defined in header row"] } });
	#assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('x:int:string\n')), { "test": { result: null,
	#	errors:
	#	["FATAL: test has field name(s) that are multiple type separators [\"x:int:string\"]"] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('x:cat\n')), { "test": { result: null,
		errors:
		["FATAL: test has field(s) that use unsupported types [\"cat\"]"] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('€\n')), { "test": { result: null, errors:
		["FATAL: test has field name(s) that are not valid identifiers [\"€\"]"] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('a.b\ta.0\n')), { "test": { result: null,
		errors:
		["FATAL: test has field name(s) that are both objects and arrays [\"a\"]"] } });
	
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('a.b.c\nz')),
		{ "test": { result: [{a:{b:{c:'z'}}}], errors: [] } });
	assert std.assertEqual(spr.tsv2Obj("test",spr.str2TSV('a\tb.s\tc.0\nx\ty\tz')), { "test": { result:
		[{"a": "x", "b": {"s": "y"}, "c": ["z"]}], errors: [] } });
	
	local tsv = spr.tsv2TypedTSV("test",
		spr.str2TSV(
			'b:boolean\tn:number\ti:int\th:hex\tj:json\ts:string\ntrue\t12.34\t42\t0xF\t[true]\tx'));
	assert std.assertEqual(std.length(tsv.errors), 0);
	assert std.assertEqual(spr.tsv2Obj("test",tsv.result), {"test": {"errors": [ ], "result":
		[{"b": true, "h": 15, "i": 42, "j": [true], "n": 12.34, "s": "x"}]}});
	assert std.assertEqual(spr.tsv2Obj("test",'a\tb.s\tc.0\nx\ty\tz'), { "test": { result:
		[{"a": "x", "b": {"s": "y"}, "c": ["z"]}], errors: [] } });

	assert std.assertEqual(spr.tsv2Obj("test",'a.0.x\ta.0.y\nx0\ty0'), { "test": { result:
		[{"a": [{"x": "x0", "y": "y0"}]}], errors: [] } });
	true;

local test_buildEnum() =
	assert std.assertEqual(spr.buildEnum("test", 'ab', ['a',null,'','d']), {errors: [], result:
		{id2Label: ["A", '', '', "D"], label2Id: {"A": 0, "D": 3}}});
	assert std.assertEqual(spr.buildEnum("test", 'aa', ['a','A']), {errors: [
		'FATAL: test enum aa has label(s) defined multiple times: ["A", "A"]' ], result: null});
	assert std.assertEqual(spr.buildEnum("test", 'null', null), {errors: [
		"FATAL: test enum null labels is not an array: null" ], result: null});
	assert std.assertEqual(spr.buildEnum("test", 'nnt', [99,true]), {errors: [
		"FATAL: test enum nnt has bad label(s): [99, true]" ], result: null});
	assert std.assertEqual(spr.buildEnum("test", 'x', ['x']), {errors: [
		"FATAL: test enum x needs more than one label!" ], result: null});
	true;

local test_buildBoolEnum() =
	assert std.assertEqual(spr.buildBoolEnum("test", 'ab', ['a','b']), {errors: [], result:
		{id2Label: ["A", "B"]}});
	assert std.assertEqual(spr.buildBoolEnum("test", 'abc', ['a','b','c']), {errors: [
		"FATAL: test 'bool' enum abc needs TWO labels!" ], result: null});
	assert std.assertEqual(spr.buildBoolEnum("test", 'anc', ['a',null,'c']), {errors: [
		"FATAL: test 'bool' enum anc labels must be at [0,1]!" ], result: null});
	true;

local test_isEnumType() =
	assert spr.isEnumType({id2Label: ["A", '', '', "D"], label2Id: {"A": 0, "D": 3}});
	assert spr.isEnumType({id2Label: ["A", "B"]});
	assert !spr.isEnumType('abc');
	true;

local test_labelToId() =
	local et = spr.buildEnum("test", 'and', ['a',null,'','d']).result;
	assert std.assertEqual(spr.labelToId(et,'a'), 0);
	assert std.assertEqual(spr.labelToId(et,'d'), 3);
	assert std.assertEqual(spr.labelToId(et,true), null);
	local bet = spr.buildBoolEnum("test", 'ab', ['a','b']).result;
	assert std.assertEqual(spr.labelToId(bet,'a'), false);
	assert std.assertEqual(spr.labelToId(bet,'b'), true);
	assert std.assertEqual(spr.labelToId(bet,true), null);
	true;

local test_idToLabel() =
	local et = spr.buildEnum("test", 'and', ['a',null,'','d']).result;
	assert std.assertEqual(spr.idToLabel(et,0), 'A');
	assert std.assertEqual(spr.idToLabel(et,3), 'D');
	assert std.assertEqual(spr.idToLabel(et,true), null);
	local bet = spr.buildBoolEnum("test", 'ab', ['a','b']).result;
	assert std.assertEqual(spr.idToLabel(bet,false), 'A');
	assert std.assertEqual(spr.idToLabel(bet,true), 'B');
	assert std.assertEqual(spr.idToLabel(bet,1), null);
	true;

local test_safeParseEnum() =
	local et = spr.buildEnum("test", 'and', ['a',null,'','d']).result;
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, 'a'), {errors: [], result: 0});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, 'D'), {errors: [], result: 3});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, '0'), {errors: [], result: 0});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, '3'), {errors: [], result: 3});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, '2'), {result: null, errors: [
		{ERROR: "'enum' value '2' is not valid", Field: "f", Index: "1", Source: "test"} ]});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', et, 'x'), {result: null, errors: [
		{ERROR: "'enum' value 'x' is not valid", Field: "f", Index: "1", Source: "test"} ]});
	local bet = spr.buildBoolEnum("test", 'ab', ['a','b']).result;
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', bet, 'a'), {errors: [], result: false});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', bet, 'B'), {errors: [], result: true});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', bet, 'false'), {errors: [], result: false});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', bet, 'true'), {errors: [], result: true});
	assert std.assertEqual(spr.safeParseEnum("test", 1,'f', bet, 'x'), {result: null, errors: [
		{ERROR: "'enum' value 'x' is not valid", Field: "f", Index: "1", Source: "test"} ]});
	true;

local test_translateOperators() =
	assert std.assertEqual(spr.translateOperators('a!7'), 'aExclamationMark7');

	assert std.assertEqual(spr.translateOperators('%&*+'), 'PercentSignAmpersandAsteriskPlusSign');
	assert std.assertEqual(spr.translateOperators('-/<='), 'MinusSignSlashLessThanSignEqualsSign');
	assert std.assertEqual(spr.translateOperators('>?^|'), 'GreaterThanSignQuestionMarkCaretVerticalLine');
	assert std.assertEqual(spr.translateOperators('~$#;@'), 'TildeDollarSignNumberSignSemiColonAtSign');
	assert std.assertEqual(spr.translateOperators('°\\'), 'DegreeBackslash');
	true;

{
	result:
		test_str2Lines() && test_str2TSV() && test_isJSONStr() && test_safeParseJSON() && test_safeParseString() &&
		test_safeParse() && test_isIdentifier() && test_isIdentifierPath() && test_tsv2TypedTSV() &&
		test_tsv2Obj() && test_buildEnum() && test_buildBoolEnum() && test_isEnumType() &&
		test_labelToId() && test_idToLabel() && test_safeParseEnum() && test_translateOperators()
}
