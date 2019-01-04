-module(server_manager).

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([get_servid/1]).
-export([get_store_type/1, get_disc_nodes/0]).

%% Callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {}).
-record(servers, {servid, locale, order, count}).

-define(SERVER, ?MODULE).
-define(TABLE, servers).
-define(MAX_USER, 5000).

%% API

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_servid(Locale) when is_list(Locale) -> get_servid(list_to_atom(Locale));
get_servid(Locale) ->
  case gen_server:call(?SERVER, {incr_locale, Locale}) of
    {ok, ServerOrder} -> gen_servid(Locale, ServerOrder);
    {error, Reason} -> throw(Reason)
  end.

gen_servid(Locale, ServerOrder) ->
  lists:flatten(io_lib:format("~p_~p", [Locale, ServerOrder])).

% Callbacks

init([]) ->
  copy_or_create_table(),
  {ok, #state{}}.

handle_call({incr_locale, Locale}, _From, State) ->
  case incr_user_with_locale(Locale) of
    {aborted, Reason} -> {reply, {error, Reason}, State};
    {ok, NewCount} -> {reply, {ok, NewCount}, State}
  end;
handle_call(_, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% Private

incr_user_with_locale(Locale) ->
  MatchSpec = #servers{
    servid = '_',
    locale = Locale,
    order  = '$1',
    count  = '$2'
  },
  Transaction = fun() ->
    Servers = mnesia:select(?TABLE, [{MatchSpec, [], ['$$']}]),
    [ServerOrder, UserCount] = lastest_serv(Servers),
    NewRecord = #servers{
      servid = gen_servid(Locale, ServerOrder),
      locale = Locale,
      order  = ServerOrder,
      count  = UserCount
    },
    ok = mnesia:write(NewRecord),
    ServerOrder
  end,
  case mnesia:transaction(Transaction) of
    {aborted, Reason} -> {error, Reason};
    {atomic, ServerOrder} -> {ok, ServerOrder}
  end.

lastest_serv(ServerList) ->
  lastest_serv(ServerList, [1, 0]).

lastest_serv([], [Order, Count]) ->
  case Count >= ?MAX_USER of
    true -> [Order + 1, 1];
    false -> [Order, Count + 1]
  end;
lastest_serv([[CurrentOrder, CurrentCount] | RestServer], [Order, Count]) ->
  case CurrentOrder >= Order of
    true -> lastest_serv(RestServer, [CurrentOrder, CurrentCount]);
    false -> lastest_serv(RestServer, [Order, Count])
  end.

copy_or_create_table() ->
  Schema = record_info(fields, servers),
  case mnesia:add_table_copy(?TABLE, node(), get_store_type(node())) of
    {aborted, {no_exists, _}} -> create_table(?TABLE, Schema, set);
    {aborted, {already_exists, _, _}} -> ?TABLE;
    {_, ok} -> ?TABLE
  end.

create_table(Table, Schema, Type) ->
  case mnesia:create_table(Table, [{attributes, Schema}, {type, Type}, {disc_copies, get_disc_nodes()}]) of
    {aborted, Reason} -> throw(Reason);
    {_, ok} -> Table
  end.


get_store_type(Node) ->
  case lists:member(Node, get_disc_nodes()) of
                true ->
                  disc_copies;
                false ->
                  ram_copies
              end.

get_disc_nodes() ->
  {ok, MasterNodes} = application:get_env(cluster_server, master_nodes),
  lists:filter(fun(N) ->
                   net_adm:ping(N) =:= pong
               end, MasterNodes).
