defmodule GossiperlExampleElixirTest do
  use ExUnit.Case

  @overlay_name <<"gossiper_overlay_remote">>
  @overlay_port 6666
  @client_name <<"exlixir-client">>
  @client_port 54321
  @client_secret <<"elixir-client-secret">>
  @symmetric_key <<"v3JElaRswYgxOt4b">>
  @subscriptions [ :member_in, :member_out ]

  setup do
    applications = [ :asn1, :crypto, :public_key, :erlsha2, :jsx, :thrift,
                     :quickrand, :uuid, :syntax_tools, :compiler,
                     :goldrush, :lager, :gossiperl_client ]
    for app <- applications, do: :application.start(app)
    :ok
  end

  test "process test" do
    connect_response = :gossiperl_client_sup.connect( [ { :overlay_name, @overlay_name },
                                                        { :overlay_port, @overlay_port },
                                                        { :client_name, @client_name },
                                                        { :client_port, @client_port },
                                                        { :client_secret, @client_secret },
                                                        { :symmetric_key, @symmetric_key } ] )
    assert {:ok, _} = connect_response
    :timer.sleep(3000)
    assert :operational = :gossiperl_client_sup.check_state( @overlay_name )
    
    subscribe_reponse = :gossiperl_client_sup.subscribe( @overlay_name, @subscriptions )
    assert {ok, subscriptions} = subscribe_reponse
    :timer.sleep(1000)
    assert @subscriptions = :gossiperl_client_sup.subscriptions( @overlay_name )
    
    unsubscribe_reponse = :gossiperl_client_sup.unsubscribe( @overlay_name, @subscriptions )
    assert {ok, subscriptions} = unsubscribe_reponse
    :timer.sleep(1000)
    assert [] = :gossiperl_client_sup.subscriptions( @overlay_name )
    
    unsubscribe_reponse = :gossiperl_client_sup.disconnect( @overlay_name )
    assert :ok = unsubscribe_reponse
    :timer.sleep(3000)
  end

  test "custom serialization" do
    digest_type = :someCustomDigest
    digest_data = [ { :some_data, <<"some data to send">>, :string, 1 },
                    { :some_port_number, 1234, :i32, 2 } ]
    digest_id = <<"some-digest-id">>
    digest_info = [ { 1, :string }, { 2, :i32 } ]

    # serialize:
    serialize_result = :gen_server.call( :gossiperl_client_serialization, { :serialize, digest_type, digest_data, digest_id } )
    assert { ok, digest_type, _ } = serialize_result
    { :ok, digest_type, binary_envelope } = serialize_result
    assert is_binary( binary_envelope )

    # deserialize:
    deserialized_result = :gen_server.call( :gossiperl_client_serialization, { :deserialize, digest_type, binary_envelope, digest_info } )
    assert { ok, digest_type, _ } = deserialized_result
    { :ok, digest_type, custom_digest } = deserialized_result
    assert { <<"some data to send">>, 1234 } = custom_digest
  end

end
