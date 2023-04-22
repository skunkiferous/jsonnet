local spr = import 'spr.libjsonnet';

local test_tsv2Obj() =
	local expected = {"persons.tsv": {errors:[], result: [{age: "33", email:
		["john@test.com","john@gmail.com"], name: "John"},{age: "24", name: "Mary", pet:
			{age: "3",name: "Fluffy",race: "cat"}}]}};
	local actual = spr.tsv2Obj('persons.tsv', spr.str2TSV(importstr 'persons.tsv'));
	std.assertEqual(expected, actual);

{
	result: test_tsv2Obj()
}
