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

local log = import 'log.libjsonnet';

local test_log() =
	assert std.assertEqual(log.info('x'), {INFO: "x"});
	assert std.assertEqual(log.info('x', true), {INFO: "x", data: true});
	assert std.assertEqual(log.info('x', {y: true}), {INFO: "x", y: true});
	assert std.assertEqual(log.warn('x'), {WARN: "x"});
	assert std.assertEqual(log.warn('x', true), {WARN: "x", data: true});
	assert std.assertEqual(log.warn('x', {y: true}), {WARN: "x", y: true});
	assert std.assertEqual(log.err('x'), {ERROR: "x"});
	assert std.assertEqual(log.err('x', true), {ERROR: "x", data: true});
	assert std.assertEqual(log.err('x', {y: true}), {ERROR: "x", y: true});
	assert std.assertEqual(log.fatal('x'), {FATAL: "x"});
	assert std.assertEqual(log.fatal('x', true), {FATAL: "x", data: true});
	assert std.assertEqual(log.fatal('x', {y: true}), {FATAL: "x", y: true});
	assert std.assertEqual(log.info(''), {INFO: '""'});
	assert std.assertEqual(log.info([0]), {INFO: "[0]"});
	true;

local test_badVal() =
	assert std.assertEqual(log.badVal('s', 0, 'f', 'int', ['john']), {ERROR:
		"'int' value '[\"john\"]' is not valid", Field: "f", Index: "0", Source: "s"});
	true;

local test_warnVal() =
	assert std.assertEqual(log.warnVal('s', 0, 'f', 'int', 42, 'is the Ultimate Answer'), {WARN:
		"'int' value '42' is the Ultimate Answer", Field: "f", Index: "0", Source: "s"});
	true;

local test_hasErrors() =
	assert !log.hasErrors({});
	assert !log.hasErrors({"errors": []});
	assert !log.hasErrors({"errors": [log.info('x')]});
	assert !log.hasErrors({"errors": [log.warn('x')]});
	assert log.hasErrors({"errors": [log.err('x')]});
	assert log.hasErrors({"errors": [log.fatal('x')]});

	assert !log.hasErrors([]);
	assert !log.hasErrors([{}]);
	assert !log.hasErrors([{"errors": []}]);
	assert !log.hasErrors([{"errors": [log.info('x')]}]);
	assert !log.hasErrors([{"errors": [log.warn('x')]}]);
	assert log.hasErrors([{"errors": [log.err('x')]}]);
	assert log.hasErrors([{"errors": [log.fatal('x')]}]);
	true;

local test_mergeOnlyErrors() =
	assert std.assertEqual(log.mergeOnlyErrors([{ result: true, errors: ['a'] }, { result: false,
		errors: ['b'] }]), { result: [true, false], errors: ['a','b'] });
	true;

local test_mergeContentAndErrors() =
	assert std.assertEqual(log.mergeContentAndErrors([{ result: {a:'a'}, errors: ['a'] },
		{ result: {b:'b'}, errors: ['b'] }]), { result: {a:'a',b:'b'}, errors: ['a','b'] });
	true;

{
	result: test_log() && test_badVal() && test_warnVal() && test_hasErrors() &&
		test_mergeOnlyErrors() && test_mergeContentAndErrors()
}
