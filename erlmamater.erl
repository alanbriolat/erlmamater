-module(erlmamater).
-export([hash/1, score/1, random_string/2, find_best/1]).
-on_load(init/0).

-define(HASH_SIZE, 1024).
-define(XKCD_HASH, <<16#5b4da95f5fa08280fc9879df44f418c8f9f12ba424b7757de02bbdfbae0d4c4fdf9317c80cc5fe04c6429073466cf29706b8c25999ddd2f6540d4475cc977b87f4757be023f19b8f4035d7722886b78869826de916a79cf9c94cc79cd4347d24b567aa3e2390a573a373a48a5e676640c79cc70197e1c5e7f902fb53ca1858b6:?HASH_SIZE>>).
-define(CHARS, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").
-define(CHARS_LEN, length(?CHARS)).


init() ->
    erlang:load_nif("./erlmamater", 0).


distance(_A, _B) ->
    exit(nif_library_not_loaded).


hash(String) ->
    {ok, Hash} = skerl:hash(1024, String),
    Hash.


score(Hash) ->
    distance(Hash, ?XKCD_HASH).


random_string(Min, Max) ->
    Length = Min + random:uniform(Max - Min + 1) - 1,
    [lists:nth(random:uniform(?CHARS_LEN), ?CHARS) || _ <- lists:seq(1, Length)].


find_best({Min, Max}, Best) ->
    String = random_string(Min, Max),
    Hash = hash(list_to_binary(String)),
    Score = score(Hash),
    case Score < Best of
        true ->
            io:format("New best string \"~s\" with score ~w (previous ~w)~n", [String, Score, Best]),
            find_best({Min, Max}, Score);
        false ->
            find_best({Min, Max}, Best)
    end.


find_best({Min, Max}) ->
    find_best({Min, Max}, ?HASH_SIZE + 1).
