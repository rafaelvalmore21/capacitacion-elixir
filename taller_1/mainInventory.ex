# Definimos el modulo InventoryManager
defmodule InventoryManager do
  # Se define la estructura
  defstruct products: []

  # Función para agregar productos
  def add_product(inventory_manager, name, price, stock) do
    # Obtenemos los productos
    products = inventory_manager.products
    id = length(products) + 1
    # Creamos el map
    product = %{id: id, name: name, price: price, stock: stock}
    # Se actualiza la estructura con el nuevo producto
    %InventoryManager{products: products ++ [product]}
  end

  # Función para listar todos los productos
  def list_products(inventory_manager) do
    # Itera la lista e imprime
    Enum.each(inventory_manager.products, fn product ->
      IO.puts("#{product.id}. - Nombre: #{product.name} - Precio: #{product.price} - Cantidad: #{product.stock}")
    end)
  end

  def increase_stock(inventory_manager, id, quantity) do
    # Actualiza aumentando el stock del producto seleccionado
    updated_products = Enum.map(inventory_manager.products, fn product ->
      if product.id == id do
        Map.put(product, :stock, product.stock + quantity)
      else
        product
      end
    end)
    # Retorna la estructura actualizada
    %InventoryManager{products: updated_products}
  end

  # Función para reducir el stock de un producto
  def decrease_stock(inventory_manager, id, quantity) do
    # Buscamos por Id
    product_index = Enum.find_index(inventory_manager.products, fn p -> p.id == id end)

    # Validamos si existe el producto
    if product_index != nil do
      # Obtenemos el producto de la lista
      product = Enum.at(inventory_manager.products, product_index)

      # Validamos el stock
      if product.stock >= quantity do
        # Actualizamos el stock del producto
        updated_product = Map.put(product, :stock, product.stock - quantity)
        updated_products = List.replace_at(inventory_manager.products, product_index, updated_product)

        # Retornamos la estructura actualizada
        {:ok, %InventoryManager{inventory_manager | products: updated_products}}
      else
        {:error, "Stock insuficiente para el producto #{product.name}"}
      end
    else
      {:error, "Producto no encontrado"}
    end
  end

  # Ejecución del modulo InventoryManager
  def run do
    # Inicializació vacia de InventoryManager
    inventory_manager = %InventoryManager{}
    # Inicio
    loop(inventory_manager)
  end

  # Menu principal
  defp loop(inventory_manager) do
    IO.puts("""
    Gestor de Inventario

    1. Agregar Producto
    2. Listar Productos
    3. Aumentar Stock
    4. Reducir Stock por producto
    5. Agregar al carrito
    6. Ver carrito y vaciar
    7. Pagar
    8. Salir
    """)

    # Get user input
    IO.write("Seleccione una opción: ")
    option = String.trim(IO.gets(""))
    option = String.to_integer(option)

    # Opciones del usuario
    if option == 1 do
      IO.write("Ingrese el nombre del producto: ")
      name = String.trim(IO.gets(""))
      IO.write("Ingrese el precio del producto: ")
      price = String.trim(IO.gets(""))
      #price = String.to_float(price)
      IO.write("Ingrese la cantidad del producto: ")
      stock = String.trim(IO.gets(""))
      stock = String.to_integer(stock)
      inventory_manager = add_product(inventory_manager, name, price, stock)
      loop(inventory_manager)
    else
      if option == 2 do
        list_products(inventory_manager)
        loop(inventory_manager)
      else
        if option == 3 do
          IO.write("Ingrese el ID del producto a aumentar stock: ")
          id = String.trim(IO.gets(""))
          id = String.to_integer(id)
          IO.write("Ingrese la cantidad a aumentar: ")
          quantity = String.trim(IO.gets(""))
          quantity = String.to_integer(quantity)
          inventory_manager = increase_stock(inventory_manager, id, quantity)
          loop(inventory_manager)
        else
          if option == 4 do
            IO.write("Ingrese el ID del producto a reducir stock: ")
            id = String.trim(IO.gets(""))
            id = String.to_integer(id)
            IO.write("Ingrese la cantidad a reducir: ")
            quantity = String.trim(IO.gets(""))
            quantity = String.to_integer(quantity)

            case decrease_stock(inventory_manager, id, quantity) do
              {:ok, updated_inventory} ->
                loop(updated_inventory)
              {:error, message} ->
                IO.puts(message)
                loop(inventory_manager)
            end
          else
            if option == 8 do
              IO.puts("¡Adiós!")
            else
              IO.puts("Opción no válida.")
              loop(inventory_manager)
            end
          end
        end
      end
    end
  end
end

# Ejecuta Inventory Manager
InventoryManager.run()
