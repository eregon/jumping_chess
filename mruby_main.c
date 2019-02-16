#include <mruby.h>
#include <mruby/irep.h>

int main() {
  mrb_state *mrb = mrb_open();
  if (!mrb) { return 2; }
  mrb_load_irep(mrb, ruby_app);
  if (mrb->exc) { mrb_print_error(mrb); }
  mrb_close(mrb);
  return 0;
}
