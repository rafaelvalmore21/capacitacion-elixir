defmodule SocialNetwork do
  @moduledoc """
  Módulo que representa una red social que maneja seguidores y notificaciones de nuevas publicaciones.
  """

  @doc """
  Inicia el proceso de la red social.
  """
  def start do
    spawn(fn -> loop([], []) end)
  end

  @doc """
  Añade un nuevo seguidor a un usuario de la red social.

  ## Parámetros
  - `network_pid`: PID del proceso de la red social.
  - `follower_pid`: PID del proceso del seguidor.
  """
  def follow(network_pid, follower_pid) do
    send(network_pid, {:follow, follower_pid})
  end

  @doc """
  Elimina un seguidor de un usuario de la red social.

  ## Parámetros
  - `network_pid`: PID del proceso de la red social.
  - `follower_pid`: PID del proceso del seguidor.
  """
  def unfollow(network_pid, follower_pid) do
    send(network_pid, {:unfollow, follower_pid})
  end

  @doc """
  Publica un nuevo post en la red social.

  ## Parámetros
  - `network_pid`: PID del proceso de la red social.
  - `post`: Contenido del post a publicar.
  """
  def post(network_pid, post) do
    send(network_pid, {:post, post})
  end

  @doc """
  Solicita la lista de posts de la red social.

  ## Parámetros
  - `network_pid`: PID del proceso de la red social.
  """
  def list_posts(network_pid) do
    send(network_pid, {:list_posts, self()})
    receive do
      {:posts, posts} -> posts
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc false
  defp loop(followers, posts) do
    receive do
      {:follow, follower_pid} ->
        IO.puts("New follower added")
        loop([follower_pid | followers], posts)

      {:unfollow, follower_pid} ->
        IO.puts("Follower removed")
        loop(List.delete(followers, follower_pid), posts)

      {:post, post} ->
        IO.puts("Publishing new post: #{post}")
        new_posts = [post | posts]
        Enum.each(followers, fn follower ->
          send(follower, {:new_post, post})
        end)
        loop(followers, new_posts)

      {:list_posts, sender_pid} ->
        send(sender_pid, {:posts, Enum.reverse(posts)})
        loop(followers, posts)

      _ ->
        IO.puts("Invalid Message")
        loop(followers, posts)
    end
  end
end

defmodule User do
  @moduledoc """
  Módulo que representa a un usuario de la red social.
  """

  ## Parámetros
  # - `name`: Nombre del usuario.

  # Inicia un proceso de usuario.
  def start(name) do
    spawn(fn -> loop(name) end)
  end

  @doc false
  def loop(name) do
    receive do
      {:new_post, post} ->
        IO.puts("#{name} Recepcion de nuevo post: #{post}")
        loop(name)

      _ ->
        IO.puts("Mensaje invalido")
        loop(name)
    end
  end
end

# Ejemplo de uso
# network_pid = SocialNetwork.start()

# user1 = User.start("Andrea")
# user2 = User.start("Carlos")

# SocialNetwork.follow(network_pid, user1)
# SocialNetwork.follow(network_pid, user2)

# SocialNetwork.post(network_pid, "Hola, Andrea")
# IO.inspect SocialNetwork.list_posts(network_pid)
# SocialNetwork.unfollow(network_pid, user1)

# SocialNetwork.post(network_pid, "Hola, Carlos")
# IO.inspect SocialNetwork.list_posts(network_pid)
# SocialNetwork.unfollow(network_pid, user2)
