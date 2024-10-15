defmodule CourseApp do
  alias CourseManager

  def start do
    # Iniciar el supervisor
    {:ok, _sup_pid} = CourseSupervisor.start_link()
  end

  def add_course(course_name) do
    case CourseManager.add_course(course_name) do
      :ok -> IO.puts("Course '#{course_name}' added successfully.")
      {:error, reason} -> IO.puts("Failed to add course: #{reason}")
    end
  end

  def remove_course(course_name) do
    case CourseManager.remove_course(course_name) do
      :ok -> IO.puts("Course '#{course_name}' removed successfully.")
      {:error, reason} -> IO.puts("Failed to remove course: #{reason}")
    end
  end

  def list_courses do
    courses = CourseManager.list_courses()
    IO.puts("Current courses:")
    Enum.each(courses, &IO.puts("- #{&1}"))
  end
end

### Pasos para el uso

### Ejecute para instalar dependencias
# mix deps.get

### inicializar iex
# iex -S mix

### Iniciar la aplicación
# CourseApp.start()

### Agregar materias
# CourseApp.add_course("Matemáticas")
# CourseApp.add_course("Física")
# CourseApp.add_course("Química")

### Listar materias
# CourseApp.list_courses()

# Verifica si el archivo courses.json se ha creado en el directorio actual
