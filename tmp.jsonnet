local bigint = import 'bigint.libjsonnet';

{
	#[f]: std.type(bigint[f]) for f in std.objectFieldsAll(bigint)
	badVal: std.toString(bigint.badVal)
}
