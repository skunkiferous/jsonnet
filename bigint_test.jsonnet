local bigint = import 'bigint.libjsonnet';

local test_MIN_SAFE_INTEGER() =
	assert std.type(bigint.MIN_SAFE_INTEGER) == "number";
	assert std.toString(bigint.MIN_SAFE_INTEGER) == "-9007199254740991";
	true;

local test_MAX_SAFE_INTEGER() =
	assert std.type(bigint.MAX_SAFE_INTEGER) == "number";
	assert std.toString(bigint.MAX_SAFE_INTEGER) == "9007199254740991";
	true;

local test_isBooleanStr() =
	assert bigint.isBooleanStr("true");
	assert bigint.isBooleanStr("false");
	assert !bigint.isBooleanStr("True");
	assert !bigint.isBooleanStr("False");
	assert !bigint.isBooleanStr("TRUE");
	assert !bigint.isBooleanStr("FALSE");
	assert !bigint.isBooleanStr("0");
	assert !bigint.isBooleanStr("1");
	assert !bigint.isBooleanStr("");
	assert !bigint.isBooleanStr("1.2");
	true;

local test_isUIntegerStr() =
	assert bigint.isUIntegerStr("0");
	assert !bigint.isUIntegerStr("-5");
	assert bigint.isUIntegerStr("5");
	assert !bigint.isUIntegerStr("-9223372036854775808");
	assert bigint.isUIntegerStr("9223372036854775807");
	assert !bigint.isUIntegerStr("a");
	assert !bigint.isUIntegerStr("");
	assert !bigint.isUIntegerStr("1.2");
	assert !bigint.isUIntegerStr("-1.2");
	true;

local test_isIntegerStr() =
	assert bigint.isIntegerStr("0");
	assert bigint.isIntegerStr("-5");
	assert bigint.isIntegerStr("5");
	assert bigint.isIntegerStr("-9223372036854775808");
	assert bigint.isIntegerStr("9223372036854775807");
	assert !bigint.isIntegerStr("a");
	assert !bigint.isIntegerStr("");
	assert !bigint.isIntegerStr("1.2");
	assert !bigint.isIntegerStr("-1.2");
	true;

local test_isNumberStr() =
	assert bigint.isNumberStr("0");
	assert bigint.isNumberStr("-5");
	assert bigint.isNumberStr("5");
	assert bigint.isNumberStr("-9223372036854775808");
	assert bigint.isNumberStr("9223372036854775807");
	assert bigint.isNumberStr("1.2");
	assert bigint.isNumberStr("-1.2");
	assert !bigint.isNumberStr("a");
	assert !bigint.isNumberStr("");
	true;

local test_isHexStr() =
	assert bigint.isHexStr("0x0");
	assert bigint.isHexStr("0X0");
	assert bigint.isHexStr("0x5");
	assert bigint.isHexStr("0x0123456789aBcDeF");
	assert !bigint.isHexStr("0x-5");
	assert !bigint.isHexStr("0");
	assert !bigint.isHexStr("-5");
	assert !bigint.isHexStr("5");
	assert !bigint.isHexStr("-9223372036854775808");
	assert !bigint.isHexStr("9223372036854775807");
	assert !bigint.isHexStr("a");
	assert !bigint.isHexStr("");
	assert !bigint.isHexStr("1.2");
	assert !bigint.isHexStr("-1.2");
	true;

local test_isNotHugeInt() =
	assert bigint.isNotHugeInt(0);
	assert bigint.isNotHugeInt(-5);
	assert bigint.isNotHugeInt(5);
	assert bigint.isNotHugeInt(-9007199254740991);
	assert bigint.isNotHugeInt(9007199254740991);
	assert !bigint.isNotHugeInt(-9007199254740992);
	assert !bigint.isNotHugeInt(9007199254740992);
	assert !bigint.isNotHugeInt(-9223372036854775808);
	assert !bigint.isNotHugeInt(9223372036854775807);
	true;

local test_safeParseInteger() =
	assert bigint.safeParseInteger("test",0,"f","0") == { result: 0, errors: [] };
	assert bigint.safeParseInteger("test",0,"f","-5") == { result: -5, errors: [] };
	assert bigint.safeParseInteger("test",0,"f","5") == { result: 5, errors: [] };
	assert bigint.safeParseInteger("test",0,"f","-9007199254740991") ==
		{ result: -9007199254740991, errors: [] };
	assert bigint.safeParseInteger("test",0,"f","9007199254740991") ==
		{ result: 9007199254740991, errors: [] };
	assert bigint.safeParseInteger("test",0,"f","-9007199254740992") == {"result": "-9007199254740992",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'integer' value '-9007199254740992' cannot be safely represented as a number."}]};
	assert bigint.safeParseInteger("test",0,"f","9007199254740992") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '9007199254740992' cannot be safely represented as a number."}],
		"result": "9007199254740992"};
	assert bigint.safeParseInteger("test",0,"f","-9223372036854775808") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '-9223372036854775808' cannot be safely represented as a number."}],
		"result": "-9223372036854775808"};
	assert bigint.safeParseInteger("test",0,"f","9223372036854775807") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '9223372036854775807' cannot be safely represented as a number."}],
		"result": "9223372036854775807"};
	assert bigint.safeParseInteger("test",0,"f","") == {"errors":
		[{"ERROR": "'integer' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseInteger("test",0,"f","Z") == {"errors":
		[{"ERROR": "'integer' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	true;

local test_safeParseHex() =
	assert bigint.safeParseHex("test",0,"f","0x0") == { result: 0, errors: [] };
	assert bigint.safeParseHex("test",0,"f","0X5") == { result: 5, errors: [] };
	assert bigint.safeParseHex("test",0,"f","") == {"errors":
		[{"ERROR": "'hex' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseHex("test",0,"f","0") == {"errors":
		[{"ERROR": "'hex' value '0' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseHex("test",0,"f","-0x5") == {"errors":
		[{"ERROR": "'hex' value '-0x5' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseHex("test",0,"f","Z") == {"errors":
		[{"ERROR": "'hex' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseHex("test",0,"f","0xZ") == {"errors":
		[{"ERROR": "'hex' value '0xZ' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseHex("test",0,"f","0x1FFFFFFFFFFFFF") == { result: 9007199254740991, errors: [] };
	assert bigint.safeParseHex("test",0,"f","0x20000000000000") == {"result": "0x20000000000000",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'hex' value '0x20000000000000' cannot be safely represented as a number."}]};
	assert bigint.safeParseHex("test",0,"f","0xFFFFFFFFFFFFFFFF") == {"result": "0xFFFFFFFFFFFFFFFF",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'hex' value '0xFFFFFFFFFFFFFFFF' cannot be safely represented as a number."}]};
	true;

local test_safeParseNumber() =
	assert bigint.safeParseNumber("test",0,"f","0.0") == { result: 0, errors: [] };
	assert bigint.safeParseNumber("test",0,"f","123.456") == { result: 123.456, errors: [] };
	assert bigint.safeParseNumber("test",0,"f","-123.456") == { result: -123.456, errors: [] };
	assert bigint.safeParseNumber("test",0,"f","-9007199254740991.0") ==
		{ result: -9007199254740991, errors: [] };
	assert bigint.safeParseNumber("test",0,"f","9007199254740991.0") ==
		{ result: 9007199254740991, errors: [] };
	assert bigint.safeParseNumber("test",0,"f","123,456") == {"errors":
		[{"ERROR": "'number' value '123,456' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseNumber("test",0,"f","") == {"errors":
		[{"ERROR": "'number' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseNumber("test",0,"f","Z") == {"errors":
		[{"ERROR": "'number' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	true;

local test_safeParseBoolean() =
	assert bigint.safeParseBoolean("test",0,"f","true") == { result: true, errors: [] };
	assert bigint.safeParseBoolean("test",0,"f","false") == { result: false, errors: [] };
	assert bigint.safeParseBoolean("test",0,"f","True") == {"errors":
		[{"ERROR": "'boolean' value 'True' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","False") == {"errors":
		[{"ERROR": "'boolean' value 'False' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","TRUE") == {"errors":
		[{"ERROR": "'boolean' value 'TRUE' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","FALSE") == {"errors":
		[{"ERROR": "'boolean' value 'FALSE' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","123,456") == {"errors":
		[{"ERROR": "'boolean' value '123,456' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","") == {"errors":
		[{"ERROR": "'boolean' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert bigint.safeParseBoolean("test",0,"f","Z") == {"errors":
		[{"ERROR": "'boolean' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	true;

local test_sign() =
	assert std.assertEqual(bigint.sign(-5), -1);
	assert std.assertEqual(bigint.sign(0), 0);
	assert std.assertEqual(bigint.sign(5), 1);
	assert std.assertEqual(bigint.sign('-5'), -1);
	assert std.assertEqual(bigint.sign('0'), 0);
	assert std.assertEqual(bigint.sign('5'), 1);
	true;

local test_cmp() =
	assert std.assertEqual(bigint.cmp(0,0), 0);
	assert std.assertEqual(bigint.cmp(0,'0'), 0);
	assert std.assertEqual(bigint.cmp('0',0), 0);
	assert std.assertEqual(bigint.cmp('0','0'), 0);

	assert std.assertEqual(bigint.cmp(5,5), 0);
	assert std.assertEqual(bigint.cmp('5',5), 0);
	assert std.assertEqual(bigint.cmp(5,'5'), 0);
	assert std.assertEqual(bigint.cmp('5','5'), 0);
	assert std.assertEqual(bigint.cmp(-5,'-5'), 0);
	assert std.assertEqual(bigint.cmp('-5',-5), 0);
	assert std.assertEqual(bigint.cmp('-5','-5'), 0);

	assert std.assertEqual(bigint.cmp(5,-5), 1);
	assert std.assertEqual(bigint.cmp(5,'-5'), 1);
	assert std.assertEqual(bigint.cmp('5',-5), 1);
	assert std.assertEqual(bigint.cmp('5','-5'), 1);

	assert std.assertEqual(bigint.cmp(-5,5), -1);
	assert std.assertEqual(bigint.cmp(-5,'5'), -1);
	assert std.assertEqual(bigint.cmp('-5',5), -1);
	assert std.assertEqual(bigint.cmp('-5','5'), -1);

	assert std.assertEqual(bigint.cmp(0,1), -1);
	assert std.assertEqual(bigint.cmp('0',1), -1);
	assert std.assertEqual(bigint.cmp(0,'1'), -1);
	assert std.assertEqual(bigint.cmp('0','1'), -1);

	assert std.assertEqual(bigint.cmp(1,0), 1);
	assert std.assertEqual(bigint.cmp('1',0), 1);
	assert std.assertEqual(bigint.cmp(1,'0'), 1);
	assert std.assertEqual(bigint.cmp('1','0'), 1);

	assert std.assertEqual(bigint.cmp(-1,0), -1);
	assert std.assertEqual(bigint.cmp('-1',0), -1);
	assert std.assertEqual(bigint.cmp(-1,'0'), -1);
	assert std.assertEqual(bigint.cmp('-1','0'), -1);
	true;

local test_cmp2() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert !bigint.lt(0,-1);
	assert bigint.lt(0,1);
	assert !bigint.lt(1,1);
	assert !bigint.lt(1,0);
	assert bigint.lt(-1,0);

	assert !bigint.le(0,-1);
	assert bigint.le(0,1);
	assert bigint.le(1,1);
	assert !bigint.le(1,0);
	assert bigint.le(-1,0);

	assert bigint.gt(0,-1);
	assert !bigint.gt(0,1);
	assert !bigint.gt(1,1);
	assert bigint.gt(1,0);
	assert !bigint.gt(-1,0);

	assert bigint.ge(0,-1);
	assert !bigint.ge(0,1);
	assert bigint.ge(1,1);
	assert bigint.ge(1,0);
	assert !bigint.ge(-1,0);

	assert !bigint.eq(0,-1);
	assert !bigint.eq(0,1);
	assert bigint.eq(1,1);
	assert !bigint.eq(1,0);
	assert !bigint.eq(-1,0);

	assert bigint.ne(0,-1);
	assert bigint.ne(0,1);
	assert !bigint.ne(1,1);
	assert bigint.ne(1,0);
	assert bigint.ne(-1,0);
	true;

local test_min() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert std.assertEqual(bigint.min(1,0), 0);
	assert std.assertEqual(bigint.min(0,1), 0);
	assert std.assertEqual(bigint.min(-1,0), -1);
	assert std.assertEqual(bigint.min(0,-1), -1);
	true;

local test_max() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert std.assertEqual(bigint.max(1,0), 1);
	assert std.assertEqual(bigint.max(0,1), 1);
	assert std.assertEqual(bigint.max(-1,0), 0);
	assert std.assertEqual(bigint.max(0,-1), 0);
	true;

{
	result:
		test_MIN_SAFE_INTEGER() && test_MAX_SAFE_INTEGER() && test_isBooleanStr() && test_isUIntegerStr() &&
		test_isIntegerStr() && test_isNumberStr() && test_isHexStr() && test_isNotHugeInt() &&
		test_safeParseInteger() && test_safeParseHex() && test_safeParseNumber() && test_safeParseBoolean() &&
		test_sign() && test_cmp() && test_cmp2() && test_min() && test_max()
}
