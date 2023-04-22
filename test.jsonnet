# Runs all tests

local utl_test = import 'utl_test.jsonnet';
local bigint_test = import 'bigint_test.jsonnet';
local spr_test = import 'spr_test.jsonnet';
local persons_test = import 'persons_test.jsonnet';

{
	result: utl_test.result && bigint_test.result && spr_test.result && persons_test.result,
}
