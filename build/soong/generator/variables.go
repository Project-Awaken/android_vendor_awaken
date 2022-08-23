package generator

import (
	"fmt"

	"android/soong/android"
)

func awakenExpandVariables(ctx android.ModuleContext, in string) string {
	awakenVars := ctx.Config().VendorConfig("awakenVarsPlugin")

	out, err := android.Expand(in, func(name string) (string, error) {
		if awakenVars.IsSet(name) {
			return awakenVars.String(name), nil
		}
		// This variable is not for us, restore what the original
		// variable string will have looked like for an Expand
		// that comes later.
		return fmt.Sprintf("$(%s)", name), nil
	})

	if err != nil {
		ctx.PropertyErrorf("%s: %s", in, err.Error())
		return ""
	}

	return out
}
