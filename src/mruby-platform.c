#include <mruby.h>

void mrb_mruby_jumping_chess_gem_init(mrb_state* mrb) {
  mrb_define_global_const(mrb, "MRUBY_PLATFORM",
    mrb_str_new_lit(mrb, MRB_STRINGIZE(MRUBY_PLATFORM)));
}

void mrb_mruby_jumping_chess_gem_final(mrb_state* mrb) {
}
