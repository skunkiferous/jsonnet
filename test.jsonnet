# Runs all tests

local log_test = import 'log_test.jsonnet';
local utl_test = import 'utl_test.jsonnet';
local int_test = import 'int_test.jsonnet';
local spr_test = import 'spr_test.jsonnet';
local persons_test = import 'persons_test.jsonnet';

{
	result: log_test.result && utl_test.result && int_test.result && spr_test.result && persons_test.result,
}
