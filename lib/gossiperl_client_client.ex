defmodule GossiperlClientElixir do

  def connect( %{ :overlay_name => overlay_name,
                  :overlay_port => overlay_port,
                  :client_name => client_name,
                  :client_port => client_port,
                  :client_secret => client_secret,
                  :symmetric_key => symmetric_key } ) do
    connect( %{ :overlay_name => overlay_name,
                :overlay_port => overlay_port,
                :client_name => client_name,
                :client_port => client_port,
                :client_secret => client_secret,
                :symmetric_key => symmetric_key }, :undefined )
  end

  def connect( %{ :overlay_name => overlay_name,
                  :overlay_port => overlay_port,
                  :client_name => client_name,
                  :client_port => client_port,
                  :client_secret => client_secret,
                  :symmetric_key => symmetric_key },
               listener ) when is_binary( overlay_name )
                               and is_binary( client_name )
                               and is_binary( client_secret )
                               and is_binary( symmetric_key )
                               and is_integer( overlay_port )
                               and is_integer( client_port )
                               and ( is_pid( listener ) or listener == :undefined ) do
    :gossiperl_client_sup.connect( [ { :overlay_name, overlay_name },
                                     { :overlay_port, overlay_port },
                                     { :client_name, client_name },
                                     { :client_port, client_port },
                                     { :client_secret, client_secret },
                                     { :symmetric_key, symmetric_key },
                                     { :listener, listener } ] )
  end

  def disconnect(overlay_name) when is_binary(overlay_name) do
    :gossiperl_client_sup.disconnect( overlay_name )
  end

  def check_state(overlay_name) when is_binary(overlay_name) do
    :gossiperl_client_sup.check_state( overlay_name )
  end

  def subscriptions(overlay_name) when is_binary(overlay_name) do
    :gossiperl_client_sup.subscriptions( overlay_name )
  end

  def subscribe(overlay_name, event_types) when is_binary(overlay_name) and is_list(event_types) do
    :gossiperl_client_sup.subscribe( overlay_name, event_types )
  end

  def unsubscribe(overlay_name, event_types) when is_binary(overlay_name) and is_list(event_types) do
    :gossiperl_client_sup.unsubscribe( overlay_name, event_types )
  end

  def send(overlay_name, digest_type, digest_data) when is_binary(overlay_name)
                                                        and is_atom(digest_type)
                                                        and is_list(digest_data) do
    :gossiperl_client_sup.send( overlay_name, digest_type, digest_data )
  end

  def read(digest_type, binary_envelope, digest_info) when is_atom(digest_type)
                                                        and is_binary(binary_envelope)
                                                        and is_list(digest_info) do
    :gossiperl_client_sup.read( digest_type, binary_envelope, digest_info )
  end

end
