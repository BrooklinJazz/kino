defmodule Kino.JS.DataStoreTest do
  use ExUnit.Case, async: true

  alias Kino.JS.DataStore

  test "replies to connect messages with stored data" do
    ref = Kino.Output.random_ref()
    data = [1, 2, 3]
    DataStore.store(ref, data)

    send(DataStore, {:connect, self(), %{origin: self(), ref: ref}})
    assert_receive {:connect_reply, ^data, %{ref: ^ref}}
  end

  test "replies to connect messages with nil when no matching data is found" do
    ref = Kino.Output.random_ref()

    send(DataStore, {:connect, self(), %{origin: self(), ref: ref}})
    assert_receive {:connect_reply, nil, %{ref: ^ref}}
  end

  test "{:remove, ref} removes data for the given ref" do
    ref = Kino.Output.random_ref()
    data = [1, 2, 3]
    DataStore.store(ref, data)

    send(DataStore, {:remove, ref})

    send(DataStore, {:connect, self(), %{origin: self(), ref: ref}})
    assert_receive {:connect_reply, nil, %{ref: ^ref}}
  end
end
