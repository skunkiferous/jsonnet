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

local test_tsv2Obj() =
	local expected = {"persons.tsv": {errors:[], result: [{age: "33", email:
		["john@test.com","john@gmail.com"], name: "John"},{age: "24", name: "Mary", pet:
			{age: "3",name: "Fluffy",race: "cat"}}]}};
	local actual = spr.tsv2Obj('persons.tsv', spr.str2TSV(importstr 'persons.tsv'));
	std.assertEqual(expected, actual);

{
	result: test_tsv2Obj()
}
