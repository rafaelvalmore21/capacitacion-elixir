defmodule CourseManager do
  use GenServer
  alias __MODULE__

  @file_path "cursos.json"

  # Client API

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_course(course_name) do
    GenServer.call(__MODULE__, {:add_course, course_name})
  end

  def remove_course(course_name) do
    GenServer.call(__MODULE__, {:remove_course, course_name})
  end

  def list_courses do
    GenServer.call(__MODULE__, :list_courses)
  end

  # Server Callbacks

  @impl true
  def init(:ok) do
    courses = load_courses()
    {:ok, courses}
  end

  @impl true
  def handle_call({:add_course, course_name}, _from, state) do
    if course_name in state do
      {:reply, {:error, "Course already exists"}, state}
    else
      new_state = [course_name | state]
      save_courses(new_state)
      {:reply, :ok, new_state}
    end
  end

  @impl true
  def handle_call({:remove_course, course_name}, _from, state) do
    if course_name in state do
      new_state = List.delete(state, course_name)
      save_courses(new_state)
      {:reply, :ok, new_state}
    else
      {:reply, {:error, "Course not found"}, state}
    end
  end

  @impl true
  def handle_call(:list_courses, _from, state) do
    {:reply, Enum.reverse(state), state}
  end

  # Helper functions

  defp load_courses do
    case File.read(@file_path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, courses} -> courses
          _ -> []
        end
      _ -> []
    end
  end

  defp save_courses(courses) do
    case Jason.encode(courses) do
      {:ok, json} ->
        File.write(@file_path, json)  # Escribir el contenido JSON en el archivo
      _ ->
        IO.puts("Error al guardar las materias en el archivo.")
    end
  end
end
