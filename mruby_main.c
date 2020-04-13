#include <stdio.h>

#include <mruby.h>
#include <mruby/irep.h>
#include <mruby/string.h>

#include <emscripten/emscripten.h>

static mrb_state* mrb;
static mrb_value game;

int EMSCRIPTEN_KEEPALIVE createGame() {
  mrb = mrb_open();
  if (!mrb) {
    fprintf(stderr, "mrb_open() failed");
    return 2;
  }

  mrb_value self = mrb_load_irep(mrb, ruby_app);
  game = mrb_funcall(mrb, self, "create_game", 0);

  if (mrb->exc) { mrb_print_error(mrb); }
  return 0;
}

int EMSCRIPTEN_KEEPALIVE gameCall(const char* method) {
  mrb_value result = mrb_funcall(mrb, game, method, 0);

  if (mrb->exc) { mrb_print_error(mrb); }
  return 0;
}

int EMSCRIPTEN_KEEPALIVE gameCallBoolean(const char* method) {
  mrb_value result = mrb_funcall(mrb, game, method, 0);
  if (mrb->exc) { mrb_print_error(mrb); }

  return mrb_test(result);
}

const char* EMSCRIPTEN_KEEPALIVE gameCallString(const char* method) {
  mrb_value result = mrb_funcall(mrb, game, method, 0);
  if (mrb->exc) { mrb_print_error(mrb); }

  if (mrb_string_p(result)) {
    return RSTRING_PTR(result);
  } else {
    return "";
  }
}

int EMSCRIPTEN_KEEPALIVE gameStep() {
  mrb_funcall(mrb, game, "step", 0);

  if (mrb->exc) { mrb_print_error(mrb); }
  return 0;
}

int EMSCRIPTEN_KEEPALIVE cleanupGame() {
  if (mrb->exc) { mrb_print_error(mrb); }
  mrb_close(mrb);
  return 0;
}

int main() {
  return createGame();
}
