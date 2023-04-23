local log = import 'log.libjsonnet';

local test_log() =
	assert log.info('x') == {INFO: "x"};
	assert log.info('x', true) == {INFO: "x", data: true};
	assert log.info('x', {y: true}) == {INFO: "x", y: true};
	assert log.warn('x') == {WARN: "x"};
	assert log.warn('x', true) == {WARN: "x", data: true};
	assert log.warn('x', {y: true}) == {WARN: "x", y: true};
	assert log.err('x') == {ERROR: "x"};
	assert log.err('x', true) == {ERROR: "x", data: true};
	assert log.err('x', {y: true}) == {ERROR: "x", y: true};
	assert log.fatal('x') == {FATAL: "x"};
	assert log.fatal('x', true) == {FATAL: "x", data: true};
	assert log.fatal('x', {y: true}) == {FATAL: "x", y: true};
	assert log.info('') == {INFO: '""'};
	assert log.info([0]) == {INFO: "[0]"};
	true;

local test_badVal() =
	assert log.badVal('s', 0, 'f', 'int', ['john']) == {ERROR: "'int' value '[\"john\"]' is not valid",
		Field: "f", Index: "0", Source: "s"};
	true;

local test_warnVal() =
	assert log.warnVal('s', 0, 'f', 'int', 42, 'is the Ultimate Answer') == {WARN:
		"'int' value '42' is the Ultimate Answer", Field: "f", Index: "0", Source: "s"};
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
	assert log.mergeOnlyErrors([{ result: true, errors: ['a'] }, { result: false, errors: ['b'] }]) ==
		{ result: [true, false], errors: ['a','b'] };
	true;

local test_mergeContentAndErrors() =
	assert log.mergeContentAndErrors([{ result: {a:'a'}, errors: ['a'] },
		{ result: {b:'b'}, errors: ['b'] }]) == { result: {a:'a',b:'b'}, errors: ['a','b'] };
	true;

{
	result: test_log() && test_badVal() && test_warnVal() && test_hasErrors() && test_mergeOnlyErrors() &&
		test_mergeContentAndErrors()
}
