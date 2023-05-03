local int = import 'int.libjsonnet';

local BIG_INT_STR = "19000000000000000000";
local BIG_NEG_STR = "-19000000000000000000";

local test_MIN_SAFE_INTEGER() =
	assert std.type(int.MIN_SAFE_INTEGER) == "number";
	assert std.toString(int.MIN_SAFE_INTEGER) == "-9007199254740991";
	true;

local test_MAX_SAFE_INTEGER() =
	assert std.type(int.MAX_SAFE_INTEGER) == "number";
	assert std.toString(int.MAX_SAFE_INTEGER) == "9007199254740991";
	true;

local test_isBooleanStr() =
	assert int.isBooleanStr("true");
	assert int.isBooleanStr("false");
	assert !int.isBooleanStr("True");
	assert !int.isBooleanStr("False");
	assert !int.isBooleanStr("TRUE");
	assert !int.isBooleanStr("FALSE");
	assert !int.isBooleanStr("0");
	assert !int.isBooleanStr("1");
	assert !int.isBooleanStr("");
	assert !int.isBooleanStr("1.2");
	true;

local test_isUIntegerStr() =
	assert int.isUIntegerStr("0");
	assert !int.isUIntegerStr("-5");
	assert int.isUIntegerStr("5");
	assert !int.isUIntegerStr("-9223372036854775808");
	assert int.isUIntegerStr("9223372036854775807");
	assert !int.isUIntegerStr("a");
	assert !int.isUIntegerStr("");
	assert !int.isUIntegerStr("1.2");
	assert !int.isUIntegerStr("-1.2");
	assert int.isUIntegerStr(BIG_INT_STR);
	assert !int.isUIntegerStr(BIG_NEG_STR);
	true;

local test_isIntegerStr() =
	assert int.isIntegerStr("0");
	assert int.isIntegerStr("-5");
	assert int.isIntegerStr("5");
	assert int.isIntegerStr("-9223372036854775808");
	assert int.isIntegerStr("9223372036854775807");
	assert !int.isIntegerStr("a");
	assert !int.isIntegerStr("");
	assert !int.isIntegerStr("1.2");
	assert !int.isIntegerStr("-1.2");
	assert int.isIntegerStr(BIG_INT_STR);
	assert int.isIntegerStr(BIG_NEG_STR);
	true;

local test_isNumberStr() =
	assert int.isNumberStr("0");
	assert int.isNumberStr("-5");
	assert int.isNumberStr("5");
	assert int.isNumberStr("-9223372036854775808");
	assert int.isNumberStr("9223372036854775807");
	assert int.isNumberStr("1.2");
	assert int.isNumberStr("-1.2");
	assert !int.isNumberStr("a");
	assert !int.isNumberStr("");
	assert int.isNumberStr(BIG_INT_STR);
	assert int.isNumberStr(BIG_NEG_STR);
	true;

local test_isHexStr() =
	assert int.isHexStr("0x0");
	assert int.isHexStr("0X0");
	assert int.isHexStr("0x5");
	assert int.isHexStr("0x0123456789aBcDeF");
	assert !int.isHexStr("0x-5");
	assert !int.isHexStr("0");
	assert !int.isHexStr("-5");
	assert !int.isHexStr("5");
	assert !int.isHexStr("-9223372036854775808");
	assert !int.isHexStr("9223372036854775807");
	assert !int.isHexStr("a");
	assert !int.isHexStr("");
	assert !int.isHexStr("1.2");
	assert !int.isHexStr("-1.2");
	true;

local test_isNotHugeInt() =
	assert int.isNotHugeInt(0);
	assert int.isNotHugeInt(-5);
	assert int.isNotHugeInt(5);
	assert int.isNotHugeInt(-9007199254740991);
	assert int.isNotHugeInt(9007199254740991);
	assert !int.isNotHugeInt(-9007199254740992);
	assert !int.isNotHugeInt(9007199254740992);
	assert !int.isNotHugeInt(-9223372036854775808);
	assert !int.isNotHugeInt(9223372036854775807);
	true;

local test_safeParseInteger() =
	assert int.safeParseInteger("test",0,"f","0") == { result: 0, errors: [] };
	assert int.safeParseInteger("test",0,"f","-5") == { result: -5, errors: [] };
	assert int.safeParseInteger("test",0,"f","5") == { result: 5, errors: [] };
	assert int.safeParseInteger("test",0,"f","-9007199254740991") ==
		{ result: -9007199254740991, errors: [] };
	assert int.safeParseInteger("test",0,"f","9007199254740991") ==
		{ result: 9007199254740991, errors: [] };
	assert int.safeParseInteger("test",0,"f","-9007199254740992") == {"result": "-9007199254740992",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'integer' value '-9007199254740992' cannot be safely represented as a number."}]};
	assert int.safeParseInteger("test",0,"f","9007199254740992") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '9007199254740992' cannot be safely represented as a number."}],
		"result": "9007199254740992"};
	assert int.safeParseInteger("test",0,"f","-9223372036854775808") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '-9223372036854775808' cannot be safely represented as a number."}],
		"result": "-9223372036854775808"};
	assert int.safeParseInteger("test",0,"f","9223372036854775807") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '9223372036854775807' cannot be safely represented as a number."}],
		"result": "9223372036854775807"};
	assert int.safeParseInteger("test",0,"f","") == {"errors":
		[{"ERROR": "'integer' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseInteger("test",0,"f","Z") == {"errors":
		[{"ERROR": "'integer' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseInteger("test",0,"f","-0009007199254740992") == {"result": "-9007199254740992",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'integer' value '-0009007199254740992' cannot be safely represented as a number."}]};
	assert int.safeParseInteger("test",0,"f","009007199254740992") == {"errors":
		[{"Field": "f", "Index": "0", "Source": "test",
		"WARN": "'integer' value '009007199254740992' cannot be safely represented as a number."}],
		"result": "9007199254740992"};
	true;

local test_safeParseHex() =
	assert int.safeParseHex("test",0,"f","0x0") == { result: 0, errors: [] };
	assert int.safeParseHex("test",0,"f","0X5") == { result: 5, errors: [] };
	assert int.safeParseHex("test",0,"f","") == {"errors":
		[{"ERROR": "'hex' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseHex("test",0,"f","0") == {"errors":
		[{"ERROR": "'hex' value '0' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseHex("test",0,"f","-0x5") == {"errors":
		[{"ERROR": "'hex' value '-0x5' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseHex("test",0,"f","Z") == {"errors":
		[{"ERROR": "'hex' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseHex("test",0,"f","0xZ") == {"errors":
		[{"ERROR": "'hex' value '0xZ' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseHex("test",0,"f","0x1FFFFFFFFFFFFF") == { result: 9007199254740991, errors: [] };
	assert int.safeParseHex("test",0,"f","0x20000000000000") == {"result": "0x20000000000000",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'hex' value '0x20000000000000' cannot be safely represented as a number."}]};
	assert int.safeParseHex("test",0,"f","0xFFFFFFFFFFFFFFFF") == {"result": "0xFFFFFFFFFFFFFFFF",
		"errors": [{"Field": "f", "Index": "0", "Source": "test", "WARN":
		"'hex' value '0xFFFFFFFFFFFFFFFF' cannot be safely represented as a number."}]};
	true;

local test_safeParseNumber() =
	assert int.safeParseNumber("test",0,"f","0.0") == { result: 0, errors: [] };
	assert int.safeParseNumber("test",0,"f","123.456") == { result: 123.456, errors: [] };
	assert int.safeParseNumber("test",0,"f","-123.456") == { result: -123.456, errors: [] };
	assert int.safeParseNumber("test",0,"f","-9007199254740991.0") ==
		{ result: -9007199254740991, errors: [] };
	assert int.safeParseNumber("test",0,"f","9007199254740991.0") ==
		{ result: 9007199254740991, errors: [] };
	assert int.safeParseNumber("test",0,"f","123,456") == {"errors":
		[{"ERROR": "'number' value '123,456' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseNumber("test",0,"f","") == {"errors":
		[{"ERROR": "'number' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseNumber("test",0,"f","Z") == {"errors":
		[{"ERROR": "'number' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	true;

local test_safeParseBoolean() =
	assert int.safeParseBoolean("test",0,"f","true") == { result: true, errors: [] };
	assert int.safeParseBoolean("test",0,"f","false") == { result: false, errors: [] };
	assert int.safeParseBoolean("test",0,"f","True") == {"errors":
		[{"ERROR": "'boolean' value 'True' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","False") == {"errors":
		[{"ERROR": "'boolean' value 'False' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","TRUE") == {"errors":
		[{"ERROR": "'boolean' value 'TRUE' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","FALSE") == {"errors":
		[{"ERROR": "'boolean' value 'FALSE' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","123,456") == {"errors":
		[{"ERROR": "'boolean' value '123,456' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","") == {"errors":
		[{"ERROR": "'boolean' value '\"\"' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	assert int.safeParseBoolean("test",0,"f","Z") == {"errors":
		[{"ERROR": "'boolean' value 'Z' is not valid", "Field": "f", "Index": "0", "Source": "test"}],
		"result": null};
	true;

local test_sign() =
	assert std.assertEqual(int.sign(-5), -1);
	assert std.assertEqual(int.sign(0), 0);
	assert std.assertEqual(int.sign(5), 1);
	assert std.assertEqual(int.sign('-5'), -1);
	assert std.assertEqual(int.sign('0'), 0);
	assert std.assertEqual(int.sign('5'), 1);
	assert std.assertEqual(int.sign(BIG_INT_STR), 1);
	assert std.assertEqual(int.sign(BIG_NEG_STR), -1);
	true;

local test_cmp() =
	assert std.assertEqual(int.cmp(0,0), 0);
	assert std.assertEqual(int.cmp(0,'0'), 0);
	assert std.assertEqual(int.cmp('0',0), 0);
	assert std.assertEqual(int.cmp('0','0'), 0);

	assert std.assertEqual(int.cmp(5,5), 0);
	assert std.assertEqual(int.cmp('5',5), 0);
	assert std.assertEqual(int.cmp(5,'5'), 0);
	assert std.assertEqual(int.cmp('5','5'), 0);
	assert std.assertEqual(int.cmp(-5,'-5'), 0);
	assert std.assertEqual(int.cmp('-5',-5), 0);
	assert std.assertEqual(int.cmp('-5','-5'), 0);

	assert std.assertEqual(int.cmp(5,-5), 1);
	assert std.assertEqual(int.cmp(5,'-5'), 1);
	assert std.assertEqual(int.cmp('5',-5), 1);
	assert std.assertEqual(int.cmp('5','-5'), 1);

	assert std.assertEqual(int.cmp(-5,5), -1);
	assert std.assertEqual(int.cmp(-5,'5'), -1);
	assert std.assertEqual(int.cmp('-5',5), -1);
	assert std.assertEqual(int.cmp('-5','5'), -1);

	assert std.assertEqual(int.cmp(0,1), -1);
	assert std.assertEqual(int.cmp('0',1), -1);
	assert std.assertEqual(int.cmp(0,'1'), -1);
	assert std.assertEqual(int.cmp('0','1'), -1);

	assert std.assertEqual(int.cmp(1,0), 1);
	assert std.assertEqual(int.cmp('1',0), 1);
	assert std.assertEqual(int.cmp(1,'0'), 1);
	assert std.assertEqual(int.cmp('1','0'), 1);

	assert std.assertEqual(int.cmp(-1,0), -1);
	assert std.assertEqual(int.cmp('-1',0), -1);
	assert std.assertEqual(int.cmp(-1,'0'), -1);
	assert std.assertEqual(int.cmp('-1','0'), -1);

	assert std.assertEqual(int.cmp(BIG_INT_STR,BIG_NEG_STR), 1);
	assert std.assertEqual(int.cmp(BIG_NEG_STR,BIG_INT_STR), -1);
	true;

local test_cmp2() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert !int.lt(0,-1);
	assert int.lt(0,1);
	assert !int.lt(1,1);
	assert !int.lt(1,0);
	assert int.lt(-1,0);
	assert int.lt(BIG_NEG_STR,0);
	assert !int.lt(BIG_INT_STR,0);

	assert !int.le(0,-1);
	assert int.le(0,1);
	assert int.le(1,1);
	assert !int.le(1,0);
	assert int.le(-1,0);
	assert int.le(BIG_NEG_STR,0);
	assert !int.le(BIG_INT_STR,0);

	assert int.gt(0,-1);
	assert !int.gt(0,1);
	assert !int.gt(1,1);
	assert int.gt(1,0);
	assert !int.gt(-1,0);
	assert !int.gt(BIG_NEG_STR,0);
	assert int.gt(BIG_INT_STR,0);

	assert int.ge(0,-1);
	assert !int.ge(0,1);
	assert int.ge(1,1);
	assert int.ge(1,0);
	assert !int.ge(-1,0);
	assert !int.ge(BIG_NEG_STR,0);
	assert int.ge(BIG_INT_STR,0);

	assert !int.eq(0,-1);
	assert !int.eq(0,1);
	assert int.eq(1,1);
	assert !int.eq(1,0);
	assert !int.eq(-1,0);
	assert !int.eq(BIG_NEG_STR,0);
	assert !int.eq(BIG_INT_STR,0);

	assert int.ne(0,-1);
	assert int.ne(0,1);
	assert !int.ne(1,1);
	assert int.ne(1,0);
	assert int.ne(-1,0);
	assert int.ne(BIG_NEG_STR,0);
	assert int.ne(BIG_INT_STR,0);
	true;

local test_min() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert std.assertEqual(int.min(1,0), 0);
	assert std.assertEqual(int.min(0,1), 0);
	assert std.assertEqual(int.min(-1,0), -1);
	assert std.assertEqual(int.min(0,-1), -1);
	assert std.assertEqual(int.min(BIG_NEG_STR,0), BIG_NEG_STR);
	assert std.assertEqual(int.min(BIG_INT_STR,-1), -1);
	true;

local test_max() =
	# We checked that cmp can deal with mixed strings and numbers, so no need to do it again.
	assert std.assertEqual(int.max(1,0), 1);
	assert std.assertEqual(int.max(0,1), 1);
	assert std.assertEqual(int.max(-1,0), 0);
	assert std.assertEqual(int.max(0,-1), 0);
	assert std.assertEqual(int.max(BIG_NEG_STR,0), 0);
	assert std.assertEqual(int.max(BIG_INT_STR,-1), BIG_INT_STR);
	true;

local test_splitSign() =
	assert std.assertEqual(int.splitSign(-5), [-1,5]);
	assert std.assertEqual(int.splitSign(0), [0,0]);
	assert std.assertEqual(int.splitSign(5), [1,5]);
	assert std.assertEqual(int.splitSign('-5'), [-1,'5']);
	assert std.assertEqual(int.splitSign('0'), [0,'0']);
	assert std.assertEqual(int.splitSign('5'), [1,'5']);
	assert std.assertEqual(int.splitSign(BIG_NEG_STR), [-1,BIG_INT_STR]);
	assert std.assertEqual(int.splitSign(BIG_INT_STR), [1,BIG_INT_STR]);
	true;

local test_toNumber() =
	assert std.assertEqual(int.toNumber(-5), -5);
	assert std.assertEqual(int.toNumber(0), 0);
	assert std.assertEqual(int.toNumber(5), 5);
	assert std.assertEqual(int.toNumber('-5'), -5);
	assert std.assertEqual(int.toNumber('0'), 0);
	assert std.assertEqual(int.toNumber('5'), 5);
	assert std.assertEqual(int.toNumber('12.34'), 12.34);
	true;

local test_isInt64() =
	assert int.isInt64(0);
	assert int.isInt64('0');
	assert int.isInt64(-9007199254740991);
	assert int.isInt64(9007199254740991);
	assert int.isInt64("-9223372036854775808");
	assert int.isInt64("9223372036854775807");
	assert !int.isInt64("-9223372036854775809");
	assert !int.isInt64("9223372036854775808");
	assert !int.isInt64(-9223372036854779000);
	assert !int.isInt64(9223372036854779000);
	true;

local test_isUInt64() =
	assert int.isUInt64(0);
	assert int.isUInt64('0');
	assert !int.isUInt64(-9007199254740991);
	assert int.isUInt64(9007199254740991);
	assert !int.isUInt64("-9223372036854775808");
	assert int.isUInt64("9223372036854775807");
	assert !int.isUInt64("-9223372036854775809");
	assert int.isUInt64("9223372036854775808");
	assert !int.isUInt64(-9223372036854779000);
	assert int.isUInt64(9223372036854779000);
	assert int.isUInt64("18446744073709551615");
	assert !int.isUInt64("18446744073709551616");
	true;

local test_neg() =
	assert std.assertEqual(int.neg(0), 0);
	assert std.assertEqual(int.neg('0'), '0');
	assert std.assertEqual(int.neg(-9007199254740991), 9007199254740991);
	assert std.assertEqual(int.neg(9007199254740991), -9007199254740991);
	assert std.assertEqual(int.neg("-9007199254740991"), "9007199254740991");
	assert std.assertEqual(int.neg("9007199254740991"), "-9007199254740991");
	true;

local test_abs() =
	assert std.assertEqual(int.abs(0), 0);
	assert std.assertEqual(int.abs('0'), '0');
	assert std.assertEqual(int.abs(-9007199254740991), 9007199254740991);
	assert std.assertEqual(int.abs(9007199254740991), 9007199254740991);
	assert std.assertEqual(int.abs("-9007199254740991"), "9007199254740991");
	assert std.assertEqual(int.abs("9007199254740991"), "9007199254740991");
	true;

local test_add() =
	assert std.assertEqual(int.add(0,1), 1);
	assert std.assertEqual(int.add(1,0), 1);
	assert std.assertEqual(int.add(0,-1), -1);
	assert std.assertEqual(int.add(-1,0), -1);
	assert std.assertEqual(int.add(-1,2), 1);
	assert std.assertEqual(int.add(1,-2), -1);
	assert std.assertEqual(int.add(1,2), 3);
	assert std.assertEqual(int.add(1,"9223372036854775806"), "9223372036854775807");
	assert std.assertEqual(int.add("4611686018427387903","4611686018427387903"),
		"9223372036854775806");
	assert std.assertEqual(int.add(-1,"-9223372036854775807"), "-9223372036854775808");
	assert std.assertEqual(int.add("-4611686018427387904","-4611686018427387904"),
		"-9223372036854775808");
	assert std.assertEqual(int.add("4611686018427387903","-4611686018427387903"), 0);
	assert std.assertEqual(int.add("9900000000000000",7199254740991), "9907199254740991");
	true;

local test_sub() =
	assert std.assertEqual(int.sub(0,1), -1);
	assert std.assertEqual(int.sub(1,0), 1);
	assert std.assertEqual(int.sub(0,-1), 1);
	assert std.assertEqual(int.sub(-1,0), -1);
	assert std.assertEqual(int.sub(-1,2), -3);
	assert std.assertEqual(int.sub(1,-2), 3);
	assert std.assertEqual(int.sub(1,2), -1);
	assert std.assertEqual(int.sub(3,2), 1);
	assert std.assertEqual(int.sub(1,"9223372036854775806"), "-9223372036854775805");
	assert std.assertEqual(int.sub("4611686018427387903","4611686018427387903"), 0);
	assert std.assertEqual(int.sub(-1,"-9223372036854775807"), "9223372036854775806");
	assert std.assertEqual(int.sub("-4611686018427387904","-4611686018427387904"), 0);
	assert std.assertEqual(int.sub("4611686018427387903","-4611686018427387903"),
		"9223372036854775806");
	true;

local test_mult() =
	assert std.assertEqual(int.mult(0,1), 0);
	assert std.assertEqual(int.mult(1,0), 0);
	assert std.assertEqual(int.mult(1,2), 2);
	assert std.assertEqual(int.mult(2,-1), -2);
	assert std.assertEqual(int.mult(-2,1), -2);
	assert std.assertEqual(int.mult(-2,-1), 2);
	assert std.assertEqual(int.mult(2,3), 6);
	assert std.assertEqual(int.mult(2,-3), -6);
	assert std.assertEqual(int.mult(-2,3), -6);
	assert std.assertEqual(int.mult(-2,-3), 6);
	assert std.assertEqual(int.mult(11,22), 242);
	assert std.assertEqual(int.mult(2,"10000000000004321"), "20000000000008642");
	assert std.assertEqual(int.mult("4611686018427387904",2), "9223372036854775808");
	assert std.assertEqual(int.mult("-4611686018427387904",2), "-9223372036854775808");
	assert std.assertEqual(int.mult("4611686018427387904",-2), "-9223372036854775808");
	assert std.assertEqual(int.mult("-4611686018427387904",-2), "9223372036854775808");
	assert std.assertEqual(int.mult(134572,134572), 18109623184);
	assert std.assertEqual(int.mult(135168,135168), 18270388224);
	assert std.assertEqual(int.mult(4294967295,4294967295), "18446744065119617025");
	true;

local test_divmod() =
	assert std.assertEqual(int.divmod(-1,0), null);
	assert std.assertEqual(int.divmod(0,0), null);
	assert std.assertEqual(int.divmod(1,0), null);
	assert std.assertEqual(int.divmod(0,1), [0,0]);
	assert std.assertEqual(int.divmod(2,1), [2,0]);
	assert std.assertEqual(int.divmod(3,2), [1,1]);
	assert std.assertEqual(int.divmod(245,22), [11,3]);
	assert std.assertEqual(int.divmod("9223372036854775808",2), ["4611686018427387904",0]);
	true;

{
	result:
		test_MIN_SAFE_INTEGER() && test_MAX_SAFE_INTEGER() && test_isBooleanStr() &&
		test_isUIntegerStr() && test_isIntegerStr() && test_isNumberStr() && test_isHexStr() &&
		test_isNotHugeInt() && test_safeParseInteger() && test_safeParseHex() &&
		test_safeParseNumber() && test_safeParseBoolean() && test_sign() && test_cmp() &&
		test_cmp2() && test_min() && test_max() && test_splitSign() && test_toNumber() &&
		test_isInt64() && test_isUInt64() && test_neg() && test_abs() && test_add() && test_sub() &&
		test_mult() && test_divmod()
}
