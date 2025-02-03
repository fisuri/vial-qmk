#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT(
 //╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷
              KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,                          KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,  
    KC_TAB,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,                          KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,
    KC_LSFT,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_MUTE,   KC_MPLY,  KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT,
                                  KC_ESC,   KC_TAB,   KC_ENT,   KC_LALT,   KC_LGUI,  KC_SPC,   KC_BSPC,  KC_DEL
 ),

 [1] = LAYOUT(
 //╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷
              KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,                          KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,  
    KC_TAB,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,                          KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,
    KC_LSFT,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_MUTE,   KC_MPLY,  KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT,
                                  KC_ESC,   KC_TAB,   KC_ENT,   KC_LALT,   KC_LGUI,  KC_SPC,   KC_BSPC,  KC_DEL
 ),

 [2] = LAYOUT(
  //╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷
              KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,                          KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,  
    KC_TAB,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,                          KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,
    KC_LSFT,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_MUTE,   KC_MPLY,  KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT,
                                  KC_ESC,   KC_TAB,   KC_ENT,   KC_LALT,   KC_LGUI,  KC_SPC,   KC_BSPC,  KC_DEL
 ),

 [3] = LAYOUT(
  //╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷╷         ╷         ╷         ╷         ╷         ╷         ╷         ╷
              KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,                          KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,  
    KC_TAB,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,                          KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,
    KC_LSFT,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_MUTE,   KC_MPLY,  KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT,
                                  KC_ESC,   KC_TAB,   KC_ENT,   KC_LALT,   KC_LGUI,  KC_SPC,   KC_BSPC,  KC_DEL
 )
};

#ifdef ENCODER_MAP_ENABLE

  const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][2] = {
      [0] =   { ENCODER_CCW_CW(KC_MS_WH_UP, KC_MS_WH_DOWN), ENCODER_CCW_CW(KC_VOLD, KC_VOLU)  },
      [1] =   { ENCODER_CCW_CW(RGB_HUD, RGB_HUI),           ENCODER_CCW_CW(RGB_SAD, RGB_SAI)  },
      [2] =   { ENCODER_CCW_CW(RGB_VAD, RGB_VAI),           ENCODER_CCW_CW(RGB_SPD, RGB_SPI)  },
      [3] =   { ENCODER_CCW_CW(RGB_RMOD, RGB_MOD),          ENCODER_CCW_CW(KC_RIGHT, KC_LEFT) },
      //                  Encoder 1                                     Encoder 2
  };

#endif
