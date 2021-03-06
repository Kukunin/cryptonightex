#include <cstdio>
#include <cstdint>
#include <unistd.h>

#include "crypto/CryptoNight_x86.h"

char *bin2hex(char* s, const unsigned char *p, size_t len)
{
  int i;

  for (i = 0; i < len; i++)
    sprintf(s + (i * 2), "%02x", (unsigned int) p[i]);

  return s;
}

bool hex2bin(unsigned char *p, const char *hexstr, size_t len)
{
  char hex_byte[3];
  char *ep;

  hex_byte[2] = '\0';

  while (*hexstr && len) {
    if (!hexstr[1]) {
      return false;
    }
    hex_byte[0] = hexstr[0];
    hex_byte[1] = hexstr[1];
    *p = (unsigned char) strtol(hex_byte, &ep, 16);
    if (*ep) {
      return false;
    }
    p++;
    hexstr += 2;
    len--;
  }

  return (len == 0 && *hexstr == 0) ? true : false;
}

static void cryptonight_v1_hash(const uint8_t *input, size_t size, uint8_t *output, struct cryptonight_ctx *ctx) {
  cryptonight_single_hash<MONERO_ITER, MONERO_MEMORY, MONERO_MASK, false, 0>(input, size, output, ctx);
}

static void cryptonight_v7_hash(const uint8_t *input, size_t size, uint8_t *output, struct cryptonight_ctx *ctx) {
  cryptonight_single_hash<MONERO_ITER, MONERO_MEMORY, MONERO_MASK, false, 1>(input, size, output, ctx);
}

void (*cryptonight_variations[2])(const uint8_t *input, size_t size, uint8_t *output, cryptonight_ctx *ctx) = {
  cryptonight_v1_hash,
  cryptonight_v7_hash
};

#define INPUT_SIZE 76
#define INPUT_HEX_SIZE INPUT_SIZE * 2
#define OUTPUT_SIZE 32
#define OUTPUT_HEX_SIZE OUTPUT_SIZE * 2

#define MODE_SIZE 1
#define PAYLOAD_SIZE MODE_SIZE + INPUT_HEX_SIZE

#define STDIN 0
#define STDOUT 1

int main(void) {
  int bytes_read;
  unsigned char payload[PAYLOAD_SIZE + 1];
  unsigned char* input_hex = payload + MODE_SIZE;
  input_hex[INPUT_HEX_SIZE] = '\0';

  unsigned char input[INPUT_SIZE];
  unsigned char output[OUTPUT_SIZE];
  char output_hex[OUTPUT_HEX_SIZE + 1];

  unsigned char mode;

  struct cryptonight_ctx *ctx = static_cast<cryptonight_ctx *>(_mm_malloc(sizeof(cryptonight_ctx), 16));
  ctx->memory = (uint8_t *) _mm_malloc(MONERO_MEMORY * 2, 16);

  while((bytes_read = read(STDIN, payload, PAYLOAD_SIZE))) {
    if (bytes_read != PAYLOAD_SIZE) {
      fprintf(stderr, "Expected to read %d bytes but did %d bytes.\n",
              PAYLOAD_SIZE, bytes_read);
      return 1;
    }
    if(!hex2bin(input, (const char *) input_hex, INPUT_SIZE)) {
      fprintf(stderr, "Can't parse input: %s\n", input_hex);
      return 2;
    }
    mode = *payload;
    if(mode < 0 || mode > 1) {
      fprintf(stderr, "Unrecognized mode: %d\n", mode);
      return 3;
    }

    cryptonight_variations[mode](input, INPUT_SIZE, output, ctx);

    bin2hex(output_hex, output, OUTPUT_SIZE);
    write(STDOUT, output_hex, OUTPUT_HEX_SIZE);
  }

  // Unreachable code, I know
  // But nonetheless
  _mm_free(ctx->memory);
  _mm_free(ctx);
  return 0;
}
