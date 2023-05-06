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

# Runs all tests

local log_test = import 'log_test.jsonnet';
local utl_test = import 'utl_test.jsonnet';
local int_test = import 'int_test.jsonnet';
local spr_test = import 'spr_test.jsonnet';
local persons_test = import 'persons_test.jsonnet';

{
	result: log_test.result && utl_test.result && int_test.result && spr_test.result && persons_test.result,
}
