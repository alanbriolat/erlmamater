#include "erl_nif.h"

unsigned long distance(unsigned char *a, unsigned char *b, unsigned long len)
{
    unsigned long score = 0;

    for (size_t i = 0; i < len; ++i)
        score += __builtin_popcount(a[i] ^ b[i]);

    return score;
}


static ERL_NIF_TERM distance_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary a, b;
    int score;
    enif_inspect_binary(env, argv[0], &a);
    enif_inspect_binary(env, argv[1], &b);
    score = distance(a.data, b.data, a.size);
    return enif_make_int(env, score);
}


static ErlNifFunc nif_funcs[] = {
    {"distance", 2, distance_nif}
};

ERL_NIF_INIT(erlmamater, nif_funcs, NULL, NULL, NULL, NULL)
