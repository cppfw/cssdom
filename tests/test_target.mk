ifeq ($(os),windows)
    # to avoid /C converted to C:\ need to escape it as //C
    this_test_cmd := (cd $(d) && cmd //C 'set PATH=../../src/build;%PATH% && $(this_out_dir)/$$(notdir $$^)')
else ifeq ($(os),macosx)
    this_test_cmd := (cd $(d) && DYLD_LIBRARY_PATH=../../src/build $(this_out_dir)/$$(notdir $$^))
else ifeq ($(os),linux)
    this_test_cmd := (cd $(d) && LD_LIBRARY_PATH=../../src/build $(this_out_dir)/$$(notdir $$^))
else
    $(error "Unknown OS")
endif

this_dirs := $(subst /, ,$(d))
this_test := $(word $(words $(this_dirs)), $(this_dirs))

define this_rule
test:: $(prorab_this_name)
$(.RECIPEPREFIX)@myci-running-test.sh $(this_test)
$(.RECIPEPREFIX)$(a)$(this_test_cmd) || myci-error.sh "test failed"
$(.RECIPEPREFIX)@myci-passed.sh
endef
$(eval $(this_rule))

ifeq ($(os),windows)
    # to avoid /C converted to C:\ need to escape it as //C
    this_gdb_cmd := (cd $(d) && cmd //C 'set PATH=../../src/build;%PATH% && gdb $(this_out_dir)/$$(notdir $$^)')
else ifeq ($(os),macosx)
    this_gdb_cmd := (cd $(d) && DYLD_LIBRARY_PATH=../../src/build gdb $(this_out_dir)/$$(notdir $$^))
else ifeq ($(os),linux)
    this_gdb_cmd := (cd $(d) && LD_LIBRARY_PATH=../../src/build gdb $(this_out_dir)/$$(notdir $$^))
endif

define this_rule
gdb:: $(prorab_this_name)
$(.RECIPEPREFIX)$(a)$(this_gdb_cmd)
endef
$(eval $(this_rule))
